// --- generics ---

trait MySettable<T> {
    fn set(&mut self, val: T);
}

trait MyGettable<T> {
    fn get(&self, val: T) -> &T;
}

struct MyContainer<T> {
    val: T,
}

impl<T> MySettable<T> for MyContainer<T> {
    fn set(&mut self, val: T) {
        self.val = val;
    }
}

impl<T> MyGettable<T> for MyContainer<T> {
    fn get(
        &self,
        val: T, // $ Alert[rust/unused-variable]
    ) -> &T {
        return &(self.val);
    }
}

pub fn generics() {
    let mut a = MyContainer { val: 1 }; // $ MISSING: Alert[rust/unused-value]
    let b = MyContainer { val: 2 };

    a.set(*b.get(3));
}

// --- pointers ---

pub fn pointers() {
    let a = 1;
    let a_ptr1 = &a;
    let a_ptr2 = &a;
    let a_ptr3 = &a; // $ MISSING: Alert[rust/unused-value]
    let a_ptr4 = &a; // $ Alert[rust/unused-value]
    println!("{}", *a_ptr1);
    println!("{}", a_ptr2);
    println!("{}", &a_ptr3);

    let b = 2; // $ MISSING: Alert[rust/unused-value]
    let b_ptr = &b;
    println!("{}", b_ptr);

    let c = 3;
    let c_ptr = &c;
    let c_ptr_ptr = &c_ptr;
    println!("{}", **c_ptr_ptr);

    let d = 4;
    let d_ptr = &d; // $ Alert[rust/unused-value]
    let d_ptr_ptr = &&d;
    println!("{}", **d_ptr_ptr);

    let e = 5; // $ MISSING: Alert[rust/unused-value]
    let f = 6;
    let mut f_ptr = &e; // $ Alert[rust/unused-value]
    f_ptr = &f;
    println!("{}", *f_ptr);

    let mut g = 7; // $ MISSING: Alert[rust/unused-value]
    let g_ptr = &mut g;
    *g_ptr = 77; // $ MISSING: Alert[rust/unused-value]

    let mut h = 8; // $ MISSING: Alert[rust/unused-value]
    let h_ptr = &mut h;
    *h_ptr = 88;
    println!("{}", h);

    let mut i = 9; // $ MISSING: Alert[rust/unused-value]
    let i_ptr = &mut i;
    *i_ptr = 99;
    let i_ptr2 = &mut i;
    println!("{}", *i_ptr2);
}
