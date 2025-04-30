// This code below is adapted from the `Option` implementation in the Rust core library which is
// released under the MIT licenses with the following copyright notice:
//
//     Copyright (c) The Rust Project Contributors

use core::ops::{Deref, DerefMut};
use core::pin::Pin;
use core::ptr;
use core::{hint, mem};

// summary=repo::test;crate::option::replace;Argument[0].Reference;ReturnValue;value;dfc-generated
// summary=repo::test;crate::option::replace;Argument[1];Argument[0].Reference;value;dfc-generated
// sink=repo::test;crate::option::replace;Argument[0];pointer-access;df-generated
pub fn replace<T>(dest: &mut T, src: T) -> T {
    unsafe {
        let result = ptr::read(dest);
        ptr::write(dest, src);
        result
    }
}

#[derive(Copy, Eq, Debug, Hash)]
pub enum MyOption<T> {
    MyNone,
    MySome(T),
}

use MyOption::*;

// Type implementation

impl<T> MyOption<T> {
    pub fn is_some(&self) -> bool {
        matches!(*self, MySome(_))
    }

    // summary=repo::test;<crate::option::MyOption>::is_some_and;Argument[0].ReturnValue;ReturnValue;value;dfc-generated
    // summary=repo::test;<crate::option::MyOption>::is_some_and;Argument[self].Field[crate::option::MyOption::MySome(0)];Argument[0].Parameter[0];value;dfc-generated
    pub fn is_some_and(self, f: impl FnOnce(T) -> bool) -> bool {
        match self {
            MyNone => false,
            MySome(x) => f(x),
        }
    }

    pub fn is_none(&self) -> bool {
        !self.is_some()
    }

    // summary=repo::test;<crate::option::MyOption>::is_none_or;Argument[0].ReturnValue;ReturnValue;value;dfc-generated
    // summary=repo::test;<crate::option::MyOption>::is_none_or;Argument[self].Field[crate::option::MyOption::MySome(0)];Argument[0].Parameter[0];value;dfc-generated
    pub fn is_none_or(self, f: impl FnOnce(T) -> bool) -> bool {
        match self {
            MyNone => true,
            MySome(x) => f(x),
        }
    }

    // summary=repo::test;<crate::option::MyOption>::as_ref;Argument[self].Reference.Field[crate::option::MyOption::MySome(0)];ReturnValue.Field[crate::option::MyOption::MySome(0)].Reference;value;dfc-generated
    pub fn as_ref(&self) -> MyOption<&T> {
        match *self {
            MySome(ref x) => MySome(x),
            MyNone => MyNone,
        }
    }

    // summary=repo::test;<crate::option::MyOption>::as_mut;Argument[self].Reference.Field[crate::option::MyOption::MySome(0)];ReturnValue.Field[crate::option::MyOption::MySome(0)].Reference;value;dfc-generated
    pub fn as_mut(&mut self) -> MyOption<&mut T> {
        match *self {
            MySome(ref mut x) => MySome(x),
            MyNone => MyNone,
        }
    }

    // MISSING: Flow through `Pin`
    pub fn as_pin_ref(self: Pin<&Self>) -> MyOption<Pin<&T>> {
        // FIXME(const-hack): use `map` once that is possible
        match Pin::get_ref(self).as_ref() {
            // SAFETY: `x` is guaranteed to be pinned because it comes from `self`
            // which is pinned.
            MySome(x) => unsafe { MySome(Pin::new_unchecked(x)) },
            MyNone => MyNone,
        }
    }

    // MISSING: Flow through `Pin`
    pub fn as_pin_mut(self: Pin<&mut Self>) -> MyOption<Pin<&mut T>> {
        // SAFETY: `get_unchecked_mut` is never used to move the `MyOption` inside `self`.
        // `x` is guaranteed to be pinned because it comes from `self` which is pinned.
        unsafe {
            // FIXME(const-hack): use `map` once that is possible
            match Pin::get_unchecked_mut(self).as_mut() {
                MySome(x) => MySome(Pin::new_unchecked(x)),
                MyNone => MyNone,
            }
        }
    }

