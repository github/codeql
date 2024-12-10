#![allow(static_mut_refs)]
#![feature(box_as_ptr)]
#![feature(box_into_inner)]

fn use_the_stack() {
	let _buffer: [u8; 256] = [0xFF; 256];
}

fn use_the_heap() {
	let _a = Box::new(0x7FFFFFFF);
	let _b = Box::new(0x7FFFFFFF);
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

	return &my_local1; // immediately becomes dangling
}

fn get_local_dangling_mut() -> *mut i64 {
	let mut my_local2: i64 = 2;

	return &mut my_local2; // immediately becomes dangling
}

fn get_local_dangling_raw_const() -> *const i64 {
	let my_local3: i64 = 3;

	return &raw const my_local3; // immediately becomes dangling
}

fn get_local_dangling_raw_mut() -> *mut i64 {
	let mut my_local4: i64 = 4;

	return &raw mut my_local4; // immediately becomes dangling
}

fn get_param_dangling(param5: i64) -> *const i64 {
	return &param5; // immediately becomes dangling
}

fn get_local_field_dangling() -> *const i64 {
	let val: MyValue;

	val = MyValue { value: 6 };
	return &val.value;
}

fn test_local_dangling() {
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
	} // my_local goes out of scope, thus p7 is dangling

	use_the_stack();

	unsafe {
		let v1 = *p1; // BAD
		let v2 = *p2; // BAD
		let v3 = *p3; // BAD
		let v4 = *p4; // BAD
		let v5 = *p5; // BAD
		let v6 = *p6; // BAD
		let v7 = *p7; // BAD
		*p2 = 8; // BAD
		*p4 = 9; // BAD

		println!("	v1 = {v1} (!)"); // corrupt
		println!("	v2 = {v2} (!)"); // corrupt
		println!("	v3 = {v3} (!)"); // corrupt
		println!("	v4 = {v4} (!)"); // corrupt
		println!("	v5 = {v5} (!)"); // corrupt
		println!("	v6 = {v6} (!)"); // corrupt
		println!("	v7 = {v7} (!)"); // potentially corrupt
	}
}

// --- local in scope ---

fn use_pointers(p1: *const i64, p2: *mut i64) {
	let p3: *const i64;
	let my_local10 = 10;
	p3 = &my_local10;

	use_the_stack();

	unsafe {
		let v1 = *p1;
		let v2 = *p2;
		let v3 = *p3;
		*p2 = 10;
		println!("	v1 = {v1}");
		println!("	v2 = {v2}");
		println!("	v3 = {v3}");
	}
}

fn test_local_in_scope() {
	let my_local11: i64 = 11;
	let mut my_local_mut12: i64 = 12;

	use_pointers(&my_local11, &mut my_local_mut12);
}

// --- static lifetime pointers ---

const MY_GLOBAL_CONST: i64 = 20;

fn get_const() -> *const i64 {
	return &MY_GLOBAL_CONST;
}

static mut MY_GLOBAL_STATIC: i64 = 21;

fn get_static_mut() -> *mut i64 {
	unsafe {
		return &mut MY_GLOBAL_STATIC;
	}
}

fn test_static() {
	let p1 = get_const();
	let p2 = get_static_mut();

	use_the_stack();

	unsafe {
		let v1 = *p1;
		let v2 = *p2;
		*p2 = 22;
		println!("	v1 = {v1}");
		println!("	v2 = {v2}");
	}
}

// --- overwritten object ---

fn test_overwrite(maybe: bool) {
	let mut val: MyValue;

	val = MyValue { value: 30 };
	let p1: *const i64 = &val.value;

	val = MyValue { value: 31 }; // original msg goes out of scope, thus p1 is dangling
	let p2: *const i64 = &val.value;

	if maybe {
		val = MyValue { value: 32 }; // thus p2 is (maybe) dangling also
	}
	let p3: *const i64 = &val.value;

	{
		let val: MyValue;
		val = MyValue { value: 33 }; // doesn't overwrite shadowed `val`
		_ = val.value;
	}

	unsafe {
		let v1 = *p1; // BAD
		let v2 = *p2; // BAD
		let v3 = *p3;
		println!("	v1 = {v1} (!)"); // corrupt
		println!("	v2 = {v2} (!)"); // corrupt
		println!("	v3 = {v3}");
	}
}

// --- call contexts ---

