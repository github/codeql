function f(x) {
	var result = send(x);
	waitForResponse();
	return getResponse();
}