    // summary=repo::test;<crate::option::MyOption>::unwrap;Argument[self].Field[crate::option::MyOption::MySome(0)];ReturnValue;value;dfc-generated
    pub fn unwrap(self) -> T {
        match self {
            MySome(val) => val,
            MyNone => panic!("called `MyOption::unwrap()` on a `MyNone` value"),
        }
    }

    // summary=repo::test;<crate::option::MyOption>::unwrap_or;Argument[0];ReturnValue;value;dfc-generated
    // summary=repo::test;<crate::option::MyOption>::unwrap_or;Argument[self].Field[crate::option::MyOption::MySome(0)];ReturnValue;value;dfc-generated
    pub fn unwrap_or(self, default: T) -> T {
        match self {
            MySome(x) => x,
            MyNone => default,
        }
    }

    // summary=repo::test;<crate::option::MyOption>::unwrap_or_else;Argument[self].Field[crate::option::MyOption::MySome(0)];ReturnValue;value;dfc-generated
    // summary=repo::test;<crate::option::MyOption>::unwrap_or_else;Argument[0].ReturnValue;ReturnValue;value;dfc-generated
    pub fn unwrap_or_else<F>(self, f: F) -> T
    where
        F: FnOnce() -> T,
    {
        match self {
            MySome(x) => x,
            MyNone => f(),
        }
    }

    // summary=repo::test;<crate::option::MyOption>::unwrap_or_default;Argument[self].Field[crate::option::MyOption::MySome(0)];ReturnValue;value;dfc-generated
    pub fn unwrap_or_default(self) -> T
    where
        T: Default,
    {
        match self {
            MySome(x) => x,
            MyNone => T::default(),
        }
    }
    // summary=repo::test;<crate::option::MyOption>::unwrap_unchecked;Argument[self].Field[crate::option::MyOption::MySome(0)];ReturnValue;value;dfc-generated
    #[track_caller]
    pub unsafe fn unwrap_unchecked(self) -> T {
        match self {
            MySome(val) => val,
            // SAFETY: the safety contract must be upheld by the caller.
            MyNone => unsafe { hint::unreachable_unchecked() },
        }
    }

    // Transforming contained values

    // summary=repo::test;<crate::option::MyOption>::map;Argument[0].ReturnValue;ReturnValue.Field[crate::option::MyOption::MySome(0)];value;dfc-generated
    // summary=repo::test;<crate::option::MyOption>::map;Argument[self].Field[crate::option::MyOption::MySome(0)];Argument[0].Parameter[0];value;dfc-generated
    pub fn map<U, F>(self, f: F) -> MyOption<U>
    where
        F: FnOnce(T) -> U,
    {
        match self {
            MySome(x) => MySome(f(x)),
            MyNone => MyNone,
        }
    }

    // summary=repo::test;<crate::option::MyOption>::inspect;Argument[self];ReturnValue;value;dfc-generated
    // MISSING: Due to `ref` pattern.
    pub fn inspect<F: FnOnce(&T)>(self, f: F) -> Self {
        if let MySome(ref x) = self {
            f(x);
        }

        self
    }

    // summary=repo::test;<crate::option::MyOption>::map_or;Argument[0];ReturnValue;value;dfc-generated
    // summary=repo::test;<crate::option::MyOption>::map_or;Argument[1].ReturnValue;ReturnValue;value;dfc-generated
    // summary=repo::test;<crate::option::MyOption>::map_or;Argument[self].Field[crate::option::MyOption::MySome(0)];Argument[1].Parameter[0];value;dfc-generated
    pub fn map_or<U, F>(self, default: U, f: F) -> U
    where
        F: FnOnce(T) -> U,
    {
        match self {
            MySome(t) => f(t),
            MyNone => default,
        }
    }

    // summary=repo::test;<crate::option::MyOption>::map_or_else;Argument[0].ReturnValue;ReturnValue;value;dfc-generated
    // summary=repo::test;<crate::option::MyOption>::map_or_else;Argument[1].ReturnValue;ReturnValue;value;dfc-generated
    // summary=repo::test;<crate::option::MyOption>::map_or_else;Argument[self].Field[crate::option::MyOption::MySome(0)];Argument[1].Parameter[0];value;dfc-generated
    pub fn map_or_else<U, D, F>(self, default: D, f: F) -> U
    where
        D: FnOnce() -> U,
        F: FnOnce(T) -> U,
    {
        match self {
            MySome(t) => f(t),
            MyNone => default(),
        }
    }

