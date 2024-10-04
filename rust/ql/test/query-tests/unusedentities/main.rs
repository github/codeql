//fn cond() -> bool;

// --- locals ---

fn locals_1() {
    let a = 1; // BAD: unused value [NOT DETECTED]
    let b = 1;
    let c = 1;
    let d = String::from("a"); // BAD: unused value [NOT DETECTED]
    let e = String::from("b");
    let f = 1;
    let _ = 1; // (deliberately unused)

    println!("use {}", b);

    if cond() {
        println!("use {}", c);
    }

    println!("use {}", e);
    assert!(f == 1);
}

fn locals_2() {
    let a: i32; // BAD: unused variable
    let b: i32;
    let mut c: i32;
    let mut d: i32;
    let mut e: i32;
    let mut f: i32;
    let g: i32;
    let h: i32;
    let i: i32;

    b = 1; // BAD: unused value [NOT DETECTED]

    c = 1; // BAD: unused value [NOT DETECTED]
    c = 2;
    println!("use {}", c);
    c = 3; // BAD: unused value [NOT DETECTED]

    d = 1;
    if cond() {
        d = 2; // BAD: unused value [NOT DETECTED]
        d = 3;
    } else {
    }
    println!("use {}", d);

    e = 1; // BAD: unused value [NOT DETECTED]
    if cond() {
        e = 2;
    } else {
        e = 3;
    }
    println!("use {}", e);

    f = 1;
    f += 1;
    println!("use {}", f);
    f += 1; // BAD: unused value [NOT DETECTED]
    f = 1;
    f += 1; // BAD: unused value [NOT DETECTED]

    g = if cond() { 1 } else { 2 }; // BAD: unused value (x2) [NOT DETECTED]
    h = if cond() { 3 } else { 4 };
    i = if cond() { h } else { 5 };
    println!("use {}", i);

    _ = 1; // (deliberately unused) [NOT DETECTED]
}

// --- structs ---

#[derive(Debug)]
struct MyStruct {
    val: i64,
}

impl MyStruct {
    fn my_get(&mut self) -> i64 {
        return self.val;
    }
}

fn structs() {
    let a = MyStruct { val: 1 }; // BAD: unused value [NOT DETECTED]
    let b = MyStruct { val: 2 };
    let c = MyStruct { val: 3 };
    let mut d: MyStruct; // BAD: unused variable
    let mut e: MyStruct;
    let mut f: MyStruct;

    println!("lets use {:?} and {}", b, c.val);

    e = MyStruct { val: 4 };
    println!("lets use {}", e.my_get());
    e.val = 5;
    println!("lets use {}", e.my_get());

    f = MyStruct { val: 6 }; // BAD: unused value [NOT DETECTED]
    f.val = 7; // BAD: unused value [NOT DETECTED]
}

// --- arrays ---

fn arrays() {
    let is = [1, 2, 3]; // BAD: unused values (x3) [NOT DETECTED]
    let js = [1, 2, 3];
    let ks = [1, 2, 3];

    println!("lets use {:?}", js);

    for k // SPURIOUS: unused variable [macros not yet supported]
	in ks
	{
        println!("lets use {}", k);
    }
}

// --- constants and statics ---

const CON1: i32 = 1;
const CON2: i32 = 2; // BAD: unused value [NOT DETECTED]
static mut STAT1: i32 = 1;
static mut STAT2: i32 = 2; // BAD: unused value [NOT DETECTED]

fn statics() {
    static mut STAT3: i32 = 0;
    static mut STAT4: i32 = 0; // BAD: unused value [NOT DETECTED]

    unsafe {
        let total = CON1 + STAT1 + STAT3;
    }
}

// --- parameters ---

fn parameters(
    x: i32,
    y: i32,  // BAD: unused variable
    _z: i32, // (`_` is asking the compiler, and by extension us, to not warn that this is unused)
) -> i32 {
    return x;
}

// --- loops ---

fn loops() {
    let mut a: i64 = 10;
    let b: i64 = 20;
    let c: i64 = 30;
    let d: i64 = 40;
    let mut e: i64 = 50;

    while a < b {
        a += 1;
    }

    for x in c..d {
        e += x;
    }

    for x in 1..10 { // BAD: unused variable
    }

    for _ in 1..10 {}

    for x // SPURIOUS: unused variable [macros not yet supported]
    in 1..10 {    
        println!("x is {}", x);
    }

    for x // SPURIOUS: unused variable [macros not yet supported]
    in 1..10 {   
        assert!(x != 11);
    }
}

// --- lets ---

enum MyOption<T> {
    None,
    Some(T),
}

enum YesOrNo {
    Yes,
    No,
}

fn if_lets() {
    let mut total: i64 = 0;

    if let Some(a) = Some(10) { // BAD: unused variable
    }

    if let Some(b) = Some(20) {
        total += b;
    }

    let mut next = Some(30);
    while let Some(val) = next // BAD: unused variable
    {
        next = None;
    }

    let mut next2 = Some(40);
    while let Some(val) = next2 {
        total += val;
        next2 = None;
    }

    let c = Some(60);
    match c {
        Some(val) => { // BAD: unused variable
        }
        None => { // SPURIOUS: unused variable 'None'
        }
    }

    let d = Some(70);
    match d {
        Some(val) => {
            total += val;
        }
        None => { // SPURIOUS: unused variable 'None'
        }
    }

    let e = MyOption::Some(80);
    match e {
        MyOption::Some(val) => { // BAD: unused variable
        }
        MyOption::None => {}
    }

    let f = YesOrNo::Yes;
    match f {
        YesOrNo::Yes => {}
        YesOrNo::No => {}
    }
}

fn main() {
    locals_1();
    locals_2();
    structs();
    arrays();
    statics();
    loops();
    if_lets();

    println!("lets use result {}", parameters(1, 2, 3));
}
