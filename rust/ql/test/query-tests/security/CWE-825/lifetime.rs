
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

	return &my_local1; // $ Source[rust/access-after-lifetime-ended]=local1
} // (return value immediately becomes dangling)

fn get_local_dangling_mut() -> *mut i64 {
	let mut my_local2: i64 = 2;

	return &mut my_local2; // $ Source[rust/access-after-lifetime-ended]=local2
} // (return value immediately becomes dangling)

fn get_local_dangling_raw_const() -> *const i64 {
	let my_local3: i64 = 3;

	return &raw const my_local3; // $ Source[rust/access-after-lifetime-ended]=local3
} // (return value immediately becomes dangling)

fn get_local_dangling_raw_mut() -> *mut i64 {
	let mut my_local4: i64 = 4;

	return &raw mut my_local4; // $ Source[rust/access-after-lifetime-ended]=local4
} // (return value immediately becomes dangling)

fn get_param_dangling(param5: i64) -> *const i64 {
	return &param5; // $ Source[rust/access-after-lifetime-ended]=param5
} // (return value immediately becomes dangling)

fn get_local_field_dangling() -> *const i64 {
	let val: MyValue;

	val = MyValue { value: 6 };
	return &val.value; // $ Source[rust/access-after-lifetime-ended]=localfield
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
		p7 = &raw const my_local7; // $ Source[rust/access-after-lifetime-ended]=local7
	} // (my_local goes out of scope, thus p7 is dangling)

	use_the_stack();

	unsafe {
		let v1 = *p1; // $ Alert[rust/access-after-lifetime-ended]=local1
		let v2 = *p2; // $ Alert[rust/access-after-lifetime-ended]=local2
		let v3 = *p3; // $ Alert[rust/access-after-lifetime-ended]=local3
		let v4 = *p4; // $ Alert[rust/access-after-lifetime-ended]=local4
		let v5 = *p5; // $ Alert[rust/access-after-lifetime-ended]=param5
		let v6 = *p6; // $ Alert[rust/access-after-lifetime-ended]=localfield
		let v7 = *p7; // $ Alert[rust/access-after-lifetime-ended]=local7
		*p2 = 8; // $ Alert[rust/access-after-lifetime-ended]=local2
		*p4 = 9; // $ Alert[rust/access-after-lifetime-ended]=local4

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
		if mode == 0 {
			// reads
			let v1 = *p1; // GOOD
			let v2 = *p2; // GOOD
			let v3 = *p3; // GOOD
			println!("	v1 = {v1}");
			println!("	v2 = {v2}");
			println!("	v3 = {v3}");
		}
		if mode == 200 {
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
		if mode == 0 {
			// reads
			let v1 = *p1; // GOOD
			let v2 = *p2; // GOOD
			println!("	v1 = {v1}");
			println!("	v2 = {v2}");
		}
		if mode == 210 {
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
		let v2 = *ptr; // $ Alert[rust/access-after-lifetime-ended]=local1
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
	let ptr = &my_local1; // $ Source[rust/access-after-lifetime-ended]=local1

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
			let v1 = (*prev)[0]; // $ MISSING: Alert[rust/access-after-lifetime-ended]=local2
			println!("	v1 = {v1} (!)"); // incorrect values in practice (except first iteration)
		}

		prev = &my_local2; // $ Source[rust/access-after-lifetime-ended]=local2
	} // (my_local2 goes out of scope, thus prev is dangling)

	unsafe {
		let v2 = (*prev)[0]; // $ Alert[rust/access-after-lifetime-ended]=local2
		println!("	v2 = {v2} (!)"); // corrupt in practice
	}
}

// --- enums ---

enum MyEnum {
	Value(i64),
}

enum MyEnum2 {
	Pointer(*const i64),
}

pub fn get_pointer_to_enum() -> *const MyEnum {
	let e1 = MyEnum::Value(1);
	let result: *const MyEnum = &e1; // $ Source[rust/access-after-lifetime-ended]=e1

	result
} // (e1 goes out of scope, so result is dangling)

pub fn get_pointer_in_enum() -> MyEnum2 {
	let v2 = 2;
	let e2 = MyEnum2::Pointer(&v2); // $ MISSING: Source[rust/access-after-lifetime-ended]=v2

	e2
} // (v2 goes out of scope, so the contained pointer is dangling)