    // summary=repo::test;<crate::option::MyOption>::ok_or;Argument[self].Field[crate::option::MyOption::MySome(0)];ReturnValue.Field[crate::result::Result::Ok(0)];value;dfc-generated
    // summary=repo::test;<crate::option::MyOption>::ok_or;Argument[0];ReturnValue.Field[crate::result::Result::Err(0)];value;dfc-generated
    pub fn ok_or<E>(self, err: E) -> Result<T, E> {
        match self {
            MySome(v) => Ok(v),
            MyNone => Err(err),
        }
    }

    // summary=repo::test;<crate::option::MyOption>::ok_or_else;Argument[self].Field[crate::option::MyOption::MySome(0)];ReturnValue.Field[crate::result::Result::Ok(0)];value;dfc-generated
    // summary=repo::test;<crate::option::MyOption>::ok_or_else;Argument[0].ReturnValue;ReturnValue.Field[crate::result::Result::Err(0)];value;dfc-generated
    pub fn ok_or_else<E, F>(self, err: F) -> Result<T, E>
    where
        F: FnOnce() -> E,
    {
        match self {
            MySome(v) => Ok(v),
            MyNone => Err(err()),
        }
    }

    // MISSING: `Deref` trait
    pub fn as_deref(&self) -> MyOption<&T::Target>
    where
        T: Deref,
    {
        self.as_ref().map(|t| t.deref())
    }

    // MISSING: `Deref` trait
    pub fn as_deref_mut(&mut self) -> MyOption<&mut T::Target>
    where
        T: DerefMut,
    {
        self.as_mut().map(|t| t.deref_mut())
    }

    // summary=repo::test;<crate::option::MyOption>::and;Argument[0];ReturnValue;value;dfc-generated
    pub fn and<U>(self, optb: MyOption<U>) -> MyOption<U> {
        match self {
            MySome(_) => optb,
            MyNone => MyNone,
        }
    }

    // summary=repo::test;<crate::option::MyOption>::and_then;Argument[0].ReturnValue;ReturnValue;value;dfc-generated
    // summary=repo::test;<crate::option::MyOption>::and_then;Argument[self].Field[crate::option::MyOption::MySome(0)];Argument[0].Parameter[0];value;dfc-generated
    pub fn and_then<U, F>(self, f: F) -> MyOption<U>
    where
        F: FnOnce(T) -> MyOption<U>,
    {
        match self {
            MySome(x) => f(x),
            MyNone => MyNone,
        }
    }

    // MISSING: Reference passed to predicate
    pub fn filter<P>(self, predicate: P) -> Self
    where
        P: FnOnce(&T) -> bool,
    {
        if let MySome(x) = self {
            if predicate(&x) {
                return MySome(x);
            }
        }
        MyNone
    }

    // summary=repo::test;<crate::option::MyOption>::or;Argument[0];ReturnValue;value;dfc-generated
    // summary=repo::test;<crate::option::MyOption>::or;Argument[self];ReturnValue;value;dfc-generated
    pub fn or(self, optb: MyOption<T>) -> MyOption<T> {
        match self {
            x @ MySome(_) => x,
            MyNone => optb,
        }
    }

    // summary=repo::test;<crate::option::MyOption>::or_else;Argument[self];ReturnValue;value;dfc-generated
    // summary=repo::test;<crate::option::MyOption>::or_else;Argument[0].ReturnValue;ReturnValue;value;dfc-generated
    pub fn or_else<F>(self, f: F) -> MyOption<T>
    where
        F: FnOnce() -> MyOption<T>,
    {
        match self {
            x @ MySome(_) => x,
            MyNone => f(),
        }
    }

