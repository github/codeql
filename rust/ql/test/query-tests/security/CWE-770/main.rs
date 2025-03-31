#![feature(alloc_layout_extra)]
#![feature(allocator_api)]
#![feature(try_with_capacity)]
#![feature(box_vec_non_null)]
#![feature(non_null_from_ref)]

struct MyStruct {
    _a: usize,
    _b: i64,
}

unsafe fn test_std_alloc_from_size(v: usize) {
    let l1 = std::alloc::Layout::from_size_align(16, 1).unwrap();
    let m1 = std::alloc::alloc(l1);
    let _ = std::alloc::alloc(l1.align_to(8).unwrap());
    let _ = std::alloc::alloc(l1.align_to(8).unwrap().pad_to_align());
    let _ = std::alloc::alloc_zeroed(l1);
    let _ = std::alloc::realloc(m1, l1, v); // $ Alert[rust/uncontrolled-allocation-size]=arg1

    let l2 = std::alloc::Layout::from_size_align(v, 1).unwrap();
    let _ = std::alloc::alloc(l2); // $ Alert[rust/uncontrolled-allocation-size]=arg1
    let _ = std::alloc::alloc(l2.align_to(8).unwrap()); // $ Alert[rust/uncontrolled-allocation-size]=arg1
    let _ = std::alloc::alloc(l2.align_to(8).unwrap().pad_to_align()); // $ Alert[rust/uncontrolled-allocation-size]=arg1
    let _ = std::alloc::alloc_zeroed(l2); // $ Alert[rust/uncontrolled-allocation-size]=arg1

    let l3 = std::alloc::Layout::from_size_align(1, v).unwrap(); // not obviously dangerous?
    let _ = std::alloc::alloc(l3);

    let l4 = std::alloc::Layout::from_size_align_unchecked(v, 1);
    let _ = std::alloc::alloc(l4); // $ Alert[rust/uncontrolled-allocation-size]=arg1

    let l5 = std::alloc::Layout::from_size_align_unchecked(v * std::mem::size_of::<i64>(), std::mem::size_of::<i64>());
    let _ = std::alloc::alloc(l5); // $ Alert[rust/uncontrolled-allocation-size]=arg1

    let s6 = (std::mem::size_of::<MyStruct>() * v) + 1;
    let l6 = std::alloc::Layout::from_size_align_unchecked(s6, 4);
    let _ = std::alloc::alloc(l6); // $ Alert[rust/uncontrolled-allocation-size]=arg1

    let l7 = std::alloc::Layout::from_size_align_unchecked(l6.size(), 8);
    let _ = std::alloc::alloc(l7); // $ Alert[rust/uncontrolled-allocation-size]=arg1
}

unsafe fn test_std_alloc_new_repeat_extend(v: usize) {
    let l1 = std::alloc::Layout::new::<[u8; 10]>();
    let _ = std::alloc::alloc(l1);

    let l2 = std::alloc::Layout::new::<MyStruct>();
    let _ = std::alloc::alloc(l2);
    let _ = std::alloc::alloc(l2.repeat(10).unwrap().0);
    let _ = std::alloc::alloc(l2.repeat(v).unwrap().0); // $ Alert[rust/uncontrolled-allocation-size]=arg1
    let _ = std::alloc::alloc(l2.repeat(v + 1).unwrap().0); // $ Alert[rust/uncontrolled-allocation-size]=arg1
    let _ = std::alloc::alloc(l2.repeat_packed(10).unwrap());
    let _ = std::alloc::alloc(l2.repeat_packed(v).unwrap()); // $ Alert[rust/uncontrolled-allocation-size]=arg1
    let _ = std::alloc::alloc(l2.repeat_packed(v * 10).unwrap()); // $ Alert[rust/uncontrolled-allocation-size]=arg1

    let l3 = std::alloc::Layout::array::<u8>(10).unwrap();
    let _ = std::alloc::alloc(l3);
    let (k1, _offs1) = l3.repeat(v).expect("arithmetic overflow?");
    let _ = std::alloc::alloc(k1); // $ Alert[rust/uncontrolled-allocation-size]=arg1
    let (k2, _offs2) = l3.extend(k1).unwrap();
    let _ = std::alloc::alloc(k2); // $ Alert[rust/uncontrolled-allocation-size]=arg1
    let (k3, _offs3) = k1.extend(l3).unwrap();
    let _ = std::alloc::alloc(k3); // $ Alert[rust/uncontrolled-allocation-size]=arg1
    let _ = std::alloc::alloc(l3.extend_packed(k1).unwrap()); // $ Alert[rust/uncontrolled-allocation-size]=arg1
    let _ = std::alloc::alloc(k1.extend_packed(l3).unwrap()); // $ Alert[rust/uncontrolled-allocation-size]=arg1

    let l4 = std::alloc::Layout::array::<u8>(v).unwrap();
    let _ = std::alloc::alloc(l4); // $ Alert[rust/uncontrolled-allocation-size]=arg1
}