pub fn get_pointer_from_enum() -> *const i64 {
	let e3 = MyEnum::Value(3);
	let result: *const i64;

	result = match e3 {
		MyEnum::Value(x) => { &x } // $ Source[rust/access-after-lifetime-ended]=match_x
	}; // (x goes out of scope, so result is possibly dangling already)

	use_the_stack();

	unsafe {
		let v0 = *result; // ?
		println!("	v0 = {v0} (?)");
	}

	result
} // (e3 goes out of scope, so result is definitely dangling now)

pub fn test_enums() {
	let e1 = get_pointer_to_enum();
	let e2 = get_pointer_in_enum();
	let result = get_pointer_from_enum();

	use_the_stack();

	unsafe {
		if let MyEnum::Value(v1) = *e1 { // $ Alert[rust/access-after-lifetime-ended]=e1
			println!("	v1 = {v1} (!)"); // corrupt in practice
		}
		if let MyEnum2::Pointer(p2) = e2 {
			let v2 = unsafe { *p2 }; // $ MISSING: Alert[rust/access-after-lifetime-ended]=v2
			println!("	v2 = {v2} (!)"); // corrupt in practice
		}
		let v3 = *result; // $ Alert[rust/access-after-lifetime-ended]=match_x
		println!("	v3 = {v3} (!)"); // corrupt in practice
	}
}

// --- recursive enum ---

enum RecursiveEnum {
	Wrapper(Box<RecursiveEnum>),
	Pointer(*const i64),
}

pub fn get_recursive_enum() -> Box<RecursiveEnum> {
	let v1 = 1;
	let enum1 = RecursiveEnum::Wrapper(Box::new(RecursiveEnum::Pointer(&v1))); // Source[rust/access-after-lifetime-ended]=v1
	let mut ref1 = &enum1;

	while let RecursiveEnum::Wrapper(inner) = ref1 {
		println!("	wrapper");
		ref1 = &inner;
	}
	if let RecursiveEnum::Pointer(ptr) = ref1 {
		let v2: i64 = unsafe { **ptr }; // GOOD
		println!("	v2 = {v2}");
	}

	return Box::new(enum1);
} // (v1 goes out of scope, thus the contained pointer is dangling)

pub fn test_recursive_enums() {
	let enum1 = *get_recursive_enum();
	let mut ref1 = &enum1;

	while let RecursiveEnum::Wrapper(inner) = ref1 {
		println!("	wrapper");
		ref1 = &inner;
	}
	if let RecursiveEnum::Pointer(ptr) = ref1 {
		let v3: i64 = unsafe { **ptr }; // Alert[rust/access-after-lifetime-ended]=v1
		println!("	v3 = {v3} (!)"); // corrupt in practice
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
		p1 = std::ptr::addr_of_mut!(my_pair); // $ Source[rust/access-after-lifetime-ended]=my_pair
		p2 = std::ptr::addr_of!(my_pair.a); // $ MISSING: Source[rust/access-after-lifetime-ended]=my_pair_a
		p3 = std::ptr::addr_of_mut!(my_pair.b); // $ MISSING: Source[rust/access-after-lifetime-ended]=my_pair_b

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
				let v5 = (*p1).a; // $ Alert[rust/access-after-lifetime-ended]=my_pair
				println!("	v5 = {v5} (!)"); // dropped in practice
			},
			220 => {
				// another read
				let v6 = (*p1).b; // $ Alert[rust/access-after-lifetime-ended]=my_pair
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
				(*p1).a = 6; // $ Alert[rust/access-after-lifetime-ended]=my_pair
				*p3 = 7; // $ MISSING: Alert
			},
			223 => {
				// another write
				(*p1).b = 8; // $ Alert[rust/access-after-lifetime-ended]=my_pair
			},
			_ => {}
		}
	}
}

fn get_ptr_from_ref(val: i32) -> *const i32 {
	let my_val = val;
	let r1: &i32 = &my_val; // $ Source[rust/access-after-lifetime-ended]=my_val
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
		let v2 = *p1; // $ Alert[rust/access-after-lifetime-ended]=my_val
		let v3 = *get_ptr_from_ref(2); // $ Alert[rust/access-after-lifetime-ended]=my_val
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
	} // rc1 goes out of scope, the reference count is 0, so p1, p2 are dangling

	unsafe {
		let v5 = *p1; // $ MISSING: Alert
		let v6 = *p2; // $ MISSING: Alert
		println!("	v5 = {v5} (!)"); // corrupt in practice
		println!("	v6 = {v6} (!)"); // corrupt in practice
	}

	// note: simialar things are likely possible with Ref, RefMut, RefCell,
	//       Vec and others.
}

