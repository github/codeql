delete this.Object;
delete String; // $ TODO-SPURIOUS: Alert
function f(o, x) {
	delete o.p;
	delete o[x];
	delete x; // $ TODO-SPURIOUS: Alert
	delete (o.p);
}