    // summary=repo::test;<crate::option::MyOption>::xor;Argument[0];ReturnValue;value;dfc-generated
    // summary=repo::test;<crate::option::MyOption>::xor;Argument[self];ReturnValue;value;dfc-generated
    pub fn xor(self, optb: MyOption<T>) -> MyOption<T> {
        match (self, optb) {
            (a @ MySome(_), MyNone) => a,
            (MyNone, b @ MySome(_)) => b,
            _ => MyNone,
        }
    }

    // summary=repo::test;<crate::option::MyOption>::insert;Argument[0];Argument[self].Reference.Field[crate::option::MyOption::MySome(0)];value;dfc-generated
    // summary=repo::test;<crate::option::MyOption>::insert;Argument[0];ReturnValue.Reference;value;dfc-generated
    // The content of `self` is overwritten so it does not flow to the return value.
    // SPURIOUS-summary=repo::test;<crate::option::MyOption>::insert;Argument[self].Reference.Field[crate::option::MyOption::MySome(0)];ReturnValue.Reference;value;dfc-generated
    pub fn insert(&mut self, value: T) -> &mut T {
        *self = MySome(value);

        // SAFETY: the code above just filled the MyOption
        unsafe { self.as_mut().unwrap_unchecked() }
    }

    // summary=repo::test;<crate::option::MyOption>::get_or_insert;Argument[0];Argument[self].Reference.Field[crate::option::MyOption::MySome(0)];value;dfc-generated
    // summary=repo::test;<crate::option::MyOption>::get_or_insert;Argument[0];ReturnValue.Reference;value;dfc-generated
    // summary=repo::test;<crate::option::MyOption>::get_or_insert;Argument[self].Reference.Field[crate::option::MyOption::MySome(0)];ReturnValue.Reference;value;dfc-generated
    pub fn get_or_insert(&mut self, value: T) -> &mut T {
        self.get_or_insert_with(|| value)
    }

    // summary=repo::test;<crate::option::MyOption>::get_or_insert_default;Argument[self].Reference.Field[crate::option::MyOption::MySome(0)];ReturnValue.Reference;value;dfc-generated
    pub fn get_or_insert_default(&mut self) -> &mut T
    where
        T: Default,
    {
        self.get_or_insert_with(T::default)
    }

    // summary=repo::test;<crate::option::MyOption>::get_or_insert_with;Argument[self].Reference.Field[crate::option::MyOption::MySome(0)];ReturnValue.Reference;value;dfc-generated
    // MISSING: Mutating `self` parameter.
    pub fn get_or_insert_with<F>(&mut self, f: F) -> &mut T
    where
        F: FnOnce() -> T,
    {
        if let MyNone = self {
            *self = MySome(f());
        }

        // SAFETY: a `MyNone` variant for `self` would have been replaced by a `MySome`
        // variant in the code above.
        unsafe { self.as_mut().unwrap_unchecked() }
    }

    // summary=repo::test;<crate::option::MyOption>::take;Argument[self].Reference;ReturnValue;value;dfc-generated
    // sink=repo::test;<crate::option::MyOption>::take;Argument[self];pointer-access;df-generated
    pub fn take(&mut self) -> MyOption<T> {
        // FIXME(const-hack) replace `mem::replace` by `mem::take` when the latter is const ready
        replace(self, MyNone)
    }

    // summary=repo::test;<crate::option::MyOption>::take_if;Argument[self].Reference.Field[crate::option::MyOption::MySome(0)];Argument[0].Parameter[0].Reference;value;dfc-generated
    // summary=repo::test;<crate::option::MyOption>::take_if;Argument[self].Reference;ReturnValue;value;dfc-generated
    // sink=repo::test;<crate::option::MyOption>::take_if;Argument[self];pointer-access;df-generated
    pub fn take_if<P>(&mut self, predicate: P) -> MyOption<T>
    where
        P: FnOnce(&mut T) -> bool,
    {
        if self.as_mut().map_or(false, predicate) {
            self.take()
        } else {
            MyNone
        }
    }

    // summary=repo::test;<crate::option::MyOption>::replace;Argument[0];Argument[self].Reference.Field[crate::option::MyOption::MySome(0)];value;dfc-generated
    // summary=repo::test;<crate::option::MyOption>::replace;Argument[self].Reference;ReturnValue;value;dfc-generated
    // sink=repo::test;<crate::option::MyOption>::replace;Argument[self];pointer-access;df-generated
    pub fn replace(&mut self, value: T) -> MyOption<T> {
        replace(self, MySome(value))
    }

