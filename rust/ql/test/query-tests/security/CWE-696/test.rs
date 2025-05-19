// --- attribute variants ---

use std::io::Write;

fn harmless1_1() {
    // ...
}

#[ctor::ctor]
fn harmless1_2() {
    // ...
}

#[ctor::dtor]
fn harmless1_3() {
    // ...
}

fn harmless1_4() {
    _ = std::io::stdout().write(b"Hello, world!");
}

#[rustfmt::skip]
fn harmless1_5() {
    _ = std::io::stdout().write(b"Hello, world!");
}

#[ctor::ctor] // $ Source=source1_1
fn bad1_1() {
    _ = std::io::stdout().write(b"Hello, world!"); // $ Alert[rust/ctor-initialization]=source1_1
}

#[ctor::dtor] // $ Source=source1_2
fn bad1_2() {
    _ = std::io::stdout().write(b"Hello, world!"); // $ Alert[rust/ctor-initialization]=source1_2
}

#[rustfmt::skip]
#[ctor::dtor] // $ Source=source1_3
#[rustfmt::skip]
fn bad1_3() {
    _ = std::io::stdout().write(b"Hello, world!"); // $ Alert[rust/ctor-initialization]=source1_3
}

// --- code variants ---

use ctor::ctor;
use std::io::*;

#[ctor] // $ Source=source2_1
fn bad2_1() {
    _ = stdout().write(b"Hello, world!"); // $ Alert[rust/ctor-initialization]=source2_1
}

#[ctor] // $ Source=source2_2
fn bad2_2() {
    _ = stderr().write_all(b"Hello, world!"); // $ Alert[rust/ctor-initialization]=source2_2
}

#[ctor] // $ Source=source2_3
fn bad2_3() {
    println!("Hello, world!"); // $ Alert[rust/ctor-initialization]=source2_3
}

#[ctor] // $ Source=source2_4
fn bad2_4() {
    let mut buff = String::new();
    _ = std::io::stdin().read_line(&mut buff); // $ Alert[rust/ctor-initialization]=source2_4
}

use std::fs;

#[ctor] // $ MISSING: Source=source2_5
fn bad2_5() {
    let _buff = fs::File::create("hello.txt").unwrap(); // $ MISSING: Alert[rust/ctor-initialization]=source2_5
}

#[ctor] // $ MISSING: Source=source2_6
fn bad2_6() {
    let _t = std::time::Instant::now(); // $ MISSING: Alert[rust/ctor-initialization]=source2_6
}

use std::time::Duration;

const DURATION2_7: Duration = Duration::new(1, 0);

#[ctor] // $ Source=source2_7
fn bad2_7() {
    std::thread::sleep(DURATION2_7); // $ Alert[rust/ctor-initialization]=source2_7
}

use std::process;

#[ctor] // $ Source=source2_8
fn bad2_8() {
    process::exit(1234); // $ Alert[rust/ctor-initialization]=source2_8
}

#[ctor::ctor]
fn harmless2_9() {
    libc_print::libc_println!("Hello, world!"); // does not use the std library
}

#[ctor::ctor]
fn harmless2_10() {
    core::assert!(true); // core library should be OK in this context
}

extern crate alloc;
use alloc::alloc::{alloc, dealloc, Layout};

#[ctor::ctor]
unsafe fn harmless2_11() {
    let layout = Layout::new::<u64>();
    let ptr = alloc(layout); // alloc library should be OK in this context

    if !ptr.is_null() {
        dealloc(ptr, layout);
    }
}

// --- transitive cases ---

fn call_target3_1() {
    _ = stderr().write_all(b"Hello, world!"); // $ Alert=source3_1 Alert=source3_3 Alert=source3_4
}

#[ctor] // $ Source=source3_1
fn bad3_1() {
    call_target3_1();
}

fn call_target3_2() {
    for _x in 0..10 {
        // ...
    }
}

#[ctor]
fn harmless3_2() {
    call_target3_2();
}

#[ctor] // $ Source=source3_3
fn bad3_3() {
    call_target3_1();
    call_target3_2();
}

#[ctor] // $ Source=source3_4
fn bad3_4() {
    bad3_3();
}

fn harmless3_5() {
    call_target3_1();
    call_target3_2();
}

// --- macros ---

macro_rules! macro4_1 {
    () => {
        _ = std::io::stdout().write(b"Hello, world!");
    };
}

#[ctor] // $ Source=source4_1
fn bad4_1() {
    macro4_1!(); // $ Alert[rust/ctor-initialization]=source4_1
}
