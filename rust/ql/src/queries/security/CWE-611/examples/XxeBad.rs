use libxml::bindings::{xmlReadMemory, XML_PARSE_NOENT};
use std::ffi::CString;

fn parse_user_xml(user_input: &str) {
    let c_input = CString::new(user_input).unwrap();
    // BAD: external entity expansion is enabled via XML_PARSE_NOENT
    unsafe {
        xmlReadMemory(
            c_input.as_ptr(),
            c_input.as_bytes().len() as i32,
            std::ptr::null(),
            std::ptr::null(),
            XML_PARSE_NOENT as i32,
        );
    }
}
