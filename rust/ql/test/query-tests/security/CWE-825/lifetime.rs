
fn use_the_stack() {
	let _buffer: [u8; 256] = [0xFF; 256];
}

struct MyValue {
	value: i64
}

impl Drop for MyValue {
	fn drop(&mut self) {
		println!("	drop MyValue '{}'", self.value)
	}
}

// --- local dangling ---

fn get_local_dangling() -> *const i64 {
	let my_local1: i64 = 1;

	return &my_local1;
} // (return value immediately becomes dangling)

fn get_local_dangling_mut() -> *mut i64 {
	let mut my_local2: i64 = 2;

	return &mut my_local2;
} // (return value immediately becomes dangling)

fn get_local_dangling_raw_const() -> *const i64 {
	let my_local3: i64 = 3;

	return &raw const my_local3;
} // (return value immediately becomes dangling)

fn get_local_dangling_raw_mut() -> *mut i64 {
	let mut my_local4: i64 = 4;

	return &raw mut my_local4;
} // (return value immediately becomes dangling)

fn get_param_dangling(param5: i64) -> *const i64 {
	return &param5;
} // (return value immediately becomes dangling)

fn get_local_field_dangling() -> *const i64 {
	let val: MyValue;

	val = MyValue { value: 6 };
	return &val.value;
}

pub fn test_local_dangling() {
	let p1 = get_local_dangling();
	let p2 = get_local_dangling_mut();
	let p3 = get_local_dangling_raw_const();
	let p4 = get_local_dangling_raw_mut();
	let p5 = get_param_dangling(5);
	let p6 = get_local_field_dangling();
	let p7: *const i64;
	{
		let my_local7 = 7;
		p7 = &raw const my_local7;
	} // (my_local goes out of scope, thus p7 is dangling)

	use_the_stack();

	unsafe {
		let v1 = *p1; // $ MISSING: Alert
		let v2 = *p2; // $ MISSING: Alert
		let v3 = *p3; // $ MISSING: Alert
		let v4 = *p4; // $ MISSING: Alert
		let v5 = *p5; // $ MISSING: Alert
		let v6 = *p6; // $ MISSING: Alert
		let v7 = *p7; // $ MISSING: Alert
		*p2 = 8; // $ MISSING: Alert
		*p4 = 9; // $ MISSING: Alert

		println!("	v1 = {v1} (!)"); // corrupt in practice
		println!("	v2 = {v2} (!)"); // corrupt in practice
		println!("	v3 = {v3} (!)"); // corrupt in practice
		println!("	v4 = {v4} (!)"); // corrupt in practice
		println!("	v5 = {v5} (!)"); // corrupt in practice
		println!("	v6 = {v6} (!)"); // corrupt in practice
		println!("	v7 = {v7} (!)");
	}
}

// --- local in scope ---

fn use_pointers(p1: *const i64, p2: *mut i64, mode: i32) {
	let p3: *const i64;
	let my_local1 = 1;
	p3 = &my_local1;

	use_the_stack();

	unsafe {
		if (mode == 0) {
			// reads
			let v1 = *p1; // GOOD
			let v2 = *p2; // GOOD
			let v3 = *p3; // GOOD
			println!("	v1 = {v1}");
			println!("	v2 = {v2}");
			println!("	v3 = {v3}");
		}
		if (mode == 200) {
			// writes
			*p2 = 2; // GOOD
		}
	}
}

pub fn test_local_in_scope(mode: i32) {
	let my_local3: i64 = 3;
	let mut my_local_mut4: i64 = 4;

	use_pointers(&my_local3, &mut my_local_mut4, mode);
}

// --- static lifetime ---

const MY_GLOBAL_CONST: i64 = 1;

fn get_const() -> *const i64 {
	return &MY_GLOBAL_CONST;
}

static mut MY_GLOBAL_STATIC: i64 = 2;

fn get_static_mut() -> *mut i64 {
	unsafe {
		return &mut MY_GLOBAL_STATIC;
	}
}

