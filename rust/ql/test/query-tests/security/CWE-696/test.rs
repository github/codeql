
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

#[ctor::ctor]
fn bad1_1() { // $ Alert[rust/ctor-initialization]
    _ = std::io::stdout().write(b"Hello, world!");
}

#[ctor::dtor]
fn bad1_2() { // $ Alert[rust/ctor-initialization]
    _ = std::io::stdout().write(b"Hello, world!");
}

#[rustfmt::skip]
#[ctor::dtor]
#[rustfmt::skip]
fn bad1_3() { // $ Alert[rust/ctor-initialization]
    _ = std::io::stdout().write(b"Hello, world!");
}

// --- code variants ---

use ctor::ctor;
use std::io::*;

#[ctor]
fn bad2_1() { // $ Alert[rust/ctor-initialization]
    _ = stdout().write(b"Hello, world!");
}

#[ctor]
fn bad2_2() { // $ Alert[rust/ctor-initialization]
    _ = stderr().write_all(b"Hello, world!");
}

#[ctor]
fn bad2_3() { // $ Alert[rust/ctor-initialization]
    println!("Hello, world!");
}

#[ctor]
fn bad2_4() { // $ Alert[rust/ctor-initialization]
    let mut buff = String::new();
    _ = std::io::stdin().read_line(&mut buff);
}

use std::fs;

#[ctor]
fn bad2_5() { // $ MISSING: Alert[rust/ctor-initialization]
    let _buff = fs::File::create("hello.txt").unwrap();
}

#[ctor]
fn bad2_6() { // $ MISSING: Alert[rust/ctor-initialization]
    let _t = std::time::Instant::now();
}

use std::time::Duration;

const DURATION2_7: Duration = Duration::new(1, 0);

#[ctor]
fn bad2_7() { // $ Alert[rust/ctor-initialization]
    std::thread::sleep(DURATION2_7);
}

use std::process;

#[ctor]
fn bad2_8() { // $ Alert[rust/ctor-initialization]
    process::exit(1234);
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
    _ = stderr().write_all(b"Hello, world!");
}

#[ctor]
fn bad3_1() { // $ MISSING: Alert[rust/ctor-initialization]
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

#[ctor]
fn bad3_3() { // $ MISSING: Alert[rust/ctor-initialization]
    call_target3_1();
    call_target3_2();
}

#[ctor]
fn bad3_4() { // $ MISSING: Alert[rust/ctor-initialization]
    bad3_3();
}

// --- macros ---

macro_rules! macro4_1 {
    () => {
        _ = std::io::stdout().write(b"Hello, world!");
    };
}

#[ctor]
fn bad4_1() { // $ Alert[rust/ctor-initialization]
    macro4_1!();
}
