console.log('Hello world frm HTML');

let person = {
    name: 'Hau',
    lastName: 'Bui',
    address: 'dak lak',
    phone_number: 0344171555,
    fullname: function(x){
        return this.name + " " + x + " " + this.lastName;
    }

};
let b = 'name';

person[b] = 'hihi';
person.b ='hcm';

console.log('type of person :', typeof person , 'type of b:', typeof b);

//console.log(`I'm ${person.name} from ${person.address}`);

console.log("I'm", person['name'], 'from', person['address']);

//console.log(`Fullname: ${person.fullname(123)}`);