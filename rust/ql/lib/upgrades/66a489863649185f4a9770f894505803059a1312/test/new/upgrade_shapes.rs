#![allow(dead_code)]
#![feature(more_qualified_paths)]

#[path_meta]
#[key_value = 1]
#[token_tree(list)]
#[unsafe(path_meta)]
struct S {
    field: u8 = 1,
}

enum E {
    V = 2,
}

trait Alias<T> = Clone
where
    T: Copy;

fn f() {
    let _ = try { 1 };
    let _ = format_args!("{b} {a}", a = 1, b = 2);
}