fn access_ptr_1(ptr: *const i64) {
	// only called with `ptr` safe
	unsafe {
		let v1 = *ptr;
		println!("	v1 = {v1}");
	}
}

fn access_ptr_2(ptr: *const i64) {
	// only called with `ptr` dangling
	unsafe {
		let v2 = *ptr; // BAD
		println!("	v2 = {v2} (!)"); // corrupt
	}
}

fn access_ptr_3(ptr: *const i64) {
	// called from contexts with `ptr` safe and dangling
	unsafe {
		let v3 = *ptr; // BAD
		println!("	v3 = {v3} (!)"); // corrupt (in one context)
	}
}

fn access_and_get_dangling() -> *const i64 {
	let my_local40 = 40;
	let ptr = &my_local40;

	access_ptr_1(ptr);
	access_ptr_3(ptr);

	return ptr; // becomes dangling here
}

fn test_call_contexts() {
	let ptr = access_and_get_dangling();

	use_the_stack();

	access_ptr_2(ptr);
	access_ptr_3(ptr);
}

// --- call contexts (recursive) ---

fn access_ptr_rec(ptr_up: *const i64, count: i64) -> *const i64 {
	let my_local_rec = 50 + count;
	let ptr_ours = &my_local_rec;

	if count < 5 {
		let ptr_down = access_ptr_rec(ptr_ours, count + 1);

		use_the_stack();

		unsafe {
			let v_up = *ptr_up;
			let v_ours = *ptr_ours;
			let v_down = *ptr_down; // BAD
			println!("	v_up = {v_up}");
			println!("	v_ours = {v_ours}");
			println!("	v_down = {v_down} (!)"); // potentially corrupt
		}
	}

	return ptr_ours; // becomes dangling here
}

fn test_call_contexts_rec() {
	let my_local_rec2 = 50;
	let ptr_start = &my_local_rec2;

	_ = access_ptr_rec(ptr_start, 1);
}

// --- boxes ---

fn test_boxes_1(do_dangerous_writes: bool) {
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
			let v1 = *p1;
			let v2 = *p2;
			let v3 = *p3;
			*p3 = 4;

			println!("	v1 = {v1}");
			println!("	v2 = {v2}");
			println!("	v3 = {v3}");
		}
	} // b2, b3 go out of scope, thus p2, p3 are dangling

	unsafe {
		let v4 = *p1;
		let v5 = *p2; // BAD
		let v6 = *p3; // BAD

		if do_dangerous_writes {
			*p3 = 5; // BAD
			use_the_heap(); // "malloc: Heap corruption detected" "Incorrect guard value: 34"
		}

		println!("	v4 = {v4}");
		println!("	v5 = {v5} (!)"); // corrupt
		println!("	v6 = {v6} (!)"); // corrupt
	}
}

fn test_boxes_2() {
	let b1: Box<i64> = Box::new(10); // b1 owns the memory for '40'
	let p1 = Box::into_raw(b1); // now p1 owns the memory

	unsafe {
		let _b2 = Box::from_raw(p1); // now b2 owns the memory

		let v1 = *p1;
		println!("	v1 = {v1}");
	} // b2 goes out of scope, thus the memory is freed and p1 is dangling

	unsafe {
		let v2 = *p1; // BAD
		println!("	v2 = {v2} (!)"); // corrupt
	}
}

fn test_boxes_3() {
	let b1: Box<i64> = Box::new(20); // b1 owns the memory for '50'
	let p1 = Box::as_ptr(&b1); // b1 still owns the memory

	unsafe {
		let v1 = *p1;
		println!("	v1 = {v1}");
	}

	let v2 = Box::into_inner(b1); // b1 is explicitly freed here, thus p1 is dangling
	println!("	v2 = {v2}");

	unsafe {
		let v3 = *p1; // BAD
		println!("	v3 = {v3} (!)"); // corrupt
	}
}

// --- rc (reference counting pointer) ---

