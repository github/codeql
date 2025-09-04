struct MyRecordStruct<T1, T2> {
    value1: T1,
    value2: T2,
}

struct MyTupleStruct<T1, T2>(T1, T2);

enum MyEnum<T1, T2> {
    Variant1 { value1: T1, value2: T2 },
    Variant2(T2, T1),
}

pub fn f() -> Option<()> {
    let value = Some(42);
    if let Some(mesg) = value {
        let mesg = mesg; // $ type=mesg:i32
        println!("{mesg}");
    }
    match value {
        Some(mesg) => {
            let mesg = mesg; // $ type=mesg:i32
            println!("{mesg}");
        }
        None => (),
    };
    let mesg = value.unwrap(); // $ target=unwrap
    let mesg = mesg; // $ type=mesg:i32
    println!("{mesg}");
    let mesg = value?; // $ type=mesg:i32
    println!("{mesg}");

    let value2 = &Some(42);
    if let &Some(mesg) = value2 {
        let mesg = mesg; // $ type=mesg:i32
        println!("{mesg}");
    }

    let value3 = 42;
    if let ref mesg = value3 {
        let mesg = mesg; // $ type=mesg:&T.i32
        println!("{mesg}");
    }

    let value4 = Some(42);
    if let Some(ref mesg) = value4 {
        let mesg = mesg; // $ type=mesg:&T.i32
        println!("{mesg}");
    }

    let ref value5 = 42;
    let x = value5; // $ type=x:&T.i32

    let my_record_struct = MyRecordStruct {
        value1: 42,
        value2: false,
    };
    if let MyRecordStruct { value1, value2 } = my_record_struct {
        let x = value1; // $ type=x:i32
        let y = value2; // $ type=y:bool
        ();
    }

    let my_tuple_struct = MyTupleStruct(42, false);
    if let MyTupleStruct(value1, value2) = my_tuple_struct {
        let x = value1; // $ type=x:i32
        let y = value2; // $ type=y:bool
        ();
    }

    let my_enum1 = MyEnum::Variant1 {
        value1: 42,
        value2: false,
    };
    match my_enum1 {
        MyEnum::Variant1 { value1, value2 } => {
            let x = value1; // $ type=x:i32
            let y = value2; // $ type=y:bool
            ();
        }
        MyEnum::Variant2(value1, value2) => {
            let x = value1; // $ type=x:bool
            let y = value2; // $ type=y:i32
            ();
        }
    }

    let my_nested_enum = MyEnum::Variant2(
        false,
        MyRecordStruct {
            value1: 42,
            value2: "string",
        },
    );

    match my_nested_enum {
        MyEnum::Variant2(
            value1,
            MyRecordStruct {
                value1: x,
                value2: y,
            },
        ) => {
            let a = value1; // $ type=a:bool
            let b = x; // $ type=b:i32
            let c = y; // $ type=c:&T.str
            ();
        }
        _ => (),
    }

    let opt1 = Some(Default::default()); // $ type=opt1:T.i32 target=default
    #[rustfmt::skip]
    let _ = if let Some::<i32>(x) = opt1
    {
        x; // $ type=x:i32
    };

    let opt2 = Some(Default::default()); // $ type=opt2:T.i32 target=default
    #[rustfmt::skip]
    let _ = if let Option::Some::<i32>(x) = opt2
    {
        x; // $ type=x:i32
    };

    let opt3 = Some(Default::default()); // $ type=opt3:T.i32 target=default
    #[rustfmt::skip]
    let _ = if let Option::<i32>::Some(x) = opt3
    {
        x; // $ type=x:i32
    };

    None
}

// Struct and enum definitions for examples
#[derive(Debug)]
struct Point {
    x: i32,
    y: i32,
}

#[derive(Debug, Clone, Copy)]
struct Color(u8, u8, u8);

#[derive(Debug)]
enum Shape {
    Circle(f64),
    Rectangle { width: f64, height: f64 },
    Triangle(Point, Point, Point),
}

#[derive(Debug)]
enum MyOption<T> {
    Some(T),
    None,
}

// Macro for pattern examples
macro_rules! my_pattern {
    ($x:pat) => {
        match 42i32 {
            $x => println!("Matched macro pattern"),
            _ => println!("No match"),
        }
    };
}

