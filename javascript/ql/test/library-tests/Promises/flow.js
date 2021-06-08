(async function () {
	var source = "source";

	var p1 = Promise.resolve(source);
	sink(await p1); // NOT OK

	var p2 = new Promise((resolve, reject) => resolve(source));
	sink(await p2); // NOT OK

	var p3 = new Promise((resolve, reject) => reject(source));
	sink(await p3); // OK!

	var p4 = new Promise((resolve, reject) => reject(source));
	try {
		var foo = await p4;
	} catch (e) {
		sink(e); // NOT OK!
	}

	Promise.resolve(source).then(x => sink(x)); // NOT OK!

	Promise.resolve(source).then(x => foo(x), y => sink(y)); // OK!

	new Promise((resolve, reject) => reject(source)).then(x => sink(x)); // OK!

	new Promise((resolve, reject) => reject(source)).then(x => foo(x), y => sink(y)); // NOT OK!

	Promise.resolve("foo").then(x => source).then(z => sink(z)); // NOT OK!

	Promise.resolve(source).then(x => "foo").then(z => sink(z)); // OK!

	new Promise((resolve, reject) => reject(source)).catch(x => sink(x)); // NOT OK!

	Promise.resolve(source).catch(() => { }).then(a => sink(a)); // NOT OK!

	var p5 = Promise.resolve(source);
	var p6 = p5.catch(() => { });
	var p7 = p6.then(a => sink(a)); // NOT OK!

	new Promise((resolve, reject) => reject(source)).then(() => { }).catch(x => sink(x)); // NOT OK!

	new Promise((resolve, reject) => reject(source)).then(() => { }, () => { }).catch(x => sink(x)); // OK!

	Promise.resolve(source).catch(() => { }).catch(() => { }).catch(() => { }).then(a => sink(a)); // NOT OK!

	Promise.resolve(source).finally(() => { }).then(a => sink(a)); // NOT OK!

	new Promise(() => { throw source }).catch(x => sink(x)); // NOT OK!

	function createPromise(src) {
		return Promise.resolve(src);
	}
	createPromise(source).then(v => sink(v)); // NOT OK!
	
	var p8 = new Promise((resolve, reject) => reject(source));
	var p9 = p8.then(() => {});
	var p10 = p9.finally(() => {});
	p10.catch((x) => sink(x)); // NOT OK!

	var p11 = new Promise((resolve, reject) => reject(source));
	var p12 = p11.then(() => {});
	p12.catch(x => sink(x)); // NOT OK!

	async function throws() {
		await new Promise((resolve, reject) => reject(source));
	}
	try {
		throws();
	} catch(e) {
		sink(e); // NOT OK!
	}
	
	function chainedPromise() {
		return new Promise((resolve, reject) => reject(source)).then(() => {});
	}
	chainedPromise().then(() => {}).catch(e => sink(e)); // NOT OK!
	
	function leaksResolvedPromise(p) {
		p.then(x => sink(x)); // NOT OK!
	}
	leaksResolvedPromise(Promise.resolve(source));
	
	function leaksRejectedPromise(p) {
		p.catch(e => sink(e)); // NOT OK!
	}
	leaksRejectedPromise(new Promise((resolve, reject) => reject(source)));
	
	function leaksRejectedAgain(p) {
		("foo", p).then(() => {}).catch(e => sink(e)); // NOT OK!
	}
	leaksRejectedAgain(new Promise((resolve, reject) => reject(source)).then(() => {}));
	
	async function returnsRejected(p) {
		try {
			await p;
		} catch(e) {
			return e;
		}
	}
	var foo = await returnsRejected(new Promise((resolve, reject) => reject(source)));
	sink(foo); // NOT OK!
	
	new Promise((resolve, reject) => reject("BLA")).catch(x => {return source}).then(x => sink(x)); // NOT OK
	
	new Promise((resolve, reject) => reject("BLA")).finally(x => {throw source}).catch(x => sink(x)); // NOT OK
	
	var rejected = new Promise((resolve, reject) => reject(source));
	
	new Promise((resolve, reject) => reject("BLA")).finally(x => rejected).catch(x => sink(x)); // NOT OK
	
	new Promise((resolve, reject) => reject("BLA")).catch(x => rejected).then(x => sink(x)) // OK
	
	new Promise((resolve, reject) => reject("BLA")).catch(x => rejected).catch(x => sink(x)) // NOT OK
	
	var resolved = Promise.resolve(source);
	
	new Promise((resolve, reject) => reject("BLA")).catch(x => resolved).catch(x => sink(x)) // OK
	
	new Promise((resolve, reject) => reject("BLA")).catch(x => resolved).then(x => sink(x)) // NOT OK
	
	Promise.resolve(123).then(x => resolved).catch(x => sink(x)) // OK
	
	Promise.resolve(123).then(x => resolved).then(x => sink(x)) // NOT OK
	
	Promise.resolve(123).then(x => rejected).catch(x => sink(x)) // NOT OK
	
	Promise.resolve(123).then(x => rejected).then(x => sink(x)) // OK
	
	new Promise((resolve, reject) => resolve(resolved)).then(x => sink(x)); // NOT OK
	
	Promise.resolve(resolved).then(x => sink(x)); // NOT OK
})();


(async function () {
	var source = "source";
  
	async function async() {
	  return source;
	}
	sink(async()); // OK - wrapped in a promise. (NOT OK for taint-tracking configs)
	sink(await async()); // NOT OK
  
	async function throwsAsync() {
	  throw source;
	}
	try {
	  throwsAsync();
	} catch (e) {
	  sink(e); // OK - throwsAsync just returns a promise.
	}
	try {
	  await throwsAsync();
	} catch (e) {
	  sink(e); // NOT OK
	}
})();

(function () {
	var source = "source";

	var bluebird = require("bluebird");

	bluebird.mapSeries(source, x => sink(x)); // NOT OK (for taint-tracking configs)

	const foo = bluebird.mapSeries(source, x => x);
	sink(foo); // NOT OK (for taint-tracking configs)
})