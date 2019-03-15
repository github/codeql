function main() {


/////////////////
//             //
//  BAD CASES  //
//             //
/////////////////


// Application w/ a directly referenced callback

[].map(function (x) { return; });
Array.prototype.map.apply([], [function (x) { return; }]);
Array.prototype.map.call([], function (x) { return; });

[].map(x => { return; });
Array.prototype.map.apply([], [x => { return; }]);
Array.prototype.map.call([], x => { return; });


// Application w/ an indirectly referenced callback

var f0 = function(x) { return; };
[].map(f0);
Array.prototype.map.apply([], [f0]);
Array.prototype.map.call([], f0);

var f1 = x => { return; };
[].map(f1);
Array.prototype.map.apply([], [f1]);
Array.prototype.map.call([], f1);




//////////////////
//              //
//  GOOD CASES  //
//              //
//////////////////


// Application w/ a directly referenced callback

[].map(function (x) { return 1; });
Array.prototype.map.apply([], [function (x) { return 1; }]);
Array.prototype.map.call([], function (x) { return 1; });

[].map(x => 1);
Array.prototype.map.apply([], [x => 1]);
Array.prototype.map.call([], x => 1);


// Application w/ an indirectly referenced callback

var f2 = function(x) { return 1; };
[].map(f2);
Array.prototype.map.apply([], [f2]);
Array.prototype.map.call([], f2);

var f3 = x => 1;
[].map(f3);
Array.prototype.map.apply([], [f3]);
Array.prototype.map.call([], f3);


}