pub fn literal_patterns() {
    let value = 42i32;

    match value {
        // LiteralPat - Literal patterns (including negative literals)
        42 => {
            let literal_match = value; // $ certainType=literal_match:i32
            println!("Literal pattern: {}", literal_match);
        }
        -1 => {
            let negative_literal = value; // $ certainType=negative_literal:i32
            println!("Negative literal: {}", negative_literal);
        }
        0 => {
            let zero_literal = value; // $ certainType=zero_literal:i32
            println!("Zero literal: {}", zero_literal);
        }
        _ => {}
    }

    let float_val = 3.14f64;
    match float_val {
        3.14 => {
            let pi_match = float_val; // $ certainType=pi_match:f64
            println!("Pi matched: {}", pi_match);
        }
        _ => {}
    }

    let string_val = "hello";
    match string_val {
        "hello" => {
            let hello_match = string_val; // $ certainType=hello_match:&T.str
            println!("String literal: {}", hello_match);
        }
        _ => {}
    }

    let bool_val = true;
    match bool_val {
        true => {
            let true_match = bool_val; // $ certainType=true_match:bool
            println!("True literal: {}", true_match);
        }
        false => {
            let false_match = bool_val; // $ certainType=false_match:bool
            println!("False literal: {}", false_match);
        }
    }
}

pub fn identifier_patterns() {
    let value = 42i32;

    // IdentPat - Simple identifier pattern
    match value {
        x => {
            let bound_value = x; // $ type=bound_value:i32
            println!("Identifier pattern: {}", bound_value);
        }
    }

    // IdentPat with ref
    match &value {
        ref x => {
            let ref_bound = x; // $ type=ref_bound:&T.&T.i32
            println!("Reference identifier: {:?}", ref_bound);
        }
    }

    // IdentPat with mut
    let mut mutable_value = 10i32;
    match mutable_value {
        mut x => {
            let mut_bound = x; // $ type=mut_bound:i32
            x += 1; // $ target=add_assign
            println!("Mutable identifier: {}", mut_bound);
        }
    }

    // IdentPat with @ pattern (subpattern binding)
    let option_value = MyOption::Some(42i32);
    match option_value {
        MyOption::Some(x @ 42) => {
            let at_bound = x; // $ type=at_bound:i32
            println!("@ pattern with literal: {}", at_bound);
        }
        MyOption::Some(x @ 1..=100) => {
            let range_at_bound = x; // $ type=range_at_bound:i32
            println!("@ pattern with range: {}", range_at_bound);
        }
        MyOption::Some(x) => {
            let some_bound = x; // $ type=some_bound:i32
            println!("Some value: {}", some_bound);
        }
        MyOption::None => {
            println!("None value");
        }
    }

    // IdentPat with ref mut
    let mut ref_mut_val = 5i32;
    match &mut ref_mut_val {
        ref mut x => {
            let ref_mut_bound = x; // $ type=ref_mut_bound:&T.&T.i32
            **ref_mut_bound += 1; // $ target=deref target=add_assign
            println!("Ref mut pattern");
        }
    }
}

pub fn wildcard_patterns() {
    let value = 42i32;

    match value {
        42 => println!("Specific match"),
        // WildcardPat - Wildcard pattern
        _ => {
            let wildcard_context = value; // $ certainType=wildcard_context:i32
            println!("Wildcard pattern for: {}", wildcard_context);
        }
    }
}

pub fn range_patterns() {
    let value = 42i32;

    match value {
        // RangePat - Range patterns
        1..=10 => {
            let range_inclusive = value; // $ certainType=range_inclusive:i32
            println!("Range inclusive: {}", range_inclusive);
        }
        11.. => {
            let range_from = value; // $ certainType=range_from:i32
            println!("Range from 11: {}", range_from);
        }
        ..=0 => {
            let range_to_inclusive = value; // $ certainType=range_to_inclusive:i32
            println!("Range to 0 inclusive: {}", range_to_inclusive);
        }
        _ => {}
    }

    let char_val = 'c';
    match char_val {
        'a'..='z' => {
            let lowercase_char = char_val; // $ certainType=lowercase_char:char
            println!("Lowercase char: {}", lowercase_char);
        }
        'A'..='Z' => {
            let uppercase_char = char_val; // $ certainType=uppercase_char:char
            println!("Uppercase char: {}", uppercase_char);
        }
        _ => {}
    }
}

