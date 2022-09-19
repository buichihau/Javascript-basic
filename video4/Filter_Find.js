console.log('Hello Hau');

let arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

//filter, find

let filter = arr.filter((item, index) => {
    
    return item && item > 5;
})

console.log(filter);

