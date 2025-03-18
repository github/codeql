use lib::a_module::hello; // $ MISSING: item=HELLO

mod a_module;

fn main() {
    hello(); // $ MISSING: item=HELLO
}
