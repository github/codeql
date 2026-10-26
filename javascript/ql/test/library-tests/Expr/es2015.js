["a", "ab", "abc"].map(s => s.length);
setInterval(() => ++cnt, 1000);
setTimeout(() => { alert("Wake up!"); }, 60000);

[a, ...as];
new Array(...elts);

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

function* foo(n){
	while(n-->0)
		yield n;
	yield* foo(1);
}

function bar(x, y=x+19) {}