    // summary=repo::test;<crate::option::MyOption>::zip;Argument[0].Field[crate::option::MyOption::MySome(0)];ReturnValue.Field[crate::option::MyOption::MySome(0)].Field[1];value;dfc-generated
    // summary=repo::test;<crate::option::MyOption>::zip;Argument[self].Field[crate::option::MyOption::MySome(0)];ReturnValue.Field[crate::option::MyOption::MySome(0)].Field[0];value;dfc-generated
    pub fn zip<U>(self, other: MyOption<U>) -> MyOption<(T, U)> {
        match (self, other) {
            (MySome(a), MySome(b)) => MySome((a, b)),
            _ => MyNone,
        }
    }

    // summary=repo::test;<crate::option::MyOption>::zip_with;Argument[self].Field[crate::option::MyOption::MySome(0)];Argument[1].Parameter[0];value;dfc-generated
    // summary=repo::test;<crate::option::MyOption>::zip_with;Argument[0].Field[crate::option::MyOption::MySome(0)];Argument[1].Parameter[1];value;dfc-generated
    // summary=repo::test;<crate::option::MyOption>::zip_with;Argument[1].ReturnValue;ReturnValue.Field[crate::option::MyOption::MySome(0)];value;dfc-generated
    pub fn zip_with<U, F, R>(self, other: MyOption<U>, f: F) -> MyOption<R>
    where
        F: FnOnce(T, U) -> R,
    {
        match (self, other) {
            (MySome(a), MySome(b)) => MySome(f(a, b)),
            _ => MyNone,
        }
    }
}

impl<T, U> MyOption<(T, U)> {
    // summary=repo::test;<crate::option::MyOption>::unzip;Argument[self].Field[crate::option::MyOption::MySome(0)].Field[0];ReturnValue.Field[0].Field[crate::option::MyOption::MySome(0)];value;dfc-generated
    // summary=repo::test;<crate::option::MyOption>::unzip;Argument[self].Field[crate::option::MyOption::MySome(0)].Field[1];ReturnValue.Field[1].Field[crate::option::MyOption::MySome(0)];value;dfc-generated
    pub fn unzip(self) -> (MyOption<T>, MyOption<U>) {
        match self {
            MySome((a, b)) => (MySome(a), MySome(b)),
            MyNone => (MyNone, MyNone),
        }
    }
}

impl<T> MyOption<&T> {
    // summary=repo::test;<crate::option::MyOption>::copied;Argument[self].Field[crate::option::MyOption::MySome(0)].Reference;ReturnValue.Field[crate::option::MyOption::MySome(0)];value;dfc-generated
    pub fn copied(self) -> MyOption<T>
    where
        T: Copy,
    {
        // FIXME(const-hack): this implementation, which sidesteps using `MyOption::map` since it's not const
        // ready yet, should be reverted when possible to avoid code repetition
        match self {
            MySome(&v) => MySome(v),
            MyNone => MyNone,
        }
    }

    // summary=repo::test;<crate::option::MyOption>::cloned;Argument[self].Field[crate::option::MyOption::MySome(0)];ReturnValue.Field[crate::option::MyOption::MySome(0)];value;dfc-generated
    pub fn cloned(self) -> MyOption<T>
    where
        T: Clone,
    {
        match self {
            MySome(t) => MySome(t.clone()),
            MyNone => MyNone,
        }
    }
}

impl<T> MyOption<&mut T> {
    // summary=repo::test;<crate::option::MyOption>::copied;Argument[self].Field[crate::option::MyOption::MySome(0)].Reference;ReturnValue.Field[crate::option::MyOption::MySome(0)];value;dfc-generated
    pub fn copied(self) -> MyOption<T>
    where
        T: Copy,
    {
        match self {
            MySome(&mut t) => MySome(t),
            MyNone => MyNone,
        }
    }

