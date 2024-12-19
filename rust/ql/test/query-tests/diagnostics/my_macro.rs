/**
 * total lines in this file: 19
 * of which code: 11
 * of which only comments: 6
 * of which blank: 2
 */

macro_rules! myMacro {
    () => {
        println!("Hello, world!");
    };
}

pub fn my_func() {
    if true {
        myMacro!();
        myUndefinedMacro!();
    }
}