// --- closures ---

fn get_closure(p3: *const i64, p4: *const i64) -> impl FnOnce() {
	let my_local1: i64 = 1;
	let my_local2: i64 = 2;
	let p1: *const i64 = &my_local1; // $ MISSING: Source[rust/access-after-lifetime-ended]=local1

	return move || { // captures `my_local2`, `p1`, `p3`, `p4` by value (due to `move`)
		let p2: *const i64 = &my_local2;

		unsafe {
			let v1 = *p1; // $ MISSING: Alert[rust/access-after-lifetime-ended]=local1
			let v2 = *p2; // GOOD
			let v3 = *p3; // GOOD
			let v4 = *p4; // $ MISSING: Alert[rust/access-after-lifetime-ended]=local4
			println!("	v1 = {v1} (!)"); // corrupt in practice
			println!("	v2 = {v2}");
			println!("	v3 = {v3}");
			println!("	v4 = {v4} (!)");
		}
	};
} // (`my_local1` goes out of scope, thus `p1` is dangling)

fn with_closure(ptr: *const i64, closure: fn(*const i64, *const i64)) {
	let my_local5: i64 = 5;

	closure(ptr,
		&my_local5);
}

pub fn test_closures() {
	let closure;
	let my_local3: i64 = 3;
	{
		let my_local4: i64 = 4;
		closure = get_closure( &my_local3,
			&my_local4); // $ MISSING: Source[rust/access-after-lifetime-ended]=local4
	} // (`my_local4` goes out of scope, so `p4` is dangling)

	use_the_stack();

	closure();

	with_closure(&my_local3, |p1, p2| {
		unsafe {
			let v5 = *p1; // GOOD
			let v6 = *p2; // $ GOOD
			println!("	v5 = {v5}");
			println!("	v6 = {v6}");
		}
	});
}

// --- async ---

fn get_async_closure(p3: *const i64, p4: *const i64) -> impl std::future::Future<Output = ()> {
	let my_local1: i64 = 1;
	let my_local2: i64 = 2;
	let p1: *const i64 = &my_local1;

	return async move { // captures `my_local2`, `p1`, `p3`, `p4` by value (due to `move`)
		let p2: *const i64 = &my_local2;

		unsafe {
			let v1 = *p1; // $ MISSING: Alert
			let v2 = *p2; // GOOD
			let v3 = *p3; // GOOD
			let v4 = *p4; // $ MISSING: Alert
			println!("	v1 = {v1} (!)"); // corrupt in practice
			println!("	v2 = {v2}");
			println!("	v3 = {v3}");
			println!("	v4 = {v4} (!)");
		}
	};
} // (`my_local1` goes out of scope, thus `p1` is dangling)

pub fn test_async() {
	let async_closure;
	let my_local3: i64 = 3;
	{
		let my_local4: i64 = 4;
		async_closure = get_async_closure(&my_local3,
			&my_local4);
	} // (`my_local4` goes out of scope, so `p4` is dangling)

	use_the_stack();

	futures::executor::block_on(async_closure);
}

// --- lifetime annotations ---

fn select_str<'a>(cond: bool, a: &'a str, b: &'a str) -> &'a str {
	if cond { a } else { b }
}

struct MyRefStr<'a> {
	ref_str: &'a str,
}

pub fn test_lifetime_annotations() {
	let str1: *const str;
	{
		let foo = String::from("foo");
		let bar = String::from("bar");
		str1 = select_str(true, foo.as_str(), bar.as_str());

		unsafe {
			let v1 = &*str1; // GOOD
			println!("	v1 = {v1}");
		}
	} // (`foo`, `bar` go out of scope, the return value of `select_str` has the same lifetime, thus `str1` is dangling)

	unsafe {
		let v2 = &*str1; // $ MISSING: Alert
		println!("	v2 = {v2} (!)"); // corrupt in practice
	}

	let my_ref;
	let str2: *const str;
	{
		let baz = String::from("baz");
		my_ref = MyRefStr { ref_str: baz.as_str() };
		str2 = &*my_ref.ref_str;

		unsafe {
			let v3 = &*str2; // GOOD
			println!("	v3 = {v3}");
		}
	} // (`baz` goes out of scope, `ref_str` has the same lifetime, thus `str2` is dangling)

	use_the_stack();

	unsafe {
		let v4 = &*str2; // $ MISSING: Alert
		println!("	v4 = {v4} (!)"); // corrupt in practice
	}
}

