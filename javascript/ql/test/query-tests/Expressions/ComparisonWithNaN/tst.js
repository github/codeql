x == NaN; // $ TODO-SPURIOUS: Alert
x != NaN; // $ TODO-SPURIOUS: Alert
x === NaN; // $ TODO-SPURIOUS: Alert
NaN !== x; // $ TODO-SPURIOUS: Alert
x < NaN; // $ TODO-SPURIOUS: Alert
NaN === NaN; // $ TODO-SPURIOUS: Alert
isNaN(x);

function f(x, NaN) {
	return x === NaN;
}