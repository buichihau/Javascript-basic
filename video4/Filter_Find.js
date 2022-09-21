console.log('Hello Hau');

let arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

//filter, find

let filter = arr.filter((item, index) => {
    
    return item && item > 5;
})

console.log(filter);

let arr2 = [
    {name: 'A', age: 25},
    {name: 'B', age: 29},
    {name: 'C', age: 25},
    {name: 'D', age: 24},
    {name: 'E', age: 22},
]

let find = arr2.find((item, index) => {
    
    return item && item.age === 25;
});

console.log(find);

