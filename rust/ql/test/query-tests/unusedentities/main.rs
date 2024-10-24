//fn cond() -> bool;

// --- locals ---

fn locals_1() {
    let a = 1; // BAD: unused value
    let b = 1;
    let c = 1;
    let d = String::from("a"); // BAD: unused value
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

    b = 1; // BAD: unused value

    c = 1; // BAD: unused value
    c = 2;
    println!("use {}", c);
    c = 3; // BAD: unused value

    d = 1;
    if cond() {
        d = 2; // BAD: unused value
        d = 3;
    } else {
    }
    println!("use {}", d);

    e = 1; // BAD: unused value
    if cond() {
        e = 2;
    } else {
        e = 3;
    }
    println!("use {}", e);

    f = 1;
    f += 1;
    println!("use {}", f);
    f += 1; // BAD: unused value
    f = 1;
    f += 1; // BAD: unused value

    g = if cond() { 1 } else { 2 }; // BAD: unused value
    h = if cond() { 3 } else { 4 };
    i = if cond() { h } else { 5 };
    println!("use {}", i);

    _ = 1; // GOOD (deliberately unused)
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
    let a = MyStruct { val: 1 }; // BAD: unused value
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
    let is = [1, 2, 3]; // BAD: unused value
    let js = [1, 2, 3];
    let ks = [1, 2, 3];

    println!("lets use {:?}", js);

    for k
	in ks
	{
        println!("lets use {}", k); // [unreachable FALSE POSITIVE]
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
        let total = CON1 + STAT1 + STAT3; // BAD: unused value
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

fn id(v: i32) -> i32 {
    return v;
}

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

    for x
    in 1..10 {
        println!("x is {}", x);
    }

    for x
    in 1..10 {
        println!("x is {:?}", x);
    }

    for x
    in 1..10 {
        println!("x + 1 is {}", x + 1);
    }

    for x
    in 1..10 {
        for y
        in 1..x {
            println!("y is {}", y);
        }
    }

    for x
    in 1..10 {
        println!("x is {x}");
    }

    for x
    in 1..10 {
        _ = format!("x is {x}"); // SPURIOUS: unused value `res`
    }

    for x
    in 1..10 {
        println!("x is {val}", val = x);
    }

    for x
    in 1..10 {
        assert!(x != 11);
    }

    for x
    in 1..10 {
        assert_eq!(x, 1); // SPURIOUS: unused value `kind`
    }

    for x
    in 1..10 {
        assert_eq!(id(x), id(1)); // SPURIOUS: unused value `kind`
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

use YesOrNo::{Yes, No}; // allows `Yes`, `No` to be accessed without qualifiers.

struct MyPoint {
    x: i64,
    y: i64,
}

fn if_lets_matches() {
    let mut total: i64 = 0;

    if let Some(a) = Some(10) { // BAD: unused variable
    }

    if let Some(b) = Some(20) {
        total += b;
    }

    let mut next = Some(30);
    while let Some(val) = // BAD: unused variable
        next
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
        None => {}
    }

    let d = Some(70);
    match d {
        Some(val) => {
            total += val; // BAD: unused value
        }
        None => {}
    }

    let e = Option::Some(80);
    match e {
        Option::Some(val) => { // BAD: unused variable
        }
        Option::None => {}
    }

    let f = MyOption::Some(90);
    match f {
        MyOption::Some(val) => { // BAD: unused variable
        }
        MyOption::None => {}
    }

    let g: Result<i64, i64> = Ok(100);
    match g {
        Ok(_) => {}
        Err(num) => {} // BAD: unused variable
    }

    let h = YesOrNo::Yes;
    match h {
        YesOrNo::Yes => {}
        YesOrNo::No => {}
    }

    let i = Yes;
    match i {
        Yes => {}
        No => {}
    }

    if let j = Yes { // BAD: unused variable
    }

    if let k = Yes {
        match k {
            _ => {}
        }
    }

    let l = Yes;
    if let Yes = l {}

    match 1 {
        1 => {}
        _ => {}
    }

    let p1 = MyPoint { x: 1, y: 2 };
    match p1 {
        MyPoint { x: 0, y: 0 } => {}
        MyPoint { x: 1, y } => { // BAD: unused variable
        }
        MyPoint { x: 2, y: _ } => {}
        MyPoint { x: 3, y: a } => { // BAD: unused variable
        }
        MyPoint { x: 4, .. } => {}
        p => { // BAD: unused variable
        }
    }

    let duration1 = std::time::Duration::new(10, 0); // ten seconds
    assert_eq!(duration1.as_secs(), 10); // SPURIOUS: unused value `kind`

    let duration2:Result<std::time::Duration, String> =
        Ok(std::time::Duration::new(10, 0));
    match duration2 {
        Ok(n) => { println!("duration was {} seconds", n.as_secs()); }
        Err(_) => { println!("failed"); }
    }

    let (left,
        right) = // BAD: unused value [NOT DETECTED] SPURIOUS: unused variable
        (1, 2);
    _ = left;

    let pair = (1, 2);
    let (left2,
        right2) = // BAD: unused value [NOT DETECTED] SPURIOUS: unused variable
        pair;
    _ = left2;
}

fn shadowing() -> i32 {
    let x = 1; // BAD: unused value
    let mut y: i32; // BAD: unused variable

    {
        let x = 2;
        let mut y: i32;

        {
            let x = 3; // BAD: unused value
            let mut y: i32; // BAD: unused variable
        }

        y = x;
        return y;
    }
}

// --- function pointers ---

type FuncPtr = fn(i32) -> i32;

fn increment(x: i32) -> i32 {
    return x + 1;
}

fn func_ptrs() {
    let my_func: FuncPtr = increment;

    for x
    in 1..10 {
        _ = x + 1;
    }

    for x
    in 1..10 {
        _ = increment(x);
    }

    for x
    in 1..10 {
        _ = my_func(x);
    }
}

// --- folds and closures ---

fn folds_and_closures() {
    let a1 = 1..10;
    _ = a1.sum::<i32>();

    let a2 = 1..10;
    _ = a2.fold(0, | acc: i32, val: i32 | -> i32 { acc + val } );

    let a3 = 1..10;
    _ = a3.fold(0, | acc, val | acc + val);

    let a4 = 1..10;
    _ = a4.fold(0, | acc, val | acc); // BAD: unused variable

    let a5 = 1..10;
    _ = a5.fold(0, | acc, val | val); // BAD: unused variable

    let i6 = 1; // SPURIOUS: unused value
    let a6 = 1..10;
    _ = a6.fold(0, | acc, val | acc + val + i6);
}

// --- main ---

fn main() {
    locals_1();
    locals_2();
    structs();
    arrays();
    statics();
    println!("lets use result {}", parameters(1, 2, 3));
    loops();
    if_lets_matches();
    shadowing();
    func_ptrs();
    folds_and_closures();

    unreachable_if_1();
    unreachable_panic();
    unreachable_match();
    unreachable_loop();
    unreachable_paren();
    unreachable_let_1();
    unreachable_let_2();
    unreachable_if_2();
    unreachable_if_3();

}
