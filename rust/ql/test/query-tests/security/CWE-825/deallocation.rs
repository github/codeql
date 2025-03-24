
// --- std::alloc ---

pub fn test_alloc(mode: i32) {
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

		std::alloc::dealloc(m1, layout); // $ Source=dealloc
		// (m1, m2 are now dangling)

		match mode {
			0 => {
				// reads
				let v5 = *m1; // $ Alert[rust/access-invalid-pointer]=dealloc
				let v6 = *m2; // $ MISSING: Alert
				println!("	v5 = {v5} (!)"); // corrupt in practice
				println!("	v6 = {v6} (!)"); // corrupt in practice

				// test repeat reads (we don't want lots of very similar results for the same dealloc)
				let v5b = *m1; // $ Alert[rust/access-invalid-pointer]=dealloc
				let v5c = *m1; // $ Alert[rust/access-invalid-pointer]=dealloc
			},
			100 => {
				// more reads
				let v7 = std::ptr::read::<u8>(m1); // $ Alert[rust/access-invalid-pointer]=dealloc
				let v8 = std::ptr::read::<i64>(m2); // $ MISSING: Alert
				println!("	v7 = {v7} (!)"); // corrupt in practice
				println!("	v8 = {v8} (!)"); // corrupt in practice
			},
			101 => {
				// writes
				*m1 = 2; // $ Alert[rust/access-invalid-pointer]=dealloc
				*m2 = 3; // $ MISSING: Alert
			},
			102 => {
				// more writes
				std::ptr::write::<u8>(m1, 4); // $ Alert[rust/access-invalid-pointer]=dealloc
				std::ptr::write::<i64>(m2, 5); // $ MISSING: Alert
			},
			_ => {}
		}
	}
}

pub fn test_alloc_array(mode: i32) {
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

		std::alloc::dealloc(m2 as *mut u8, layout); // $ Source=dealloc_array
		// m1, m2 are now dangling

		match mode {
			0 => {
				// read
				let v3 = (*m2)[0]; // $ Alert[rust/access-invalid-pointer]=dealloc_array
				println!("	v3 = {v3} (!)"); // corrupt in practice
			},
			110 => {
				// another read
				let v4 = (*m2)[1]; // $ Alert[rust/access-invalid-pointer]=dealloc_array
				println!("	v4 = {v4} (!)"); // corrupt in practice
			},
			111 => {
				// write
				(*m2)[0] = 3; // $ Alert[rust/access-invalid-pointer]=dealloc_array
			},
			112 => {
				// another write
				(*m2)[1] = 4; // $ Alert[rust/access-invalid-pointer]=dealloc_array
			},
			113 => {
				// more writes
				std::ptr::write::<u8>(m1, 5); // $ MISSING: Alert
				std::ptr::write::<[u8; 10]>(m2, [6; 10]); // $ Alert[rust/access-invalid-pointer]=dealloc_array
			},
			_ => {}
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

		libc::free(my_ptr as *mut libc::c_void); // $ Source=free
		// (my_ptr is now dangling)

		let v2 = *my_ptr; // $ Alert[rust/access-invalid-pointer]=free
		println!("	v2 = {v2} (!)"); // corrupt in practice
	}
}

// --- std::ptr ---

pub fn test_ptr_invalid(mode: i32) {
	let p1: *const i64 = std::ptr::dangling(); // $ Source=dangling
	let p2: *mut i64 = std::ptr::dangling_mut(); // $ Source=dangling_mut
	let p3: *const i64 = std::ptr::null(); // $ Source=null

	if mode == 120 {
		unsafe {
			// (a segmentation fault occurs in the code below)
			let v1 = *p1; // $ Alert[rust/access-invalid-pointer]=dangling
			let v2 = *p2; // $ Alert[rust/access-invalid-pointer]=dangling_mut
			let v3 = *p3; // $ Alert[rust/access-invalid-pointer]=null
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

pub fn test_ptr_drop(mode: i32) {
	let layout = std::alloc::Layout::new::<Vec<i64>>();
	unsafe {
		let p1 = std::alloc::alloc(layout) as *mut Vec<i64>; // *mut i64
		let p2 = p1;

		*p1 = vec!(1, 2, 3);

		let v1 = (*p1)[0]; // GOOD
		let v2 = (*p2)[0]; // GOOD
		println!("	v1 = {v1}");
		println!("	v2 = {v2}");

		std::ptr::drop_in_place(p1); // $ Source=drop_in_place
		// explicitly destructs the pointed-to `m2`

		if mode == 1 {
			let v3 = (*p1)[0]; // $ Alert[rust/access-invalid-pointer]=drop_in_place
			println!("	v3 = {v3} (!)"); // corrupt in practice
		}
		if mode == 130 {
			let v4 = (*p2)[0]; // $ MISSING: Alert
			println!("	v4 = {v4} (!)"); // corrupt in practice
		}
	}
}

fn do_something(s: &String) {
	println!("	s = {}", s);
}

fn test_qhelp_test_good(ptr: *mut String) {
	unsafe {
		do_something(&*ptr);
	}

	// ...

	unsafe {
		std::ptr::drop_in_place(ptr);
	}
}

fn test_qhelp_test_bad(ptr: *mut String) {
	unsafe {
		std::ptr::drop_in_place(ptr); // $ Source=drop_in_place
	}

	// ...

	unsafe {
		do_something(&*ptr); // $ Alert[rust/access-invalid-pointer]=drop_in_place
	}
}

pub fn test_qhelp_tests() {
	let layout = std::alloc::Layout::new::<[String; 2]>();
	unsafe {
		let ptr = std::alloc::alloc(layout);
		let ptr_s = ptr as *mut [String; 2];
		let ptr1 = &raw mut (*ptr_s)[0];
		let ptr2 = &raw mut (*ptr_s)[1];

		*ptr1 = String::from("123");
		*ptr2 = String::from("456");

		test_qhelp_test_good(ptr1);

		test_qhelp_test_bad(ptr2);

		std::alloc::dealloc(ptr, layout);
	}
}

pub fn test_vec_reserve() {
	let mut vec1 = Vec::<u16>::new();
	vec1.push(100);
	let ptr1 = &raw mut vec1[0];

	unsafe {
		let v1 = *ptr1;
		println!("	v1 = {}", v1);
	}

	vec1.reserve(1000); // $ MISSING: Source=reserve
	// (may invalidate the pointer)

	unsafe {
		let v2 = *ptr1; // $ MISSING: Alert[rust/access-invalid-pointer]=reserve
		println!("	v2 = {}", v2); // corrupt in practice
	}

	// -

	let mut vec2 = Vec::<u16>::new();
	vec2.push(200);
	let ptr2 = &raw mut vec2[0];

	unsafe {
		let v3 = *ptr2;
		println!("	v3 = {}", v3);
	}

	for _i in 0..1000 {
		vec2.push(0); // $ MISSING: Source=push
		// (may invalidate the pointer)
	}

	unsafe {
		let v4 = *ptr2; // $ MISSING: Alert[rust/access-invalid-pointer]=push
		println!("	v4 = {}", v4); // corrupt in practice
	}
}