fn clamp<T: std::cmp::PartialOrd>(v: T, min: T, max: T) -> T {
    if v < min {
        return min;
    } else if v > max {
        return max;
    } else {
        return v;
    }
}

unsafe fn test_fn_alloc_bounded(v: usize) {
    let layout = std::alloc::Layout::from_size_align(v, 1).unwrap();
    let _ = std::alloc::alloc(layout); // $ SPURIOUS: Alert[rust/uncontrolled-allocation-size]=arg1
}

unsafe fn test_fn_alloc_unbounded(v: usize) {
    let layout = std::alloc::Layout::from_size_align(v, 1).unwrap();
    let _ = std::alloc::alloc(layout); // $ Alert[rust/uncontrolled-allocation-size]=arg1
}

unsafe fn test_std_alloc_with_bounds(v: usize, limit: usize) {
    let l1 = std::alloc::Layout::array::<u32>(v).unwrap();

    if v < 100 {
        let l2 = std::alloc::Layout::array::<u32>(v).unwrap();
        let _ = std::alloc::alloc(l1); // $ SPURIOUS: Alert[rust/uncontrolled-allocation-size]=arg1
        let _ = std::alloc::alloc(l2); // $ SPURIOUS: Alert[rust/uncontrolled-allocation-size]=arg1

        test_fn_alloc_bounded(v);
    } else {
        let l3 = std::alloc::Layout::array::<u32>(v).unwrap();
        let _ = std::alloc::alloc(l1); // $ Alert[rust/uncontrolled-allocation-size]=arg1
        let _ = std::alloc::alloc(l3); // $ Alert[rust/uncontrolled-allocation-size]=arg1

        test_fn_alloc_unbounded(v);
    }

    if v == 100 {
        let _ = std::alloc::alloc(l1); // $ SPURIOUS: Alert[rust/uncontrolled-allocation-size]=arg1
    } else {
        let _ = std::alloc::alloc(l1); // $ Alert[rust/uncontrolled-allocation-size]=arg1
    }

    if (v < limit) {
        let l4 = std::alloc::Layout::from_size_align(v, 1).unwrap();
        let _ = std::alloc::alloc(l4); // $ SPURIOUS: Alert[rust/uncontrolled-allocation-size]=arg1
    }

    if (v < 2 * v) { // not a good bound
        let l5 = std::alloc::Layout::from_size_align(v, 1).unwrap();
        let _ = std::alloc::alloc(l5); // $ Alert[rust/uncontrolled-allocation-size]=arg1
    }

    if (true && v < limit && true) {
        let l6 = std::alloc::Layout::from_size_align(v, 1).unwrap();
        let _ = std::alloc::alloc(l6); // $ SPURIOUS: Alert[rust/uncontrolled-allocation-size]=arg1
    }

    let mut l7;
    if (v < 100) {
        l7 = std::alloc::Layout::from_size_align(v, 1).unwrap();
    } else {
        l7 = std::alloc::Layout::from_size_align(100, 1).unwrap();
    }
    let _ = std::alloc::alloc(l7); // $ SPURIOUS: Alert[rust/uncontrolled-allocation-size]=arg1

    {
        let mut v_mut = v;

        if v_mut > 100 {
            v_mut = 100;
        }

        let l8 = std::alloc::Layout::array::<u32>(v_mut).unwrap();
        let l9 = std::alloc::Layout::array::<u32>(v).unwrap();
        let _ = std::alloc::alloc(l1); // $ Alert[rust/uncontrolled-allocation-size]=arg1
        let _ = std::alloc::alloc(l8); // $ SPURIOUS: Alert[rust/uncontrolled-allocation-size]=arg1
        let _ = std::alloc::alloc(l9); // $ Alert[rust/uncontrolled-allocation-size]=arg1
    }

    let l10 = std::alloc::Layout::array::<u32>(std::cmp::min(v, 100)).unwrap();
    let _ = std::alloc::alloc(l10); // $ SPURIOUS: Alert[rust/uncontrolled-allocation-size]=arg1

    let l11 = std::alloc::Layout::array::<u32>(std::cmp::max(v, 100)).unwrap();
    let _ = std::alloc::alloc(l11); // $ Alert[rust/uncontrolled-allocation-size]=arg1

    let l12 = std::alloc::Layout::array::<u32>(clamp(v, 1, 100)).unwrap();
    let _ = std::alloc::alloc(l12); // $ SPURIOUS: Alert[rust/uncontrolled-allocation-size]=arg1

    for i in 0..10 {
        let l13 = std::alloc::Layout::from_size_align(v, 1).unwrap();
        let _ = std::alloc::alloc(l13); // $ Alert[rust/uncontrolled-allocation-size]=arg1

        if (v > 1000) {
            continue;
        }

        let l14 = std::alloc::Layout::from_size_align(v, 1).unwrap();
        let _ = std::alloc::alloc(l13); // $ SPURIOUS: Alert[rust/uncontrolled-allocation-size]=arg1
        let _ = std::alloc::alloc(l14); // $ SPURIOUS: Alert[rust/uncontrolled-allocation-size]=arg1
    }

    if v > 100 {
        return;
    }
    let l15 = std::alloc::Layout::from_size_align(v, 1).unwrap();
    let _ = std::alloc::alloc(l1); // $ SPURIOUS: Alert[rust/uncontrolled-allocation-size]=arg1
    let _ = std::alloc::alloc(l15); // $ SPURIOUS: Alert[rust/uncontrolled-allocation-size]=arg1
}

