(async function () {
	var source = "source";

	Promise.all([source, "clean"]).then((arr) => {
		sink(arr); // OK - but flagged by taint-tracking.
		sink(arr[0]); // NOT OK
		sink(arr[1]); // OK - but flagged by taint-tracking.
	})

	var [clean, tainted] = await Promise.all(["clean", source]);
	sink(clean); // OK - but flagged by taint-tracking
	sink(tainted); // NOT OK

	var [clean2, tainted2] = await Promise.resolve(Promise.all(["clean", source]));
	sink(clean2); // OK - but flagged by taint-tracking
	sink(tainted2); // NOT OK
});