pub fn test_static(mode: i32) {
	let p1 = get_const();
	let p2 = get_static_mut();

	use_the_stack();

	unsafe {
		if (mode == 0) {
			// reads
			let v1 = *p1; // GOOD
			let v2 = *p2; // GOOD
			println!("	v1 = {v1}");
			println!("	v2 = {v2}");
		}
		if (mode == 210) {
			// writes
			*p2 = 3; // GOOD
		}
	}
}

// --- call contexts ---

fn access_ptr_1(ptr: *const i64) {
	// only called with `ptr` safe
	unsafe {
		let v1 = *ptr; // GOOD
		println!("	v1 = {v1}");
	}
}

fn access_ptr_2(ptr: *const i64) {
	// only called with `ptr` dangling
	unsafe {
		let v2 = *ptr; // $ MISSING: Alert
		println!("	v2 = {v2} (!)"); // corrupt in practice
	}
}

fn access_ptr_3(ptr: *const i64) {
	// called from contexts with `ptr` safe and dangling
	unsafe {
		let v3 = *ptr; // $ MISSING: Alert
		println!("	v3 = {v3} (!)"); // corrupt in practice (in one context)
	}
}

fn access_and_get_dangling() -> *const i64 {
	let my_local1 = 1;
	let ptr = &my_local1;

	access_ptr_1(ptr);
	access_ptr_3(ptr);

	return ptr;
} // (returned pointer becomes dangling)

pub fn test_call_contexts() {
	let ptr = access_and_get_dangling();

	use_the_stack();

	access_ptr_2(ptr);
	access_ptr_3(ptr);
}

// --- call contexts (recursive) ---

fn access_ptr_rec(ptr_up: *const i64, count: i64) -> *const i64 {
	let my_local_rec = count;
	let ptr_ours = &my_local_rec;

	if count < 5 {
		let ptr_down = access_ptr_rec(ptr_ours, count + 1);

		use_the_stack();

		unsafe {
			let v_up = *ptr_up; // GOOD
			let v_ours = *ptr_ours; // GOOD
			let v_down = *ptr_down; // $ MISSING: Alert
			println!("	v_up = {v_up}");
			println!("	v_ours = {v_ours}");
			println!("	v_down = {v_down} (!)");
		}
	}

	return ptr_ours;
} // (returned pointer becomes dangling)

pub fn test_call_contexts_rec() {
	let my_local_rec2 = 1;
	let ptr_start = &my_local_rec2;

	_ = access_ptr_rec(ptr_start, 2);
}

// --- loops ---

pub fn test_loop() {
	let my_local1 = vec!(0);
	let mut prev: *const Vec<i32> = &my_local1;

	for i in 1..5 {
		let my_local2 = vec!(i);

		use_the_stack();

		unsafe {
			let v1 = (*prev)[0]; // $ MISSING: Alert
			println!("	v1 = {v1} (!)"); // incorrect values in practice (except first iteration)
		}

		prev = &my_local2;
	} // (my_local2 goes out of scope, thus prev is dangling)

	unsafe {
		let v2 = (*prev)[0]; // $ MISSING: Alert
		println!("	v2 = {v2} (!)"); // corrupt in practice
	}
}

// --- enum ---

enum MyEnum {
	Value(i64),
}

impl Drop for MyEnum {
	fn drop(&mut self) {
		println!("	drop MyEnum");
	}
}

pub fn test_enum() {
	let result: *const i64;

	{
		let e1 = MyEnum::Value(1);

		result = match e1 {
			MyEnum::Value(x) => { &x }
		}; // (x goes out of scope, so result is dangling, I think; seen in real world code)

		use_the_stack();

		unsafe {
			let v1 = *result; // $ MISSING: Alert
			println!("	v1 = {v1}");
		}
	} // (e1 goes out of scope, so result is definitely dangling now)

	use_the_stack();

	unsafe {
		let v2 = *result; // $ MISSING: Alert
		println!("	v2 = {v2}"); // dropped in practice
	}
}

// --- std::ptr ---

#[derive(Debug)]
struct MyPair {
	a: i64,
	b: i64
}

impl Drop for MyPair {
	fn drop(&mut self) {
		println!("	drop MyPair '{} {}'", self.a, self.b);
		self.a = -1;
		self.b = -1;
	}
}

