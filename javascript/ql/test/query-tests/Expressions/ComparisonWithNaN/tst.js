x == NaN; // $ Alert
x != NaN; // $ Alert
x === NaN; // $ Alert
NaN !== x; // $ Alert
x < NaN; // $ Alert
NaN === NaN; // $ Alert
isNaN(x);

function f(x, NaN) {
	return x === NaN;
}