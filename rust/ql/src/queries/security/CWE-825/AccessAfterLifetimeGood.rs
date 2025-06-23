
fn get_box() -> Box<i64> {
	let val = 123;

	Box::new(val) // copies `val` onto the heap, where it remains for the lifetime of the `Box`.
}

fn example() {
	let ptr = get_box();
	let dereferenced_ptr;

	// ...

	dereferenced_ptr = *ptr; // GOOD

	// ...
}
