#![feature(box_as_ptr)]
#![feature(box_into_inner)]

mod deallocation;
use deallocation::*;
mod lifetime;
use lifetime::*;

fn use_the_heap() {
	let _a = Box::new(0x7FFFFFFF);
	let _b = Box::new(0x7FFFFFFF);
}

// --- boxes ---

pub fn test_boxes_into() {
	let b1: Box<i64> = Box::new(7); // b1 owns the memory for '50'
	let p1 = Box::as_ptr(&b1); // b1 still owns the memory

	unsafe {
		let v1 = *p1; // GOOD
		println!("	v1 = {v1}");
	}

	let v2 = Box::into_inner(b1); // b1 is explicitly freed here, thus p1 is dangling
	println!("	v2 = {v2}");

	unsafe {
		let v3 = *p1; // $ MISSING: Alert
		println!("	v3 = {v3} (!)"); // corrupt in practice
	}
}

pub fn test_boxes_1(mode: i32) {
	let p1: *const i64;
	let p2: *const i64;
	let p3: *mut i64;

	{
		let b1: Box<i64> = Box::new(1);
		p1 = Box::into_raw(b1); // now owned by p1

		let b2: Box<i64> = Box::new(2);
		p2 = Box::as_ptr(&b2); // still owned by b2

		let mut b3: Box<i64> = Box::new(3);
		p3 = Box::as_mut_ptr(&mut b3); // still owned by b3

		unsafe {
			let v1 = *p1; // GOOD
			let v2 = *p2; // GOOD
			let v3 = *p3; // GOOD
			println!("	v1 = {v1}");
			println!("	v2 = {v2}");
			println!("	v3 = {v3}");
			*p3 = 4;
		}
	} // (b2, b3 go out of scope, thus p2, p3 are dangling)

	unsafe {
		if mode == 0 {
			// reads
			let v4 = *p1; // GOOD
			let v5 = *p2; // $ MISSING: Alert
			let v6 = *p3; // $ MISSING: Alert
			println!("	v4 = {v4}");
			println!("	v5 = {v5} (!)"); // corrupt in practice
			println!("	v6 = {v6} (!)"); // corrupt in practice
		}
		if mode == 10 {
			// write
			*p3 = 5; // $ MISSING: Alert
			use_the_heap(); // "malloc: Heap corruption detected"
		}
	}
}

pub fn test_boxes_2() {
	let b1: Box<i64> = Box::new(6); // b1 owns the memory
	let p1 = Box::into_raw(b1); // now p1 owns the memory

	unsafe {
		let _b2 = Box::from_raw(p1); // now _b2 owns the memory

		let v1 = *p1; // GOOD
		println!("	v1 = {v1}");
	} // (_b2 goes out of scope, thus the memory is freed and p1 is dangling)

	unsafe {
		let v2 = *p1; // $ MISSING: Alert
		println!("	v2 = {v2} (!)"); // corrupt in practice
	}
}

// --- main ---

fn main() {
	let mode = std::env::args().nth(1).unwrap_or("0".to_string()).parse::<i32>().unwrap_or(0);
		// mode = which test cases to explore (0 should be safe; some will crash / segfault).
	println!("mode = {mode}");

	println!("test_boxes_into:");
	test_boxes_into();

	println!("test_boxes_1:");
	test_boxes_1(mode);

	println!("test_boxes_2:");
	test_boxes_2();

	// ---

	println!("test_alloc:");
	test_alloc(mode);

	println!("test_alloc_array:");
	test_alloc_array(mode);

	println!("test_libc:");
	test_libc();

	println!("test_ptr_invalid:");
	test_ptr_invalid(mode);

	println!("test_drop:");
	test_drop();

	println!("test_ptr_drop:");
	test_ptr_drop(mode);

	println!("test_qhelp_tests:");
	test_qhelp_examples();

	println!("test_vec_reserve:");
	test_vec_reserve();

	// ---

	println!("test_local_dangling:");
	test_local_dangling();

	println!("test_local_in_scope:");
	test_local_in_scope(mode);

	println!("test_static:");
	test_static(mode);

	println!("test_call_contexts:");
	test_call_contexts();

	println!("test_call_contexts_rec:");
	test_call_contexts_rec();

	println!("test_loop:");
	test_loop();

	println!("test_enum:");
	test_enum();

	println!("test_ptr_to_struct:");
	test_ptr_to_struct(mode);

	println!("test_ptr_from_ref:");
	test_ptr_from_ref();

	println!("test_rc:");
	test_rc();

	println!("test_closures:");
	test_closures();

	println!("test_async:");
	test_async();

	println!("test_lifetime_annotations:");
	test_lifetime_annotations();
}
