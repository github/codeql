fn char_literals() {
    'a';
    'b';
    '\'';
    '\n';
    '\u{1F600}';
}

fn string_literals() {
    // from https://doc.rust-lang.org/reference/tokens.html#string-literals
    "foo";
    r"foo"; // foo
    "\"foo\"";
    r#""foo""#; // "foo"

    "foo #\"# bar";
    r##"foo #"# bar"##; // foo #"# bar

    "\x52";
    "R";
    r"R"; // R
    "\\x52";
    r"\x52"; // \x52
}

fn integer_literals() {
    // from https://doc.rust-lang.org/reference/tokens.html#integer-literals
    123;
    123i32;
    123u32;
    123_u32;

    0xff;
    0xff_u8;
    0x01_f32; // integer 7986, not floating-point 1.0
    0x01_e3; // integer 483, not floating-point 1000.0

    0o70;
    0o70_i16;

    0b1111_1111_1001_0000;
    0b1111_1111_1001_0000i64;
    0b________1;

    0usize;

    // These are too big for their type, but are accepted as literal expressions.
    #[allow(overflowing_literals)]
    128_i8;
    #[allow(overflowing_literals)]
    256_u8;
}

fn float_literals() {
    // This is an integer literal, accepted as a floating-point literal expression.
    5f32;

    123.0f64;
    0.1f64;
    0.1f32;
    12E+99_f64;
    let x: f64 = 2.;
}

fn boolean_literals() {
    true;
    false;
}