// --- implicit dereferences ---

pub fn test_implicit_derefs() {
	let ref1;
	{
		let str2;
		{
			let str1 = "bar";
			str2 = "foo".to_string() + &str1; // $ Source[rust/access-after-lifetime-ended]=str1
			ref1 = &raw const str2; // $ Source[rust/access-after-lifetime-ended]=str2
		} // (str1 goes out of scope, but it's been copied into str2)

		unsafe {
			let v1 = &*ref1; // $ SPURIOUS: Alert[rust/access-after-lifetime-ended]=str1
			println!("	v1 = {v1}");
		}
	} // (str2 goes out of scope, thus ref1 is dangling)

	use_the_stack();

	unsafe {
		let v2 = &*ref1; // $ Alert[rust/access-after-lifetime-ended]=str2 SPURIOUS: Alert[rust/access-after-lifetime-ended]=str1
		println!("	v2 = {v2} (!)"); // corrupt in practice
	}
}

// --- members ---

struct MyType {
	value: i64,
}

impl MyType {
	fn test(&self) {
		let r1 = unsafe {
			let v1 = &self;
			&v1.value
		};
		let (r2, r3) = unsafe {
			let v2 = &self;
			(&v2.value,
			 &self.value)
		};

		use_the_stack();

		let v1 = *r1;
		let v2 = *r2;
		let v3 = *r3;
		println!("	v1 = {v1}");
		println!("	v2 = {v2}");
		println!("	v3 = {v3}");
	}
}

pub fn test_members() {
	let mt = MyType { value: 1 };
	mt.test();
}

// --- enum members ---

struct MyValue2 {
	value: i64
}

enum MyEnum3 {
	Value(MyValue2),
}

impl MyEnum3 {
	pub fn test_match(&self) -> &i64 {
		let r1 = match self {
			MyEnum3::Value(v2) => &v2.value, // $ SPURIOUS: Source[rust/access-after-lifetime-ended]=v2_value
		};

		r1
	}
}

pub fn test_enum_members() {
	let v1 = MyValue2 { value: 1 };
	let e1 = MyEnum3::Value(v1);

	let r1 = e1.test_match();

	use_the_stack();

	let v3 = *r1; // $ SPURIOUS: Alert[rust/access-after-lifetime-ended]=v2_value
	println!("	v3 = {v3}");
}

// --- macros ---

macro_rules! my_macro1 {
	() => {
		let ptr: *const i64;
		{
			let val: i64 = 1;
			ptr = &val;
		}

		unsafe {
			let v = *ptr;
			println!("	v = {v}");
		}
	}
}

macro_rules! my_macro2 {
	() => {
		{
			let val: i64 = 1;
			let ptr: *const i64 = &val;
			ptr
		}
	}
}

pub fn test_macros() {
	my_macro1!();
	my_macro1!();

	let ptr = my_macro2!(); // $ SPURIOUS: Source[rust/access-after-lifetime-ended]=ptr
	unsafe {
		let v = *ptr; // $ SPURIOUS: Alert[rust/access-after-lifetime-ended]=ptr
		println!("	v = {v}");
	}
}

// --- examples from qhelp ---

fn get_pointer() -> *const i64 {
	let val = 123;

	return &val; // $ Source[rust/access-after-lifetime-ended]=val
} // lifetime of `val` ends here, the pointer becomes dangling

pub fn test_lifetimes_example_bad() {
	let ptr = get_pointer();
	let val;

	use_the_stack();

	unsafe {
		val = *ptr; // $ Alert[rust/access-after-lifetime-ended]=val
	}

	println!("	val = {val} (!)"); // corrupt in practice
}

fn get_box() -> Box<i64> {
	let val = 123;

	return Box::new(val);
}

pub fn test_lifetimes_example_good() {
	let ptr = get_box();
	let val;

	use_the_stack();

	val = *ptr; // GOOD

	println!("	val = {val}");
}
