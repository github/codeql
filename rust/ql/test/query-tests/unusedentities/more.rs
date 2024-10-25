// --- generics ---

trait MySettable<T> {
    fn set(&mut self, val: T);
}

trait MyGettable<T> {
    fn get(&self, val: T) -> &T;
}

struct MyContainer<T> {
    val: T
}

impl<T> MySettable<T> for MyContainer<T> {
    fn set(&mut self, val: T) {
        self.val = val;
    }
}

impl<T> MyGettable<T> for MyContainer<T> {
    fn get(
        &self,
        val: T // BAD: unused variable [NOT DETECTED] SPURIOUS: unused value
    ) -> &T {
        return &(self.val);
    }
}

fn generics() {
    let mut a = MyContainer { val: 1 }; // BAD: unused value [NOT DETECTED]
    let b = MyContainer { val: 2 };

    a.set(
        *b.get(3)
    );
}

// --- pointers ---

fn pointers() {
    let a = 1;
    let a_ptr1 = &a;
    let a_ptr2 = &a;
    let a_ptr3 = &a; // BAD: unused value [NOT DETECTED]
    let a_ptr4 = &a; // BAD: unused value
    println!("{}", *a_ptr1);
    println!("{}", a_ptr2);
    println!("{}", &a_ptr3);

    let b = 2; // BAD: unused value [NOT DETECTED]
    let b_ptr = &b;
    println!("{}", b_ptr);

    let c = 3;
    let c_ptr = &c;
    let c_ptr_ptr = &c_ptr;
    println!("{}", **c_ptr_ptr);

    let d = 4;
    let d_ptr = &d; // BAD: unused value
    let d_ptr_ptr = &&d;
    println!("{}", **d_ptr_ptr);

    let e = 5; // BAD: unused value [NOT DETECTED]
    let f = 6;
    let mut f_ptr = &e; // BAD: unused value
    f_ptr = &f;
    println!("{}", *f_ptr);

    let mut g = 7; // BAD: unused value [NOT DETECTED]
    let g_ptr = &mut g;
    *g_ptr = 77; // BAD: unused value [NOT DETECTED]

    let mut h = 8; // BAD: unused value [NOT DETECTED]
    let h_ptr = &mut h;
    *h_ptr = 88;
    println!("{}", h);

    let mut i = 9; // BAD: unused value [NOT DETECTED]
    let i_ptr = &mut i;
    *i_ptr = 99;
    let i_ptr2 = &mut i;
    println!("{}", *i_ptr2);
}
