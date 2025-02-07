function f() {
	if (someCond())
		return; // $ TODO-SPURIOUS: Alert
	return 42;
}