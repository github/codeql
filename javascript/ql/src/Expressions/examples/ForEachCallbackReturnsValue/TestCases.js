/////////////////
//             //
//  BAD CASES  //
//             //
/////////////////


// Application w/ directly referenced functions

[].forEach(function (x) { return 1; });
Array.prototype.forEach.apply([], [function (x) { return 1; }]);
Array.prototype.forEach.call([], function (x) { return 1; });

[].forEach(x => 1);
Array.prototype.forEach.apply([], [x => 1]);
Array.prototype.forEach.call([], x => 1);


// Application w/ indirectly referenced functions

var f0 = function (x) { return 1; };
[].forEach(f0);
Array.prototype.forEach.apply([], [f0]);
Array.prototype.forEach.call([], f0);

var f1 = x => 1;
[].forEach(f1);
Array.prototype.forEach.apply([], [f1]);
Array.prototype.forEach.call([], f1);




//////////////////
//              //
//  GOOD CASES  //
//              //
//////////////////

//Application w/ directly referenced functions

[].forEach(function (x) { return; });
Array.prototype.forEach.apply([], [function (x) { return; }]);
Array.prototype.forEach.call([], function (x) { return; });

[].forEach(x => { return; });
Array.prototype.forEach.apply([], [x => { return; }]);
Array.prototype.forEach.call([], x => { return; });


// Application w/ indirectly referenced functions

var f2 = function (x) { return; };
[].forEach(f2);
Array.prototype.forEach.apply([], [f2]);
Array.prototype.forEach.call([], f2);

var f3 = x => { return; };
[].forEach(f3);
Array.prototype.forEach.apply([], [f3]);
Array.prototype.forEach.call([], f3);