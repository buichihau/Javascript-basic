console.log('Hello Hau');

let sum = (a, b, callback) => {
    let tong = a + b;
    setTimeout(() => {
        callback(tong);
    }, 5000)
    
};

console.log('')


let printsum = (message) => {
    console.log('>>> check sum: ', message)
};

sum(4,5,printsum);