pub fn reference_patterns() {
    let value = 42i32;
    let mut mutable_value = 10i32;

    // RefPat - Reference patterns
    match &value {
        &42 => {
            let deref_match = value; // $ certainType=deref_match:i32
            println!("Dereferenced match: {}", deref_match);
        }
        &x => {
            let deref_bound = x; // $ type=deref_bound:i32
            println!("Dereferenced binding: {}", deref_bound);
        }
    }

    match &mut mutable_value {
        &mut ref x => {
            let mut_ref_bound = x; // $ type=mut_ref_bound:&T.i32
            println!("Mutable ref pattern: {}", mut_ref_bound);
        }
    }

    match &value {
        ref x => {
            let ref_pattern = x; // $ type=ref_pattern:&T.&T.i32
            println!("Reference pattern: {}", ref_pattern);
        }
    }
}

pub fn record_patterns() {
    let point = Point { x: 10, y: 20 };

    // RecordPat - Record (struct) patterns
    match point {
        Point { x: 0, y: 0 } => {
            let origin = point; // $ type=origin:Point
            println!("Origin point: {:?}", origin);
        }
        Point { x, y: 0 } => {
            let x_axis_x = x; // $ type=x_axis_x:i32
            let x_axis_point = point; // $ type=x_axis_point:Point
            println!("Point on x-axis: x={}, point={:?}", x_axis_x, x_axis_point);
        }
        Point { x: 10, .. } => {
            let ten_x_point = point; // $ type=ten_x_point:Point
            println!("Point with x=10: {:?}", ten_x_point);
        }
        Point { x, y } => {
            let general_x = x; // $ type=general_x:i32
            let general_y = y; // $ type=general_y:i32
            println!("General point: ({}, {})", general_x, general_y);
        }
    }

    // Nested record patterns
    let shape = Shape::Rectangle {
        width: 10.0,
        height: 20.0,
    };
    match shape {
        Shape::Rectangle {
            width: w,
            height: h,
        } => {
            let rect_width = w; // $ type=rect_width:f64
            let rect_height = h; // $ type=rect_height:f64
            println!("Rectangle: {}x{}", rect_width, rect_height);
        }
        _ => {}
    }
}

pub fn tuple_struct_patterns() {
    let color = Color(255, 128, 0);

    // TupleStructPat - Tuple struct patterns
    match color {
        Color(255, 0, 0) => {
            let red_color = color; // $ type=red_color:Color
            println!("Pure red: {:?}", red_color);
        }
        Color(r, g, b) => {
            let red_component = r; // $ type=red_component:u8
            let green_component = g; // $ type=green_component:u8
            let blue_component = b; // $ type=blue_component:u8
            println!(
                "Color: ({}, {}, {})",
                red_component, green_component, blue_component
            );
        }
    }

    // With rest pattern
    match color {
        Color(255, ..) => {
            let reddish_color = color; // $ type=reddish_color:Color
            println!("Reddish color: {:?}", reddish_color);
        }
        Color(r, ..) => {
            let any_red = r; // $ type=any_red:u8
            println!("Any color with red: {}", any_red);
        }
    }

    // Single element tuple struct
    struct Wrapper(i32);
    let wrapper = Wrapper(42);
    match wrapper {
        Wrapper(x) => {
            let wrapped_value = x; // $ type=wrapped_value:i32
            println!("Wrapped: {}", wrapped_value);
        }
    }
}

