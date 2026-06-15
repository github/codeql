delete this.Object;
delete String; // $ Alert
function f(o, x) {
	delete o.p;
	delete o[x];
	delete x; // $ Alert
	delete (o.p);
}