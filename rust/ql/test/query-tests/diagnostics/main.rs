/**
 * total lines in this file: 18
 * of which code: 7
 * of which only comments: 7
 * of which blank: 4
 */

mod my_struct;
mod my_macro;

// another comment

fn main() { // another comment
    //println!("Hello, world!"); // currently causes consistency issues

    my_struct::my_func();
    my_macro::my_func();
}
