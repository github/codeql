function main() {

/////////////////
//             //
//  BAD CASES  //
//             //
/////////////////



function f0() {
	return;
}

var x0 = 1 + f0();



function f1() {
	1;
}

x1 *= f1();



function f2() {
	if (1 > 2) {
		return 5;
	}
}

x2[f2()];




//////////////////
//              //
//  GOOD CASES  //
//              //
//////////////////



f0();



function f3() {}

f3().foo;



function f4() {
	return 1;
}

var x4 = 1 + f4();



f0() && x5;



(function () { return; })();



function f5() { return f0(); }



void f0();



}