pub fn tuple_patterns() {
    let tuple = (1i32, 2i64, 3.0f32);

    // TuplePat - Tuple patterns
    match tuple {
        (1, 2, 3.0) => {
            let exact_tuple = tuple; // $ certainType=exact_tuple:(T_3)
            println!("Exact tuple: {:?}", exact_tuple);
        }
        (a, b, c) => {
            let first_elem = a; // $ type=first_elem:i32
            let second_elem = b; // $ type=second_elem:i64
            let third_elem = c; // $ type=third_elem:f32
            println!("Tuple: ({}, {}, {})", first_elem, second_elem, third_elem);
        }
    }

    // With rest pattern
    match tuple {
        (first, ..) => {
            let tuple_first = first; // $ MISSING: type=tuple_first:i32
            println!("First element: {}", tuple_first);
        }
    }

    // Empty tuple
    let unit = ();
    match unit {
        () => {
            let unit_value = unit; // $ certainType=unit_value:()
            println!("Unit value: {:?}", unit_value);
        }
    }

    // Single element tuple (needs comma)
    let single = (42i32,);
    match single {
        (x,) => {
            let single_elem = x; // $ type=single_elem:i32
            println!("Single element tuple: {}", single_elem);
        }
    }

    // Tuple pattern on reference to tuple in `let` expression
    let ref_tuple1: &(i32, i32) = &(1, 2);
    if let (n, m) = ref_tuple1 {
        println!("n: {}", n);
        println!("m: {}", m);
    }

    // Tuple pattern on reference to tuple in `let` statement
    let ref_tuple2: &(i32, i32) = &(1, 2);
    let (n, m) = ref_tuple2;
    println!("n: {}", n);
    println!("m: {}", m);
}

pub fn parenthesized_patterns() {
    let value = 42i32;

    // ParenPat - Parenthesized patterns
    match value {
        (x) => {
            let paren_bound = x; // $ type=paren_bound:i32
            println!("Parenthesized pattern: {}", paren_bound);
        }
    }

    // More complex parenthesized pattern
    let tuple = (1i32, 2i32);
    match tuple {
        (x, (y)) => {
            let paren_x = x; // $ type=paren_x:i32
            let paren_y = y; // $ type=paren_y:i32
            println!("Parenthesized in tuple: {}, {}", paren_x, paren_y);
        }
    }
}

pub fn slice_patterns() {
    let slice: &[i32] = &[1, 2, 3, 4, 5];

    // SlicePat - Slice patterns
    match slice {
        [] => {
            let empty_slice = slice; // $ certainType=empty_slice:&T.[T].i32
            println!("Empty slice: {:?}", empty_slice);
        }
        [x] => {
            let single_elem = *x; // $ MISSING: type=single_elem:i32
            println!("Single element: {}", single_elem);
        }
        [first, second] => {
            let slice_first = *first; // $ MISSING: type=slice_first:i32
            let slice_second = *second; // $ MISSING: type=slice_second:i32
            println!("Two elements: {}, {}", slice_first, slice_second);
        }
        [first, middle @ .., last] => {
            let slice_start = *first; // $ MISSING: type=slice_start:i32
            let slice_end = *last; // $ MISSING: type=slice_end:i32
            let slice_middle = middle; // $ MISSING: type=slice_middle:&T.[T].i32
            println!(
                "First: {}, last: {}, middle len: {}",
                slice_start,
                slice_end,
                slice_middle.len()
            );
        }
    }

    // Array patterns
    let array = [1i32, 2, 3];
    match array {
        [a, b, c] => {
            let arr_a = a; // $ MISSING: type=arr_a:i32
            let arr_b = b; // $ MISSING: type=arr_b:i32
            let arr_c = c; // $ MISSING: type=arr_c:i32
            println!("Array elements: {}, {}, {}", arr_a, arr_b, arr_c);
        }
    }
}

pub fn path_patterns() {
    // PathPat - Path patterns (for enums, constants, etc.)
    const CONSTANT: i32 = 42;
    let value = 42i32;

    match value {
        CONSTANT => {
            let const_match = value; // $ certainType=const_match:i32
            println!("Matches constant: {}", const_match);
        }
        _ => {}
    }

    // Enum variants as path patterns
    let option = MyOption::Some(10i32);
    match option {
        MyOption::None => {
            println!("None variant");
        }
        MyOption::Some(x) => {
            let some_value = x; // $ type=some_value:i32
            println!("Some value: {}", some_value);
        }
    }

    // Module path patterns
    match std::result::Result::Ok::<i32, usize>(42) {
        std::result::Result::Ok(x) => {
            let ok_value = x; // $ type=ok_value:i32
            println!("Ok value: {}", ok_value);
        }
        std::result::Result::Err(e) => {
            let err_value = e; // $ type=err_value:usize
            println!("Error: {}", err_value);
        }
    }
}

