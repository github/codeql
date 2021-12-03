function call(o, m) {
	if (o && typeof o[m] === 'function')
		return o[m]();
	throw new Error("no such method");
}