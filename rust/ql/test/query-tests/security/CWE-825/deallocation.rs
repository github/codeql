
// --- std::alloc ---

pub fn test_alloc(do_dangerous_writes: bool) {
	let layout = std::alloc::Layout::new::<i64>();
	unsafe {
		let m1 = std::alloc::alloc(layout); // *mut u8
		let m2 = m1 as *mut i64; // *mut i64
		*m2 = 1; // GOOD

		let v1 = *m1; // GOOD
		let v2 = *m2; // GOOD
		let v3 = std::ptr::read::<u8>(m1); // GOOD
		let v4 = std::ptr::read::<i64>(m2); // GOOD
		println!("	v1 = {v1}");
		println!("	v2 = {v2}");
		println!("	v3 = {v3}");
		println!("	v4 = {v4}");

		std::alloc::dealloc(m1, layout); // m1, m2 are now dangling

		let v5 = *m1; // $ MISSING: Alert
		let v6 = *m2; // $ MISSING: Alert
		let v7 = std::ptr::read::<u8>(m1); // $ MISSING: Alert
		let v8 = std::ptr::read::<i64>(m2); // $ MISSING: Alert
		println!("	v5 = {v5} (!)"); // corrupt in practice
		println!("	v6 = {v6} (!)"); // corrupt in practice
		println!("	v7 = {v7} (!)"); // corrupt in practice
		println!("	v8 = {v8} (!)"); // corrupt in practice

		if do_dangerous_writes {
			*m1 = 2; // $ MISSING: Alert
			*m2 = 3; // $ MISSING: Alert
			std::ptr::write::<u8>(m1, 4); // $ MISSING: Alert
			std::ptr::write::<i64>(m2, 5); // $ MISSING: Alert
		}
	}
}

pub fn test_alloc_array(do_dangerous_writes: bool) {
	let layout = std::alloc::Layout::new::<[u8; 10]>();
	unsafe {
		let m1 = std::alloc::alloc(layout);
		let m2 = m1 as *mut [u8; 10];
		(*m2)[0] = 4; // GOOD
		(*m2)[1] = 5; // GOOD

		let v1 = (*m2)[0]; // GOOD
		let v2 = (*m2)[1]; // GOOD
		println!("	v1 = {v1}");
		println!("	v2 = {v2}");

		std::alloc::dealloc(m2 as *mut u8, layout); // m1, m2 are now dangling

		let v3 = (*m2)[0]; // $ MISSING: Alert
		let v4 = (*m2)[1]; // $ MISSING: Alert
		println!("	v3 = {v3} (!)"); // corrupt in practice
		println!("	v4 = {v4} (!)"); // corrupt in practice

		if do_dangerous_writes {
			(*m2)[0] = 3; // $ MISSING: Alert
			(*m2)[1] = 4; // $ MISSING: Alert
			std::ptr::write::<u8>(m1, 5); // $ MISSING: Alert
			std::ptr::write::<[u8; 10]>(m2, [6; 10]); // $ MISSING: Alert
		}
	}
}

// --- libc::malloc ---

pub fn test_libc() {
	unsafe {
		let my_ptr = libc::malloc(256) as *mut i64;
		*my_ptr = 10;

		let v1 = *my_ptr; // GOOD
		println!("	v1 = {v1}");

		libc::free(my_ptr as *mut libc::c_void); // my_ptr is now dangling

		let v2 = *my_ptr; // $ MISSING: Alert
		println!("	v2 = {v2} (!)"); // corrupt in practice
	}
}

// --- std::ptr ---

pub fn test_ptr_invalid(do_dangerous_accesses: bool) {
	let p1: *const i64 = std::ptr::dangling();
	let p2: *mut i64 = std::ptr::dangling_mut();
	let p3: *const i64 = std::ptr::null();

	if do_dangerous_accesses {
		unsafe {
			// (a segmentation fault occurs in the code below)
			let v1 = *p1; // $ MISSING: Alert
			let v2 = *p2; // $ MISSING: Alert
			let v3 = *p3; // $ MISSING: Alert
			println!("	v1 = {v1} (!)");
			println!("	v2 = {v2} (!)");
			println!("	v3 = {v3} (!)");
		}
	}
}

// --- drop ---

struct MyBuffer {
	data: Vec<u8>
}

pub fn test_drop() {
	let my_buffer = MyBuffer { data: vec!(1, 2, 3) };
	let p1 = std::ptr::addr_of!(my_buffer);

	unsafe {
		let v1 = (*p1).data[0]; // GOOD
		println!("	v1 = {v1}");
	}

	drop(my_buffer); // explicitly destructs the `my_buffer` variable

	unsafe {
		let v2 = (*p1).data[0]; // $ MISSING: Alert
		println!("	v2 = {v2} (!)"); // corrupt in practice
	}
}

pub fn test_ptr_drop() {
	let layout = std::alloc::Layout::new::<Vec<i64>>();
	unsafe {
		let p1 = std::alloc::alloc(layout) as *mut Vec<i64>; // *mut i64
		let p2 = p1;

		*p1 = vec!(1, 2, 3);

		let v1 = (*p1)[0]; // GOOD
		let v2 = (*p2)[0]; // GOOD
		println!("	v1 = {v1}");
		println!("	v2 = {v2}");

		std::ptr::drop_in_place(p1); // explicitly destructs the pointed-to `m2`

		let v3 = (*p1)[0]; // $ MISSING: Alert
		let v4 = (*p2)[0]; // $ MISSING: Alert
		println!("	v3 = {v3} (!)"); // corrupt in practice
		println!("	v4 = {v4} (!)"); // corrupt in practice
	}
}
