function bad(x) {
	return x + x>>1;  // $ Alert
}

function ok1(x) {
	return x + x >> 1;
}

function ok2(x) {
	return x+x >> 1;
}

function ok3(x) {
	return x + (x>>1);
}

function ok4(x, y, z) {
	return x + y + z;
}

function ok5(x, y, z) {
	return x + y+z;
}

function ok6(x) {
	return x + x>> 1;
}

function ok7(x, y, z) {
	return x + y - z;
}

function ok8(x, y, z) {
	return x + y-z;
}

function ok9(x, y, z) {
	return x * y*z;
}

function bad10(o, p) {
	return p in o&&o[p]; // $ Alert
}


x==y ** 2;

x  +  x >> 1 // $ Alert


x +   x >> 1

// OK - asm.js-like
x = x - 1|0;
