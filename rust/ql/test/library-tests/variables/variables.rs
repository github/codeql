fn print_str(s: &str) {
    println!("{}", s);
}

fn print_i64(i: i64) {
    println!("{}", i);
}

fn immutable_variable() {
    let x1 = "a"; // x1
    print_str(x1); // $ access=x1
}

fn mutable_variable() {
    let mut x2 = 4; // x2
    print_i64(x2); // $ access=x2
    x2 = 5; // $ access=x2
    print_i64(x2); // $ access=x2
}

fn variable_shadow1() {
    let x3 = 1; // x3_1
    print_i64(x3); // $ access=x3_1
    let x3 = // x3_2
        x3 + 1; // $ access=x3_1
    print_i64(x3); // $ access=x3_2
}

fn variable_shadow2() {
    let x4 = "a"; // x4_1
    print_str(x4); // $ access=x4_1
    {
        let x4 = "b"; // x4_2
        print_str(x4); // $ access=x4_2
    }
    print_str(x4); // $ access=x4_1
}

struct Point<'a> {
    x: &'a str,
    y: &'a str,
}

fn let_pattern1() {
    let (
        (
            a1, // a1
            b1, // b1
        ),
        Point {
            x, // x
            y, // y
        },
    ) = (("a", "b"), Point { x: "x", y: "y" });
    print_str(a1); // $ access=a1
    print_str(b1); // $ access=b1
    print_str(x); // $ access=x
    print_str(y); // $ access=y
}

fn let_pattern2() {
    let p1 = Point { x: "a", y: "b" }; // p1
    let Point {
        x: a2, // a2
        y: b2, // b2
    } = p1; // $ access=p1
    print_str(a2); // $ access=a2
    print_str(b2); // $ access=b2
}

fn let_pattern3() {
    let s1 = Some(String::from("Hello!")); // s1

    if let Some(ref s2) // s2
        = s1 { // $ access=s1
        print_str(s2); // $ access=s2
    }
}

fn let_pattern4() {
    let Some(x5): Option<&str> = Some("x5") else {
        // x5
        todo!()
    };
    print_str(x5); // $ access=x5
}

fn let_pattern5() {
    let s1 = Some(String::from("Hello!")); // s1

    while let Some(ref s2) // s2
        = s1 { // $ access=s1
        print_str(s2); // $ access=s2
    }
}

fn match_pattern1() {
    let x6 = Some(5); // x6
    let y1 = 10; // y1_1

    match x6 { // $ access=x6
        Some(50) => print_str("Got 50"),
        Some(y1) // y1_2
        =>
        {
            print_i64(y1)// $ access=y1_2
        } 
        None => print_str("NONE"),
    }

    print_i64(y1); // $ access=y1_1
}

fn match_pattern2() {
    let numbers = (2, 4, 8, 16, 32); // numbers

    match numbers { // $ access=numbers
        (
            first, _, // first
            third, _, // third
            fifth // fifth
        ) => {
            print_i64(first); // $ access=first
            print_i64(third); // $ access=third
            print_i64(fifth); // $ access=fifth
        }
    }

    match numbers { // $ access=numbers
        (
            first, // first
            ..,
            last // last
        ) => {
            print_i64(first); // $ access=first
            print_i64(last); // $ access=last
        }
    }
}

fn match_pattern3() {
    let p2 = Point { x: "x", y: "y" }; // p2

    match p2 { // $ access=p2
        Point {
            x: x7, .. // x7
        } => print_str(x7), // $ access=x7
    }
}

enum Message {
    Hello { id: i64 },
}

fn match_pattern4() {
    let msg = Message::Hello { id: 0 }; // msg

    match msg { // $ access=msg
        Message::Hello {
            id: id_variable @ 3..=7, // id_variable
        } => print_i64(id_variable), // $ access=id_variable
        Message::Hello { id: 10..=12 } => {
            println!("Found an id in another range")
        }
        Message::Hello { id } => // id
            print_i64(id), // $ access=id
    }
}

enum Either {
    Left(i64),
    Right(i64),
}

fn match_pattern5() {
    let either = Either::Left(32); // either
    match either { // $ access=either
        Either::Left(a3) | Either::Right(a3) // a3
            => print_i64(a3), // $ access=a3
    }
}

enum ThreeValued {
    First(i64),
    Second(i64),
    Third(i64),
}

