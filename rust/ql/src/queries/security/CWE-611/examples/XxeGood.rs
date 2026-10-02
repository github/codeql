use libxml::bindings::xmlReadMemory;
use std::ffi::CString;

fn parse_user_xml(user_input: &str) {
    let c_input = CString::new(user_input).unwrap();
    // GOOD: safe options (0) disable external entity expansion
    unsafe {
        xmlReadMemory(
            c_input.as_ptr(),
            c_input.as_bytes().len() as i32,
            std::ptr::null(),
            std::ptr::null(),
            0,
        );
    }
}
