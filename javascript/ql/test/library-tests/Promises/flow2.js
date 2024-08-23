(async function () {
	var source = "source";

	Promise.all([source, "clean"]).then((arr) => {
		sink(arr); // NOT OK - implicit read of array element
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
	sink(tainted3); // NOT OK

	var tainted4 = await Promise.race(["clean", Promise.resolve(source)]);
	sink(tainted4); // NOT OK

	var tainted5 = await Promise.any(["clean", Promise.resolve(source)]);
	sink(tainted5); // NOT OK
});