fn match_pattern6() {
    let tv = ThreeValued::Second(62); // tv
    match tv { // $ access=tv
        ThreeValued::First(a4) | ThreeValued::Second(a4) | ThreeValued::Third(a4) // a4
            => print_i64(a4), // $ access=a4
    }
    match tv { // $ access=tv
        (ThreeValued::First(a5) | ThreeValued::Second(a5)) | ThreeValued::Third(a5) // a5
            => print_i64(a5), // $ access=a5
    }
    match tv { // $ access=tv
        ThreeValued::First(a6) | (ThreeValued::Second(a6) | ThreeValued::Third(a6)) // a6
            => print_i64(a6), // $ access=a6
    }
}

fn match_pattern7() {
    let either = Either::Left(32); // either
    match either { // $ access=either
        Either::Left(a7) | Either::Right(a7) // a7
            if a7 > 0 // $ access=a7
            => print_i64(a7), // $ access=a7
        _ => (),
    }
}

fn match_pattern8() {
    let either = Either::Left(32); // either

    match either { // $ access=either
        ref e @ // e
            (Either::Left(a11) | Either::Right(a11)) // a11
        => {
            print_i64(a11); // $ access=a11
            if let Either::Left(a12) // a12
            = e { // $ access=e
                print_i64(*a12); // $ access=a12
            }
        }
        _ => (),
    }
}

enum FourValued {
    First(i64),
    Second(i64),
    Third(i64),
    Fourth(i64),
}

fn match_pattern9() {
    let fv = FourValued::Second(62); // tv
    match fv { // $ access=tv
        FourValued::First(a13) | (FourValued::Second(a13) | FourValued::Third(a13)) | FourValued::Fourth(a13) // a13
            => print_i64(a13), // $ access=a13
    }
}

fn param_pattern1(
    a8: &str, // a8
    (
        b3, // b3
        c1, // c1
    ): (&str, &str)) -> () {
    print_str(a8); // $ access=a8
    print_str(b3); // $ access=b3
    print_str(c1); // $ access=c1
}

fn param_pattern2(
    (Either::Left(a9) | Either::Right(a9)): Either // a9
) -> () {
    print_i64(a9); // $ access=a9
}

fn destruct_assignment() {
    let (
        mut a10, // a10
        mut b4, // b4
        mut c2 // c2
    ) = (1, 2, 3);
    print_i64(a10); // $ access=a10
    print_i64(b4); // $ access=b4
    print_i64(c2); // $ access=c2

    (
        c2, // $ access=c2
        b4, // $ access=b4
        a10 // $ access=a10
    ) = (
        a10, // $ access=a10
        b4, // $ access=b4
        c2 // $ access=c2
    );
    print_i64(a10); // $ access=a10
    print_i64(b4); // $ access=b4
    print_i64(c2); // $ access=c2

    match (4, 5) {
        (
            a10, // a10_2
            b4 // b4
        ) => {
            print_i64(a10); // $ access=a10_2
            print_i64(b4); // $ access=b4
        }
    }

    print_i64(a10); // $ access=a10
    print_i64(b4); // $ access=b4
}

fn closure_variable() {
    let example_closure = // example_closure
        |x: i64| // x_1
        x; // $ access=x_1
    let n1 = // n1
        example_closure(5); // $ access=example_closure
    print_i64(n1); // $ access=n1

    immutable_variable();
    let immutable_variable =
        |x: i64| // x_2
        x; // $ access=x_2
    let n2 = // n2
        immutable_variable(6); // $ access=immutable_variable
    print_i64(n2); // $ access=n2
}

fn for_variable() {
    let v = &["apples", "cake", "coffee"]; // v

    for text // text
        in v { // $ access=v
        print_str(text); // $ access=text
    }
}

fn main() {
    immutable_variable();
    mutable_variable();
    variable_shadow1();
    variable_shadow2();
    let_pattern1();
    let_pattern2();
    let_pattern3();
    let_pattern4();
    match_pattern1();
    match_pattern2();
    match_pattern3();
    match_pattern4();
    match_pattern5();
    match_pattern6();
    match_pattern7();
    match_pattern8();
    match_pattern9();
    param_pattern1("a", ("b", "c"));
    param_pattern2(Either::Left(45));
    destruct_assignment();
    closure_variable();
    for_variable();
}