pub fn or_patterns() {
    let value = 42i32;

    // OrPat - Or patterns
    match value {
        1 | 2 | 3 => {
            let small_num = value; // $ certainType=small_num:i32
            println!("Small number: {}", small_num);
        }
        10 | 20 => {
            let round_num = value; // $ certainType=round_num:i32
            println!("Round number: {}", round_num);
        }
        _ => {}
    }

    // Complex or pattern with structs
    let point = Point { x: 0, y: 5 };
    match point {
        Point { x: x @ 0, y } | Point { x, y: y @ 0 } => {
            let axis_x = x; // $ type=axis_x:i32
            let axis_y = y; // $ type=axis_y:i32
            println!("Point on axis: ({}, {})", axis_x, axis_y);
        }
        _ => {}
    }

    // Or pattern with ranges
    match value {
        1..=10 | 90..=100 => {
            let range_or_value = value; // $ certainType=range_or_value:i32
            println!("In range: {}", range_or_value);
        }
        _ => {}
    }
}

pub fn rest_patterns() {
    let tuple = (1i32, 2i64, 3.0f32, 4u8);

    // RestPat - Rest patterns (..)
    match tuple {
        (first, ..) => {
            let rest_first = first; // $ MISSING: type=rest_first:i32
            println!("First with rest: {}", rest_first);
        }
    }

    match tuple {
        (.., last) => {
            let rest_last = last; // $ MISSING: type=rest_last:u8
            println!("Last with rest: {}", rest_last);
        }
    }

    match tuple {
        (first, .., last) => {
            let rest_start = first; // $ MISSING: type=rest_start:i32
            let rest_end = last; // $ MISSING: type=rest_end:u8
            println!("First and last: {}, {}", rest_start, rest_end);
        }
    }

    // Rest in struct
    let point = Point { x: 10, y: 20 };
    match point {
        Point { x, .. } => {
            let rest_x = x; // $ type=rest_x:i32
            println!("X coordinate: {}", rest_x);
        }
    }
}

pub fn macro_patterns() {
    // MacroPat - Macro patterns
    my_pattern!(42);
    my_pattern!(x);

    // More complex macro pattern
    macro_rules! match_and_bind {
        ($val:expr, $pat:pat) => {
            match $val {
                $pat => {
                    let macro_bound = $val; // $ type=macro_bound:i32
                    println!("Macro pattern matched: {}", macro_bound);
                }
                _ => {}
            }
        };
    }

    match_and_bind!(42i32, 42);
    match_and_bind!(10i32, x);
}

pub fn complex_nested_patterns() {
    // Complex nested patterns combining multiple pattern types
    let complex_data = (Point { x: 1, y: 2 }, MyOption::Some(Color(255, 0, 0)));

    match complex_data {
        // Combining TuplePat, RecordPat, PathPat, TupleStructPat
        (Point { x: 1, y }, MyOption::Some(Color(255, g, b))) => {
            let nested_y = y; // $ type=nested_y:i32
            let nested_g = g; // $ type=nested_g:u8
            let nested_b = b; // $ type=nested_b:u8
            println!(
                "Complex nested: y={}, green={}, blue={}",
                nested_y, nested_g, nested_b
            );
        }
        // Or pattern with tuple and wildcard
        (Point { x, .. }, MyOption::None) | (Point { x: x @ 0, .. }, _) => {
            let alt_complex_x = x; // $ type=alt_complex_x:i32
            println!("Alternative complex: x={:?}", alt_complex_x);
        }
        // Catch-all with identifier pattern
        other => {
            let other_complex = other; // $ type=other_complex:0(2).Point type=other_complex:1(2).MyOption
            println!("Other complex data: {:?}", other_complex);
        }
    }
}