pub fn test_ptr_to_struct(mode: i32) {
	let p1: *mut MyPair;
	let p2: *const i64;
	let p3: *mut i64;

	{
		let mut my_pair = MyPair { a: 1, b: 2};
		p1 = std::ptr::addr_of_mut!(my_pair);
		p2 = std::ptr::addr_of!(my_pair.a);
		p3 = std::ptr::addr_of_mut!(my_pair.b);

		unsafe {
			let v1 = (*p1).a; // GOOD
			println!("	v1 = {v1}");

			let v2 = (*p1).b; // GOOD
			println!("	v2 = {v2}");

			let v3 = *p2; // GOOD
			let v4 = *p3; // GOOD
			println!("	v3 = {v3}");
			println!("	v4 = {v4}");

			(*p1).a = 3; // GOOD
			*p3 = 4; // GOOD
			(*p1).b = 5; // GOOD
		}
	}; // my_pair goes out of scope, thus p1, p2, p3 are dangling

	use_the_stack();

	unsafe {
		match mode {
			0 => {
				// read
				let v5 = (*p1).a; // $ MISSING: Alert
				println!("	v5 = {v5} (!)"); // dropped in practice
			},
			220 => {
				// another read
				let v6 = (*p1).b; // $ MISSING: Alert
				println!("	v6 = {v6} (!)"); // dropped in practice
			},
			221 => {
				// more reads
				let v7 = *p2; // $ MISSING: Alert
				let v8 = *p3; // $ MISSING: Alert
				println!("	v7 = {v7} (!)"); // dropped in practice
				println!("	v8 = {v8} (!)"); // dropped in practice
			},
			222 => {
				// writes
				(*p1).a = 6; // $ MISSING: Alert
				*p3 = 7; // $ MISSING: Alert
			},
			223 => {
				// another write
				(*p1).b = 8; // $ MISSING: Alert
			},
			_ => {}
		}
	}
}

fn get_ptr_from_ref(val: i32) -> *const i32 {
	let my_val = val;
	let r1: &i32 = &my_val;
	let p1: *const i32 = std::ptr::from_ref(r1);

	unsafe {
		let v1 = *p1; // GOOD
		println!("	v1 = {v1}");
	}

	return p1;
} // (returned pointer becomes dangling)

pub fn test_ptr_from_ref() {
	let p1 = get_ptr_from_ref(1);

	use_the_stack();

	unsafe {
		let v2 = *p1; // $ MISSING: Alert
		let v3 = *get_ptr_from_ref(2); // $ MISSING: Alert
		println!("	v2 = {v2} (!)"); // corrupt in practice
		println!("	v3 = {v3} (!)");
	}
}

// --- std::rc (reference counting pointer) ---

pub fn test_rc() {
	let p1: *const i64;
	let p2: *const i64;

	{
		let rc1: std::rc::Rc<i64> = std::rc::Rc::new(1);
		p1 = std::rc::Rc::<i64>::as_ptr(&rc1);

		{
			let rc2: std::rc::Rc<i64> = std::rc::Rc::clone(&rc1);
			p2 = std::rc::Rc::<i64>::as_ptr(&rc2);

			unsafe {
				let v1 = *p1; // GOOD
				let v2 = *p2; // GOOD
				println!("	v1 = {v1}");
				println!("	v2 = {v2}");
			}
		} // rc2 goes out of scope, but the reference count is still 1 so the pointer remains valid

		unsafe {
			let v3 = *p1; // GOOD
			let v4 = *p2; // GOOD
			println!("	v3 = {v3}");
			println!("	v4 = {v4}");
		}
	} // rc1 go out of scope, the reference count is 0, so p1, p2 are dangling

	unsafe {
		let v5 = *p1; // $ MISSING: Alert
		let v6 = *p2; // $ MISSING: Alert
		println!("	v5 = {v5} (!)"); // corrupt in practice
		println!("	v6 = {v6} (!)"); // corrupt in practice
	}

	// note: simialar things are likely possible with Ref, RefMut, RefCell,
	//       Vec and others.
}
