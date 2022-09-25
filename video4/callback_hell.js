
const callback = (err, data) => {
    // console.log('Calling callback', err, data);
    
    if (err) {
        console.log('Callback is err:', err);
    } 
    if (data) {
        console.log('Callback is data:', data);
    }
}



function getTodos(id, callback) {


var request = new XMLHttpRequest();
request.onreadystatechange = function() {
    if (this.readyState === 4 && this.status === 200) {
       // Typical action to be performed when the document is ready:
       //console.log('Show respone:', xhttp.responseText) ;
       //console.log('Show data:', request);
       //const data = request.responseText;

        const data = JSON.parse(request.responseText); //conver text >>> Json
        const datatring = JSON.stringify(data)  // conver jon >>> text

       callback(undefined,data);
       callback(undefined,datatring);
    } 
    
    if (this.readyState === 4 && this.status !== 200) {
        callback('Data is fail ', undefined);
    }

    
    // else {
    //     console.log('>>>>> status:', request.status);
    // }
};

request.open("GET", `https://jsonplaceholder.typicode.com/todos/${id}`, true);

request.send();

}
getTodos(1,callback);
getTodos(2,callback);