fn test_rc() {
	let p1: *const i64;
	let p2: *const i64;

	{
		let rc1: std::rc::Rc<i64> = std::rc::Rc::new(1);
		p1 = std::rc::Rc::<i64>::as_ptr(&rc1);

		{
			let rc2: std::rc::Rc<i64> = std::rc::Rc::clone(&rc1);
			p2 = std::rc::Rc::<i64>::as_ptr(&rc2);

			unsafe {
				let v1 = *p1;
				let v2 = *p2;
				println!("	v1 = {v1}");
				println!("	v2 = {v2}");
			}
		} // rc2 goes out of scope, but the reference count is still 1 so the pointer remains still valid

		unsafe {
			let v3 = *p1;
			let v4 = *p2; // good
			println!("	v3 = {v3}");
			println!("	v4 = {v4}");
		}
	} // rc1 go out of scope, the reference count is 0, so p1, p2 are dangling

	unsafe {
		let v5 = *p1; // BAD
		let v6 = *p2; // BAD
		println!("	v5 = {v5} (!)"); // corrupt
		println!("	v6 = {v6} (!)"); // corrupt
	}

	// note: simialar things are likely possible with Ref, RefMut, RefCell,
	//       Vec and others.
}

// --- std::ptr ---

#[derive(Debug)]
struct MyPair {
	a: i64,
	b: i64
}

fn test_ptr_to_struct() {
	let p1: *mut MyPair;
	let p2: *const i64;
	let p3: *mut i64;

	{
		let mut my_pair = MyPair { a: 1, b: 2};
		p1 = std::ptr::addr_of_mut!(my_pair);
		p2 = std::ptr::addr_of!(my_pair.a);
		p3 = std::ptr::addr_of_mut!(my_pair.b);

		unsafe {
			let v1 = (*p1).a;
			let v2 = (*p1).b;
			let v3 = *p2;
			let v4 = *p3;
			(*p1).a = 3;
			(*p1).b = 4;
			*p3 = 5;
			println!("	v1 = {v1}");
			println!("	v2 = {v2}");
			println!("	v3 = {v3}");
			println!("	v4 = {v4}");
		}
	}; // my_pair goes out of scope, thus p1, p2, p3 are dangling

	unsafe {
		let v5 = (*p1).a; // BAD
		let v6 = (*p1).b; // BAD
		let v7 = *p2; // BAD
		let v8 = *p3; // BAD
		(*p1).a = 6; // BAD
		(*p1).b = 7; // BAD
		*p3 = 8; // BAD
		println!("	v5 = {v5} (!)"); // potentially corrupt
		println!("	v6 = {v6} (!)"); // potentially corrupt
		println!("	v7 = {v7} (!)"); // potentially corrupt
		println!("	v8 = {v8} (!)"); // potentially corrupt
	}
}

fn test_ptr_explicit(do_dangerous_access: bool) {
	let p1: *const i64 = std::ptr::dangling();
	let p2: *mut i64 = std::ptr::dangling_mut();
	let p3: *const i64 = std::ptr::null();

	if do_dangerous_access {
		unsafe {
			// (a segmentation fault occurs in the code below)
			let v1 = *p1; // BAD
			let v2 = *p2; // BAD
			let v3 = *p3; // BAD
			println!("	v1 = {v1} (!)");
			println!("	v2 = {v2} (!)");
			println!("	v3 = {v3} (!)");
		}
	}
}

fn get_ptr_from_ref(val: i32) -> *const i32 {
	let my_val = val;
	let r1: &i32 = &my_val;
	let p1: *const i32 = std::ptr::from_ref(r1);

	unsafe {
		let v1 = *p1;
		println!("	v1 = {v1}");
	}

	return p1; // becomes dangling here
}

fn test_ptr_from_ref() {
	let p1 = get_ptr_from_ref(1);

	use_the_stack();

	unsafe {
		let v2 = *p1; // BAD
		let v3 = *get_ptr_from_ref(2); // BAD
		println!("	v2 = {v2} (!)"); // corrupt
		println!("	v3 = {v3} (!)"); // potentially corrupt
	}
}

// --- alloc and variations ---

fn test_alloc(do_dangerous_writes: bool) {
	unsafe {
		let layout = std::alloc::Layout::new::<i64>();
		let m1 = std::alloc::alloc(layout); // *mut u8
		let m2 = m1 as *mut i64; // *mut i64
		*m2 = 1;

		let v1 = *m1;
		let v2 = *m2;
		let v3 = std::ptr::read::<u8>(m1);
		let v4 = std::ptr::read::<i64>(m2);
		println!("	v1 = {v1}");
		println!("	v2 = {v2}");
		println!("	v3 = {v3}");
		println!("	v4 = {v4}");

		std::alloc::dealloc(m1, layout); // m1, m2 are now dangling

		let v5 = *m1;
		let v6 = *m2;
		let v7 = std::ptr::read::<u8>(m1); // BAD
		let v8 = std::ptr::read::<i64>(m2); // BAD
		println!("	v5 = {v5} (!)"); // corrupt
		println!("	v6 = {v6} (!)"); // corrupt
		println!("	v7 = {v7} (!)"); // corrupt
		println!("	v8 = {v8} (!)"); // corrupt

		if do_dangerous_writes {
			*m1 = 2; // BAD
			*m2 = 3; // BAD
			std::ptr::write::<u8>(m1, 4); // BAD
			std::ptr::write::<i64>(m2, 5); // BAD
		}
	}
}