use std::alloc::{GlobalAlloc, Allocator};

unsafe fn test_system_alloc(v: usize) {
    let l1 = std::alloc::Layout::array::<u8>(10).unwrap();
    let _ = std::alloc::System.alloc(l1);
    let _ = std::alloc::System.alloc_zeroed(l1);
    let _ = std::alloc::System.allocate(l1).unwrap();
    let _ = std::alloc::System.allocate_zeroed(l1).unwrap();
    let _ = std::alloc::Global.allocate(l1).unwrap();
    let _ = std::alloc::Global.allocate_zeroed(l1).unwrap();

    let l2 = std::alloc::Layout::array::<u8>(v).unwrap();
    let _ = std::alloc::System.alloc(l2); // $ Alert[rust/uncontrolled-allocation-size]=arg1
    let _ = std::alloc::System.alloc_zeroed(l2); // $ Alert[rust/uncontrolled-allocation-size]=arg1
    let _ = std::alloc::System.allocate(l2).unwrap(); // $ Alert[rust/uncontrolled-allocation-size]=arg1
    let _ = std::alloc::System.allocate_zeroed(l2).unwrap(); // $ Alert[rust/uncontrolled-allocation-size]=arg1
    let _ = std::alloc::Global.allocate(l2).unwrap(); // $ Alert[rust/uncontrolled-allocation-size]=arg1
    let _ = std::alloc::Global.allocate_zeroed(l2).unwrap(); // $ Alert[rust/uncontrolled-allocation-size]=arg1

    let l3 = std::alloc::Layout::array::<u8>(10).unwrap();
    let m3 = std::alloc::System.alloc(l3);
    let _ = std::alloc::System.realloc(m3, l3, v); // $ MISSING: Alert[rust/uncontrolled-allocation-size]

    let l4 = std::alloc::Layout::array::<u8>(10).unwrap();
    let m4 = std::ptr::NonNull::<u8>::new(std::alloc::alloc(l4)).unwrap();
    if v > 10 {
        if v % 2 == 0 {
            let _ = std::alloc::System.grow(m4, l4, l2).unwrap(); // $ Alert[rust/uncontrolled-allocation-size]=arg1
        } else {
            let _ = std::alloc::System.grow_zeroed(m4, l4, l2).unwrap(); // $ Alert[rust/uncontrolled-allocation-size]=arg1
        }
    } else {
        let _ = std::alloc::System.shrink(m4, l4, l2).unwrap();
    }
}

unsafe fn test_libc_alloc(v: usize) {
    let m1 = libc::malloc(256);
    let _ = libc::malloc(v); // $ Alert[rust/uncontrolled-allocation-size]=arg1
    let _ = libc::aligned_alloc(8, v); // $ Alert[rust/uncontrolled-allocation-size]=arg1
    let _ = libc::aligned_alloc(v, 8);
    let _ = libc::calloc(64, v); // $ Alert[rust/uncontrolled-allocation-size]=arg1
    let _ = libc::calloc(v, std::mem::size_of::<i64>()); // $ Alert[rust/uncontrolled-allocation-size]=arg1
    let _ = libc::realloc(m1, v); // $ Alert[rust/uncontrolled-allocation-size]=arg1
}

