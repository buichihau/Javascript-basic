console.log('Hello Men');

let arr = ['Iphone','Samsung','Oppo','Nokia'];

var i = 0;

while ( i < arr.length) {
    //if else
    if ( arr[i] === 'Nokia') {

     console.log('TOP', i + 1, ':', arr[i]);   
    }
    else if (arr[i].length === 4){
        console.log('TOP', i + 1, ':', arr[i]);     
    }
    else {
        
    }

    i++;
}
