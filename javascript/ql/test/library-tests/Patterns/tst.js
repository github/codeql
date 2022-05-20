function f([x, y]) {
	var [a, [, c]] = x;
	try {
		throw [a, c];
	} catch (d) {
		console.log(d);
	}
}

function g({ x, y: z }) {
	var { [x]: w } = z;
	return w;
}
