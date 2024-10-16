fn main() {
    let width = 4;
    let precision = 2;
    let value = 10;
    println!("Value {value:#width$.precision$}", value = 10.5);
    println!("Value {0:#1$.2$}", value, width, precision);
    println!("Value {} {}", value, width);

    // Examples from https://doc.rust-lang.org/std/fmt
    println!("Hello");
    println!("Hello, {}!", "world");
    println!("The number is {}", 1);
    println!("{:?}", (3, 4));
    println!("{value}", value = 4);
    let people = "Rustaceans";
    println!("Hello {people}!");
    println!("{} {}", 1, 2);
    println!("{:04}", 42);
    println!("{:#?}", (100, 200));

    println!("{1} {} {0} {}", 1, 2);
    println!("Hello {:5}!", "x");
    println!("Hello {:1$}!", "x", 5);
    println!("Hello {1:0$}!", 5, "x");
    println!("Hello {:width$}!", "x", width = 5);
    let width = 5;
    println!("Hello {:width$}!", "x");
    assert_eq!(format!("Hello {:<5}!", "x"), "Hello x    !");
    assert_eq!(format!("Hello {:-<5}!", "x"), "Hello x----!");
    assert_eq!(format!("Hello {:^5}!", "x"), "Hello   x  !");
    assert_eq!(format!("Hello {:>5}!", "x"), "Hello     x!");
    println!("Hello {:^15}!", format!("{:?}", Some("hi")));
    assert_eq!(format!("Hello {:+}!", 5), "Hello +5!");
    assert_eq!(format!("{:#x}!", 27), "0x1b!");
    assert_eq!(format!("Hello {:05}!", 5), "Hello 00005!");
    assert_eq!(format!("Hello {:05}!", -5), "Hello -0005!");
    assert_eq!(format!("{:#010x}!", 27), "0x0000001b!");

    println!("Hello {0} is {1:.5}", "x", 0.01);

    println!("Hello {1} is {2:.0$}", 5, "x", 0.01);

    println!("Hello {0} is {2:.1$}", "x", 5, 0.01);

    println!("Hello {} is {:.*}", "x", 5, 0.01);

    println!("Hello {1} is {2:.*}", 5, "x", 0.01);
    println!("Hello {} is {2:.*}", "x", 5, 0.01);
    println!("Hello {} is {number:.prec$}", "x", prec = 5, number = 0.01);

    println!(
        "{}, `{name:.*}` has 3 fractional digits",
        "Hello",
        3,
        name = 1234.56
    );
    println!(
        "{}, `{name:.*}` has 3 characters",
        "Hello",
        3,
        name = "1234.56"
    );
    println!(
        "{}, `{name:>8.*}` has 3 right-aligned characters",
        "Hello",
        3,
        name = "1234.56"
    );

    print!("{0:.1$e}", 12345, 3);
    print!("{0:.1$e}", 12355, 3);

    println!("The value is {}", 1.5);

    assert_eq!(format!("Hello {{}}"), "Hello {}");
    assert_eq!(format!("{{ Hello"), "{ Hello");
}
