function f(g) {
	try {
		g();
	} catch (e if e instanceof Error) {
		console.log("error!");
	} catch (e) {
		console.log("something else!");
	}
}