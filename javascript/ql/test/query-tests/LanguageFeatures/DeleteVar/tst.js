delete this.Object;
delete String;
function f(o, x) {
	delete o.p;
	delete o[x];
	delete x;
	delete (o.p);
}