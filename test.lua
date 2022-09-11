--	ivr_menu.lua
--	Part of FusionPBX
--	Copyright (C) 2012-2015 Mark J Crane <markjcrane@fusionpbx.com>
--	All rights reserved.
--
--	Redistribution and use in source and binary forms, with or without
--	modification, are permitted provided that the following conditions are met:
--
--	1. Redistributions of source code must retain the above copyright notice,
--	this list of conditions and the following disclaimer.
--
--	2. Redistributions in binary form must reproduce the above copyright
--	notice, this list of conditions and the following disclaimer in the
--	documentation and/or other materials provided with the distribution.
--
--	THIS SOFTWARE IS PROVIDED ''AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
--	INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
--	AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
--	AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
--	OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
--	SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
--	INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
--	CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
--	ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
--	POSSIBILITY OF SUCH DAMAGE.
require "try-catch"
require "omi_utils"
--set the debug options
	debug["action"] = false;
	debug["sql"] = false;
	debug["regex"] = false;
	debug["dtmf"] = false;
	debug["tries"] = false;

--include config.lua
	require "resources.functions.config";

--include Database class
	local Database = require "resources.functions.database";

--get logger
	local log = require "resources.functions.log".ivr_menu

--include json library
	local json
	json = require "resources.functions.lunajson"

--include functions
	require "resources.functions.format_ringback"
	require "resources.functions.split"
	
	local extension = argv[1] or '';
	local phone_number = argv[2] or '';
	local phone_number_out = argv[3] or '';
	local gateway_uuid = argv[4] or '';
	local domain_name = argv[5] or '';
	--local domain_uuid = argv[6] or '';
	local uuid = argv[6] or '';
	local dial_string = argv[7] or '';
	
	presence_id = extension.."@"..domain_name;
	--local dial_string = dial_string .. "{ignore_display_updates=true,origination_caller_id_name="..phone_number..",origination_caller_id_number="..phone_number.."}[sip_invite_domain="..domain_name..",presence_id="..presence_id..",dialed_extension=" .. extension;
	
	if(domain_name == 'buichihau981') then
	   local dial_string = dial_string .. "{ignore_display_updates=true,origination_caller_id_name="..phone_number..",origination_caller_id_number="..phone_number.."}[sip_invite_domain="..domain_name..",presence_id="..presence_id..",dialed_extension=" .. extension;
		else 
	   local dial_string = dial_string .. "{ignore_display_updates=true}[sip_invite_domain="..domain_name..",presence_id="..presence_id..",dialed_extension=" .. extension;
	end
	
	
	--presence_id = "103@"..domain_name;
	--dial_string = dial_string .. ":_:{ignore_display_updates=true}[sip_invite_domain="..domain_name..",presence_id="..presence_id..",dialed_extension=103]user/103@"..domain_name;
	if tonumber(#extension) < 5 then
		--dbh_switch = Database.new('switch');
		
		urlCdr = "http://push-v1-stg.svc.omicrm.services/push/sendPushNotification?domain_name="..domain_name.."&extension="..extension.."&variable_sip_call_id="..uuid.."&variable_sip_to_user="..extension.."&variable_outbound_caller_id_number="..phone_number.."&username=OMI_VIHAT&password=yQttR2fHt%7E%2BWC%5Dr%2B";
	
		freeswitch.consoleLog("INFO","OMI url = ".. urlCdr .."\n");
		api = freeswitch.API();
		local curl_response_data = api:execute("curl", urlCdr);
		--freeswitch.consoleLog("ERR","trungnt:curl_response_data click_to_call:"..curl_response_data.."\n");
		--session:execute("curl", urlCdr);
		is_wait_wakeup = "";
		urlPushCancel = "";
		--set_uuid = "";
		set_uuid = ",sip_ph_uuid="..uuid..",sip_h_uuid="..uuid..",sip_rh_uuid="..uuid;
		is_clicktocall = ",sip_ph_remote_phone_number="..phone_number..",sip_h_remote_phone_number="..phone_number..",sip_rh_remote_phone_number="..phone_number;
		if(curl_response_data ~= nil and curl_response_data ~= "") then
			is_wait_wakeup = ",sip_h_is_wait_wakeup=true,sip_ph_is_wait_wakeup=true,sip_rh_is_wait_wakeup=true";
			--set_uuid = ",sip_ph_uuid="..uuid..",sip_h_uuid="..uuid..",sip_rh_uuid="..uuid;
			--session:execute("export", "sip_h_is_wait_wakeup=true");
			--session:execute("export", "sip_ph_is_wait_wakeup=true");
			--session:execute("export", "sip_rh_is_wait_wakeup=true");
			urlPushCancel = " https://push-v1-stg.svc.omicrm.services/push/sendPushNotificationV2WithType?domain_name="..domain_name.."&extension="..extension.."&variable_sip_call_id=" .. uuid  .. "&variable_sip_to_user=" .. extension  .. "&variable_outbound_caller_id_number=" .. phone_number.."&username=OMI_VIHAT&password=yQttR2fHt%7E%2BWC%5Dr%2B&type=voip_cancel";
			--session:execute("export", "nolocal:execute_on_answer_2=lua set_anwer_destination.lua "..variable_sip_call_id.." "..urlPushCancel);
		end
	end
	dial_string = dial_string .. is_wait_wakeup .. set_uuid .. is_clicktocall .. ",execute_on_answer_1='lua set_anwer_destination.lua " .. uuid .. urlPushCancel .. "'" .. "]user/"..extension.."@"..domain_name;
	session = freeswitch.Session(dial_string);
	--session = originate(extension, domain_name, domain_uuid, dial_string, dbh);
	--session:waitForAnswer(10000);

	if session:ready() then
		session:setAutoHangup(true);
		ivr_menu_ringback = "local_stream://default";
		session:setVariable("ringback", ivr_menu_ringback);
		session:setVariable("transfer_ringback", ivr_menu_ringback);
		session:setVariable("effective_caller_id_name", phone_number_out);
		session:setVariable("effective_caller_id_number", phone_number_out);
		session:setVariable("outbound_caller_id_name", phone_number_out);
		session:setVariable("outbound_caller_id_number", phone_number_out);
		session:setVariable("sip_h_sip_number", phone_number_out);
		session:setVariable("call_direction", "outbound");
		session:setVariable("caller_destination", phone_number);
		session:setVariable("destination_number", phone_number);
		session:execute("set", "sip_ph_uuid=${uuid}");
		session:execute("set", "sip_h_uuid=${uuid}");
		session:execute("set", "sip_rh_uuid=${uuid}");
		session:execute("ring_ready", "");
		session:execute("set", "record_path=${recordings_dir}");
		session:execute("set", "record_name=/${domain_name}/archive/${strftime(%Y)}/${strftime(%b)}/${strftime(%d)}/${uuid}.${record_ext}");
		session:execute("export", "RECORD_STEREO=false");
		session:execute("set", "is_stereo=0");
		session:execute("export", "nolocal:api_on_answer_2=uuid_record ${uuid} start ${record_path}/${record_name}");
		
		session:execute("bridge", "{ignore_display_updates=true}sofia/gateway/"..gateway_uuid.."/"..phone_number);
		
		return;
	else   
		-- This means the call was not answered ... Check for the reason
		local obCause = session:hangupCause();
		freeswitch.consoleLog("ERR", "obSession:hangupCause() = " .. obCause );
	end
	if(dbh) then
		dbh:release();
	end