
fn get_box() -> Box<i64> {
	let val = 123;

	return Box::new(val); // copies `val` onto the heap, where it remains for the lifetime of the `Box`.
}

fn example() {
	let ptr = get_box();
	let val;

	// ...

	val = *ptr; // GOOD

	// ...
}
