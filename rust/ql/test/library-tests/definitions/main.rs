fn main() {
    let width = 4;
    let precision = 2;
    let value = 10;
    println!("Value {value:#width$.precision$}", value = 10.5);
    println!("Value {0:#1$.2$}", value, width, precision);
    println!("Value {} {}", value, width);
    let people = "Rustaceans";
    println!("Hello {people}!");
    println!("{1} {} {0} {}", 1, 2);
    assert_eq!(format!("Hello {:<5}!", "x"), "Hello x    !");
}
