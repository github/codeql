
fn get_pointer() -> *const i64 {
	let val = 123;

	&val
} // lifetime of `val` ends here, the pointer becomes dangling

fn example() {
	let ptr = get_pointer();
	let dereferenced_ptr;

	// ...

	unsafe {
		dereferenced_ptr = *ptr; // BAD: dereferences `ptr` after the lifetime of `val` has ended
	}

	// ...
}
