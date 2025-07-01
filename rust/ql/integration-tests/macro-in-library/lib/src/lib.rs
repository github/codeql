macro_rules! define_hello {
  () => {
      pub fn hello() { println!("hello world!"); }
  };
}

define_hello!();
