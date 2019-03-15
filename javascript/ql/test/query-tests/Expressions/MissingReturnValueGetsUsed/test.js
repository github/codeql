function main() {

/////////////////
//             //
//  BAD CASES  //
//             //
/////////////////



function f0() {
	return;
}
var x0 = f0();


function f1() {
	1;
}
var x1 = f1();


var f2 = function () {
	return;
}
var x2 = f2();


var f3 = function () {
	1;
}
var x3 = f3();


var f4 = () => { return; };
var x4 = f4();




//////////////////
//              //
//  GOOD CASES  //
//              //
//////////////////



// Function call as a statement

f0();


// Empty functions

function f5() {}
var x5 = f5();


var f6 = function () {};
var x6 = f6();


var f7 = () => {};
var x7 = f7();


// Functions that return values

function f8() {
	return 1;
}
var x8 = f8();


var f9 = function () {
	return 1;
};
var x9 = f9();


var f10 = () => 1;
var x10 = f10();

var f11 = () => { return 1; }
var x11 = f11();


// IIFEs

(function () { return; })();


// Return chain

function f12() { return f0(); }


// Void expr

var x13 = void f0();



}