unsafe fn test_vectors(v: usize) {
    let _ = Vec::<u64>::try_with_capacity(v).unwrap(); // $ MISSING: Alert[rust/uncontrolled-allocation-size]
    let _ = Vec::<u64>::with_capacity(v); // $ MISSING: Alert[rust/uncontrolled-allocation-size]
    let _ = Vec::<u64>::try_with_capacity_in(v, std::alloc::Global).unwrap(); // $ MISSING: Alert[rust/uncontrolled-allocation-size]
    let _ = Vec::<u64>::with_capacity_in(v, std::alloc::Global); // $ MISSING: Alert[rust/uncontrolled-allocation-size]

    let mut v1 = Vec::<u64>::with_capacity(100);
    v1.reserve(v); // $ MISSING: Alert[rust/uncontrolled-allocation-size]
    v1.reserve_exact(v); // $ MISSING: Alert[rust/uncontrolled-allocation-size]
    let _ = v1.try_reserve(v).unwrap(); // $ MISSING: Alert[rust/uncontrolled-allocation-size]
    let _ = v1.try_reserve_exact(v).unwrap(); // $ MISSING: Alert[rust/uncontrolled-allocation-size]
    v1.resize(v, 1); // $ MISSING: Alert[rust/uncontrolled-allocation-size]
    v1.set_len(v); // $ MISSING: Alert[rust/uncontrolled-allocation-size]

    let l2 = std::alloc::Layout::new::<[u64; 200]>();
    let m2 = std::ptr::NonNull::<u64>::new(std::alloc::alloc(l2).cast::<u64>()).unwrap();
    let _ = Vec::<u64>::from_parts(m2, v, 200); // $ MISSING: Alert[rust/uncontrolled-allocation-size]

    let m3 = std::ptr::NonNull::<u64>::new(std::alloc::alloc(l2).cast::<u64>()).unwrap();
    let _ = Vec::<u64>::from_parts(m3, 100, v); // $ MISSING: Alert[rust/uncontrolled-allocation-size]

    let m4 = std::ptr::NonNull::<u64>::new(std::alloc::alloc(l2).cast::<u64>()).unwrap();
    let _ = Vec::<u64>::from_parts_in(m4, 100, v, std::alloc::Global); // $ MISSING: Alert[rust/uncontrolled-allocation-size]

    let m5 = std::alloc::alloc(l2).cast::<u64>();
    let _ = Vec::<u64>::from_raw_parts(m5, v, 200); // $ MISSING: Alert[rust/uncontrolled-allocation-size]

    let m6 = std::alloc::alloc(l2).cast::<u64>();
    let _ = Vec::<u64>::from_raw_parts(m6, 100, v); // $ MISSING: Alert[rust/uncontrolled-allocation-size]

    let m7 = std::alloc::alloc(l2).cast::<u64>();
    let _ = Vec::<u64>::from_raw_parts_in(m7, 100, v, std::alloc::Global); // $ MISSING: Alert[rust/uncontrolled-allocation-size]
}

// --- examples from the qhelp ---

struct Error {
    msg: String,
}

impl From<std::num::ParseIntError> for Error {
    fn from(err: std::num::ParseIntError) -> Self {
        Error { msg: "ParseIntError".to_string() }
    }
}

impl From<&str> for Error {
    fn from(msg: &str) -> Self {
        Error { msg: msg.to_string() }
    }
}

fn allocate_buffer_bad(user_input: String) -> Result<*mut u8, Error> {
    let num_bytes = user_input.parse::<usize>()? * std::mem::size_of::<u64>();

    let layout = std::alloc::Layout::from_size_align(num_bytes, 1).unwrap();
    unsafe {
        let buffer = std::alloc::alloc(layout); // $ Alert[rust/uncontrolled-allocation-size]=example1

        Ok(buffer)
    }
}

const BUFFER_LIMIT: usize = 10 * 1024;

fn allocate_buffer_good(user_input: String) -> Result<*mut u8, Error> {
    let size = user_input.parse::<usize>()?;
    if (size > BUFFER_LIMIT) {
        return Err("Size exceeds limit".into());
    }
    let num_bytes = size * std::mem::size_of::<u64>();

    let layout = std::alloc::Layout::from_size_align(num_bytes, 1).unwrap();
    unsafe {
        let buffer = std::alloc::alloc(layout); // $ SPURIOUS: Alert[rust/uncontrolled-allocation-size]=example2

        Ok(buffer)
    }
}

fn test_examples() {
    allocate_buffer_bad(std::env::args().nth(1).unwrap_or("0".to_string())); // $ Source=example1
    allocate_buffer_good(std::env::args().nth(1).unwrap_or("0".to_string())); // $ Source=example2
}

// --- main ---

fn main() {
    println!("--- begin ---");

    let v = std::env::args().nth(1).unwrap_or("1024".to_string()).parse::<usize>().unwrap(); // $ Source=arg1

    unsafe {
        test_std_alloc_from_size(v);
        test_std_alloc_new_repeat_extend(v);
        test_std_alloc_with_bounds(v, 1000);
        test_system_alloc(v);
        test_libc_alloc(v);
        test_vectors(v);
        test_examples();
    }

    println!("--- end ---");
}
