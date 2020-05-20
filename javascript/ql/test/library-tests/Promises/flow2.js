(async function () {
	var source = "source";

	Promise.all([source, "clean"]).then((arr) => {
		sink(arr); // OK
		sink(arr[0]); // NOT OK
		sink(arr[1]); // OK
	})

	var [clean, tainted] = await Promise.all(["clean", source]);
	sink(clean); // OK
	sink(tainted); // NOT OK

	var [clean2, tainted2] = await Promise.resolve(Promise.all(["clean", source]));
	sink(clean2); // OK
	sink(tainted2); // NOT OK

	var [clean3, tainted3] = await Promise.all(["clean", Promise.resolve(source)]);
	sink(clean3); // OK
	sink(tainted3); // NOT OK - but only flagged by taint-tracking
});