pub mod nested2; // I8

fn g() {
    println!("mod.rs::g");
    nested2::nested3::nested4::f(); // $ item=I12
} // I9
