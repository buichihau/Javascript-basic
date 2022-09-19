console.log('Hello Chi Hau');

let sum = (a, b) => {
    return a + b;
};

console.log('Check sum: ', sum(4,5));

//function vs method


let object = {
    name: 'Hau',
    address: 'Ho Chi Minh',
    getName: function(){
        return this.name;
    }
};


console.log(object.getName()); //method