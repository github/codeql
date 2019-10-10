var arr = [1,2,3];

arr.concat([1,2,3]); // NOT OK!

arr.concat(arr); // NOT OK!

console.log(arr.concat([1,2,3]));

arr.concat(null);
arr.concat();
arr.concat([]);

({concat: Array.prototype.concat}.concat(arr));