function bad(x) {
	return x + x>>1; 
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

function ok10(o, p) {
	return p in o&&o[p];
}

// OK
x==y ** 2;

// NOT OK
x  +  x >> 1

// OK
x +   x >> 1
