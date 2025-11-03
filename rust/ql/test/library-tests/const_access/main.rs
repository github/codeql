const GLOBAL_CONST: i32 = 42;
const STRING_CONST: &str = "hello";

struct MyStruct {
    value: i32,
}

impl MyStruct {
    const ASSOC_CONST: i32 = 100;
}

mod my_module {
    pub const MODULE_CONST: i32 = 200;
}

fn use_consts() {
    let x = GLOBAL_CONST; // $ const_access=GLOBAL_CONST
    
    let s = STRING_CONST; // $ const_access=STRING_CONST
    
    let y = MyStruct::ASSOC_CONST; // $ const_access=ASSOC_CONST
    
    let z = my_module::MODULE_CONST; // $ const_access=MODULE_CONST
    
    if GLOBAL_CONST > 0 { // $ const_access=GLOBAL_CONST
        println!("positive");
    }
    
    let arr = [MyStruct::ASSOC_CONST; 5]; // $ const_access=ASSOC_CONST
}

fn main() {
    use_consts();
}
