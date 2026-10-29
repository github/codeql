#![allow(dead_code)]
/**
 * total lines in this file: 30
 * of which code: 20
 * of which only comments: 6
 * of which blank: 4
 */

#[derive(Debug)]
struct MyStruct {
    name: String,
    value: i32,
}

impl MyStruct {
    fn my_method(&self) {
        println!("Hello, world!");
    }
}

pub fn my_func() {
    let _a = 1;
    let b =
        MyStruct {
            name: String::from("abc"),
            value: 123,
        };

    b.my_method();
}
