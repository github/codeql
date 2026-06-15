use std::fmt;

pub enum X {
    A,
    B,
}

pub struct X_List {
    x: X,
    tail: Option<Box<X_List>>,
}

pub fn length(list: X_List) -> usize {
    match list {
        X_List { x: _, tail: None } => 1,
        X_List {
            x: _,
            tail: Some(tail),
        } => 1 + length(*tail),
    }
}
pub trait AsString {
    fn as_string(&self) -> &str;
}

impl AsString for X {
    fn as_string(&self) -> &str {
        match self {
            X::A => "a",
            X::B => "b",
        }
    }
}

impl fmt::Display for X {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.as_string())
    }
}

pub const X_A: X = X::A;
pub static X_B: X = X::B;

pub use std::fs::create_dir as mkdir;
pub use std::{fs::*, path::PathBuf};

pub struct LocalKey<T: 'static> {
    inner: fn(Option<&mut Option<T>>) -> *const T,
}

pub struct Thing<T> {
    x: T,
}
impl From<usize> for Thing<X> {
    fn from(_x: usize) -> Self {
        Thing { x: X::A }
    }
}