    // summary=repo::test;<crate::option::MyOption>::cloned;Argument[self].Field[crate::option::MyOption::MySome(0)];ReturnValue.Field[crate::option::MyOption::MySome(0)];value;dfc-generated
    pub fn cloned(self) -> MyOption<T>
    where
        T: Clone,
    {
        match self {
            MySome(t) => MySome(t.clone()),
            MyNone => MyNone,
        }
    }
}

impl<T, E> MyOption<Result<T, E>> {
    // summary=repo::test;<crate::option::MyOption>::transpose;Argument[self].Field[crate::option::MyOption::MySome(0)].Field[crate::result::Result::Err(0)];ReturnValue.Field[crate::result::Result::Err(0)];value;dfc-generated
    // summary=repo::test;<crate::option::MyOption>::transpose;Argument[self].Field[crate::option::MyOption::MySome(0)].Field[crate::result::Result::Ok(0)];ReturnValue.Field[crate::result::Result::Ok(0)].Field[crate::option::MyOption::MySome(0)];value;dfc-generated
    pub fn transpose(self) -> Result<MyOption<T>, E> {
        match self {
            MySome(Ok(x)) => Ok(MySome(x)),
            MySome(Err(e)) => Err(e),
            MyNone => Ok(MyNone),
        }
    }
}

impl<T> Clone for MyOption<T>
where
    T: Clone,
{
    // summary=repo::test;<crate::option::MyOption as crate::clone::Clone>::clone;Argument[self].Field[crate::option::MyOption::MySome(0)];ReturnValue.Field[crate::option::MyOption::MySome(0)];value;dfc-generated
    fn clone(&self) -> Self {
        match self {
            MySome(x) => MySome(x.clone()),
            MyNone => MyNone,
        }
    }

    // MISSING: Flow through `clone_from` trait method which is not modeled.
    fn clone_from(&mut self, source: &Self) {
        match (self, source) {
            (MySome(to), MySome(from)) => to.clone_from(from),
            (to, from) => *to = from.clone(),
        }
    }
}

impl<T> Default for MyOption<T> {
    fn default() -> MyOption<T> {
        MyNone
    }
}

impl<T> From<T> for MyOption<T> {
    // summary=repo::test;<crate::option::MyOption as crate::convert::From>::from;Argument[0];ReturnValue.Field[crate::option::MyOption::MySome(0)];value;dfc-generated
    fn from(val: T) -> MyOption<T> {
        MySome(val)
    }
}

impl<'a, T> From<&'a MyOption<T>> for MyOption<&'a T> {
    // summary=repo::test;<crate::option::MyOption as crate::convert::From>::from;Argument[0].Reference.Field[crate::option::MyOption::MySome(0)];ReturnValue.Field[crate::option::MyOption::MySome(0)].Reference;value;dfc-generated
    fn from(o: &'a MyOption<T>) -> MyOption<&'a T> {
        o.as_ref()
    }
}

impl<'a, T> From<&'a mut MyOption<T>> for MyOption<&'a mut T> {
    // summary=repo::test;<crate::option::MyOption as crate::convert::From>::from;Argument[0].Reference.Field[crate::option::MyOption::MySome(0)];ReturnValue.Field[crate::option::MyOption::MySome(0)].Reference;value;dfc-generated
    fn from(o: &'a mut MyOption<T>) -> MyOption<&'a mut T> {
        o.as_mut()
    }
}

impl<T: PartialEq> PartialEq for MyOption<T> {
    fn eq(&self, other: &Self) -> bool {
        // Spelling out the cases explicitly optimizes better than
        // `_ => false`
        match (self, other) {
            (MySome(l), MySome(r)) => *l == *r,
            (MySome(_), MyNone) => false,
            (MyNone, MySome(_)) => false,
            (MyNone, MyNone) => true,
        }
    }
}

impl<T> MyOption<MyOption<T>> {
    // summary=repo::test;<crate::option::MyOption>::flatten;Argument[self].Field[crate::option::MyOption::MySome(0)];ReturnValue;value;dfc-generated
    pub fn flatten(self) -> MyOption<T> {
        // FIXME(const-hack): could be written with `and_then`
        match self {
            MySome(inner) => inner,
            MyNone => MyNone,
        }
    }
}
