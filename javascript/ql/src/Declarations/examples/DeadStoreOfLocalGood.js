function f(x) {
	var result = send(x);
	// check for error
	if (result === -1)
		throw new Error("send failed");
	waitForResponse();
	return getResponse();
}