pub fn patterns_in_let_statements() {
    // Patterns in let statements
    let point = Point { x: 10, y: 20 };
    let Point { x, y } = point; // RecordPat in let
    let let_x = x; // $ type=let_x:i32
    let let_y = y; // $ type=let_y:i32

    let tuple = (1i32, 2i64, 3.0f32);
    let (a, b, c) = tuple; // TuplePat in let
    let let_a = a; // $ type=let_a:i32
    let let_b = b; // $ type=let_b:i64
    let let_c = c; // $ type=let_c:f32

    let array = [1i32, 2, 3, 4, 5];
    let [first, .., last] = array; // SlicePat in let
    let let_first = first; // $ MISSING: type=let_first:i32
    let let_last = last; // $ MISSING: type=let_last:i32

    let color = Color(255, 128, 0);
    let Color(r, g, b) = color; // TupleStructPat in let
    let let_r = r; // $ type=let_r:u8
    let let_g = g; // $ type=let_g:u8
    let let_b = b; // $ type=let_b:u8

    // Let with reference pattern
    let value = 42i32;
    let ref ref_val = value;
    let let_ref = ref_val; // $ certainType=let_ref:&T.i32

    // Let with mutable pattern
    let mut mut_val = 10i32;
    let let_mut = mut_val; // $ certainType=let_mut:i32
}

pub fn patterns_in_function_parameters() {
    // Patterns in function parameters

    fn extract_point(Point { x, y }: Point) -> (i32, i32) {
        let param_x = x; // $ type=param_x:i32
        let param_y = y; // $ type=param_y:i32
        (param_x, param_y)
    }

    fn extract_color(Color(r, _, _): Color) -> u8 {
        let param_r = r; // $ type=param_r:u8
        param_r
    }

    fn extract_tuple((first, _, third): (i32, f64, bool)) -> (i32, bool) {
        let param_first = first; // $ type=param_first:i32
        let param_third = third; // $ type=param_third:bool
        (param_first, param_third)
    }

    // Call the functions to use them
    let point = Point { x: 5, y: 10 };
    let extracted = extract_point(point); // $ target=extract_point certainType=extracted:0(2).i32 certainType=extracted:1(2).i32

    let color = Color(200, 100, 50);
    let red = extract_color(color); // $ target=extract_color certainType=red:u8

    let tuple = (42i32, 3.14f64, true);
    let tuple_extracted = extract_tuple(tuple); // $ target=extract_tuple certainType=tuple_extracted:0(2).i32 certainType=tuple_extracted:1(2).bool
}

#[rustfmt::skip]
pub fn patterns_in_control_flow() {
    // Patterns in for loops
    let points = vec![Point { x: 1, y: 2 }, Point { x: 3, y: 4 }];
    for Point { x, y } in points {
        let loop_x = x; // $ type=loop_x:i32
        let loop_y = y; // $ type=loop_y:i32
        println!("Point in loop: ({}, {})", loop_x, loop_y);
    }

    // Patterns in if let
    let option_value = MyOption::Some(42i32);
    if let MyOption::Some(x @ 42) = option_value {
        let if_let_x = x; // $ type=if_let_x:i32
        println!("If let with @ pattern: {}", if_let_x);
    }

    // Patterns in while let
    let mut stack: Vec<i32> = vec![1i32, 2, 3];
    while let Some(x) = stack.pop() { // $ target=pop
        let while_let_x = x; // $ type=while_let_x:i32
        println!("Popped: {}", while_let_x);
    }

    // Patterns in match guards
    let value = 42i32;
    match value {
        x if x > 0 => { // $ target=gt
            let guard_x = x; // $ type=guard_x:i32
            println!("Positive: {}", guard_x);
        }
        _ => {}
    }
}

pub fn test_all_patterns() {
    f(); // $ target=f
    literal_patterns(); // $ target=literal_patterns
    identifier_patterns(); // $ target=identifier_patterns
    wildcard_patterns(); // $ target=wildcard_patterns
    range_patterns(); // $ target=range_patterns
    reference_patterns(); // $ target=reference_patterns
    record_patterns(); // $ target=record_patterns
    tuple_struct_patterns(); // $ target=tuple_struct_patterns
    tuple_patterns(); // $ target=tuple_patterns
    parenthesized_patterns(); // $ target=parenthesized_patterns
    slice_patterns(); // $ target=slice_patterns
    path_patterns(); // $ target=path_patterns
    or_patterns(); // $ target=or_patterns
    rest_patterns(); // $ target=rest_patterns
    macro_patterns(); // $ target=macro_patterns
    complex_nested_patterns(); // $ target=complex_nested_patterns
    patterns_in_let_statements(); // $ target=patterns_in_let_statements
    patterns_in_function_parameters(); // $ target=patterns_in_function_parameters
    patterns_in_control_flow(); // $ target=patterns_in_control_flow
}