fn test_alloc_array(do_dangerous_writes: bool) {
	unsafe {
		let layout = std::alloc::Layout::new::<[u8; 10]>();
		let m1 = std::alloc::alloc(layout);
		let m2 = m1 as *mut [u8; 10];
		(*m2)[0] = 1;
		(*m2)[1] = 2;

		let v1 = (*m2)[0];
		let v2 = (*m2)[1];
		println!("	v1 = {v1}");
		println!("	v2 = {v2}");

		std::alloc::dealloc(m2 as *mut u8, layout); // m1, m2 are now dangling

		let v3 = (*m2)[0]; // BAD
		let v4 = (*m2)[1]; // BAD
		println!("	v3 = {v3} (!)"); // corrupt
		println!("	v4 = {v4} (!)"); // corrupt

		if do_dangerous_writes {
			(*m2)[0] = 3; // BAD
			(*m2)[1] = 4; // BAD
			std::ptr::write::<u8>(m1, 5); // BAD
			std::ptr::write::<[u8; 10]>(m2, [6; 10]); // BAD
		}
	}
}

fn test_libc() {
	unsafe {
		let my_ptr = libc::malloc(256) as *mut i64;
		*my_ptr = 1;

		let v1 = *my_ptr;
		println!("	v1 = {v1}");

		libc::free(my_ptr as *mut libc::c_void);

		let v2 = *my_ptr; // BAD
		println!("	v2 = {v2} (!)"); // corrupt
	}
}

// --- loops ---

fn test_loop() {
	let my_local1 = 0;
	let first: *const i32 = &my_local1;
	let mut prev: *const i32 = &my_local1;

	for i in 1..5 {
		let my_local2 = i;
		let ours: *const i32 = &my_local2;

		use_the_stack();

		unsafe {
			let v1 = *first;
			let v2 = *ours;
			let v3 = *prev; // BAD
			println!("	v1 = {v1}");
			println!("	v2 = {v2}");
			println!("	v3 = {v3} (!)"); // corrupt
		}

		prev = ours;
	}
}

// --- enum ---

enum MyEnum {
	Value(i64),
}

fn test_enum() {
	let result: *const i64;

	{
		let e1 = MyEnum::Value(1);

		result = match e1 {
			MyEnum::Value(x) => { &x }
		};

		use_the_stack();

		unsafe {
			// not sure if this is OK or BAD.  Seen in real world code.
			let v1 = *result;
			println!("	v1 = {v1}");
		}
	}

	use_the_stack();

	unsafe {
		let v2 = *result; // BAD
		println!("	v2 = {v2}");
	}
}

// --- main ---

fn main() {
	println!("test_local_dangling:");
	test_local_dangling();

	println!("test_local_in_scope:");
	test_local_in_scope();

	println!("test_static:");
	test_static();

	println!("test_overwrite:");
	test_overwrite(true);

	println!("test_call_contexts:");
	test_call_contexts();

	println!("test_call_contexts_rec:");
	test_call_contexts_rec();

	println!("test_boxes_1:");
	test_boxes_1(false);

	println!("test_boxes_2:");
	test_boxes_2();

	println!("test_boxes_3:");
	test_boxes_3();

	println!("test_rc:");
	test_rc();

	println!("test_ptr_to_struct:");
	test_ptr_to_struct();

	println!("test_ptr_explicit:");
	test_ptr_explicit(false);

	println!("test_ptr_from_ref:");
	test_ptr_from_ref();

	println!("test_alloc:");
	test_alloc(false);

	println!("test_alloc_array:");
	test_alloc_array(false);

	println!("test_libc_malloc:");
	test_libc();

	println!("test_loop:");
	test_loop();

	println!("test_enum:");
	test_enum();
}
