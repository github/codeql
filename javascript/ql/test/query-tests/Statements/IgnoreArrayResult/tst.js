var arr = [1,2,3];

arr.concat([1,2,3]); // $ Alert

arr.concat(arr); // $ Alert

console.log(arr.concat([1,2,3]));

({concat: Array.prototype.concat}.concat(arr));

[].concat([1,2,3]);