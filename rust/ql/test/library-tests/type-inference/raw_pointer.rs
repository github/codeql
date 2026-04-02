use std::ptr::null_mut;

fn raw_pointer_const_deref(x: *const i32) -> i32 {
    let _y = unsafe { *x }; // $ type=_y:i32
    0
}

fn raw_pointer_mut_deref(x: *mut bool) -> i32 {
    let _y = unsafe { *x }; // $ type=_y:bool
    0
}

fn raw_const_borrow() {
    let a: i64 = 10;
    let x = &raw const a; // $ type=x:TPtrConst.i64
    unsafe {
        let _y = *x; // $ type=_y:i64
    }
}

fn raw_mut_borrow() {
    let mut a = 10i32;
    let x = &raw mut a; // $ type=x:TPtrMut.i32
    unsafe {
        let _y = *x; // $ type=_y:i32
    }
}

fn raw_mut_write(cond: bool) {
    let a = 10i32;
    // The type of `ptr_written` must be inferred from the write below.
    let ptr_written = null_mut(); // $ target=null_mut type=ptr_written:TPtrMut.i32
    if cond {
        unsafe {
            // NOTE: This write is undefined behavior because `ptr_written` is a null pointer.
            *ptr_written = a;
            let _y = *ptr_written; // $ type=_y:i32
        }
    }
}

fn raw_type_from_deref(cond: bool) {
    // The type of `ptr_read` must be inferred from the read below.
    let ptr_read = null_mut(); // $ target=null_mut type=ptr_read:TPtrMut.i64
    if cond {
        unsafe {
            // NOTE: This read is undefined behavior because `ptr_read` is a null pointer.
            let _y: i64 = *ptr_read;
        }
    }
}

pub fn test() {
    raw_pointer_const_deref(&10); // $ target=raw_pointer_const_deref
    raw_pointer_mut_deref(&mut true); // $ target=raw_pointer_mut_deref
    raw_const_borrow(); // $ target=raw_const_borrow
    raw_mut_borrow(); // $ target=raw_mut_borrow
    raw_mut_write(false); // $ target=raw_mut_write
    raw_type_from_deref(false); // $ target=raw_type_from_deref
}
