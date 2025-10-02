use lib::a_module::hello; // $ item=HELLO

use lib::my_macro2; // $ item=my_macro2

mod a_module;

fn main() {
    my_macro2!(); // $ item=my_macro2
    hello(); // $ item=HELLO
}
