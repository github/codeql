var global;
also_a_global = 23;
global;
another_global;
{
	var another_global;
}
function f() {
	var x;
	x;
}
function g() {
	x;
	var x;
	{
		function h() {}
		!function k() {}
	}
}