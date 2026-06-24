use libxml::bindings;
use std::os::fd::AsRawFd;
use std::os::raw::{c_char, c_uchar};



// xmlParserOption constants
const XML_PARSE_NOENT: i32 = 2; // substitute entities
const XML_PARSE_DTDLOAD: i32 = 4; // load the external subset
























































// --- BAD: user-controlled XML with unsafe parser options ---

unsafe fn test_xml_parse_noent(user_xml: &str) {
    // BAD: XML_PARSE_NOENT enables external entity substitution
    bindings::xmlReadMemory(user_xml.as_ptr() as *const c_char, user_xml.len() as i32, std::ptr::null_mut(), std::ptr::null_mut(), XML_PARSE_NOENT); // $ MISSING: Alert[rust/xxe]
}

unsafe fn test_xml_parse_dtdload(user_xml: &str) {
    // BAD: XML_PARSE_DTDLOAD enables loading of external DTD subsets
    bindings::xmlReadMemory(user_xml.as_ptr() as *const c_char, user_xml.len() as i32, std::ptr::null_mut(), std::ptr::null_mut(), XML_PARSE_DTDLOAD); // $ MISSING: Alert[rust/xxe]
}

unsafe fn test_xml_parse_combined(user_xml: &str) {
    // BAD: combining both unsafe options
    bindings::xmlReadMemory(user_xml.as_ptr() as *const c_char, user_xml.len() as i32, std::ptr::null_mut(), std::ptr::null_mut(), XML_PARSE_NOENT | XML_PARSE_DTDLOAD); // $ MISSING: Alert[rust/xxe]
}

unsafe fn test_xml_read_file_bad(user_filename: &str) {
    // BAD: user-controlled filename with XML_PARSE_NOENT
    bindings::xmlReadFile(user_filename.as_ptr() as *const c_char, std::ptr::null_mut(), XML_PARSE_NOENT); // $ MISSING: Alert[rust/xxe]
}

unsafe fn test_xml_read_doc_bad(user_xml: &str) {
    // BAD: user-controlled XML document with XML_PARSE_DTDLOAD
    bindings::xmlReadDoc(user_xml.as_ptr() as *const c_uchar, std::ptr::null_mut(), std::ptr::null_mut(), XML_PARSE_DTDLOAD); // $ MISSING: Alert[rust/xxe]
}

unsafe fn test_xml_read_fd_bad(user_fd: i32) {
    // BAD: user-controlled file descriptor with XML_PARSE_DTDLOAD
    bindings::xmlReadFd(user_fd, std::ptr::null_mut(), std::ptr::null_mut(), XML_PARSE_DTDLOAD); // $ Alert[rust/xxe]
}

unsafe fn test_xml_ctxt_read_file_bad(user_filename: &str) {
    // BAD: user-controlled filename with XML_PARSE_NOENT via ctxt variant
    bindings::xmlCtxtReadFile(std::ptr::null_mut(), user_filename.as_ptr() as *const c_char, std::ptr::null_mut(), XML_PARSE_NOENT); // $ MISSING: Alert[rust/xxe]
}

unsafe fn test_xml_ctxt_read_doc_bad(user_xml: &str) {
    // BAD: user-controlled XML with unsafe options via ctxt variant
    bindings::xmlCtxtReadDoc(std::ptr::null_mut(), user_xml.as_ptr() as *const c_uchar, std::ptr::null_mut(), std::ptr::null_mut(), XML_PARSE_NOENT); // $ MISSING: Alert[rust/xxe]
}

unsafe fn test_xml_ctxt_read_memory_bad(user_xml: &str) {
    // BAD: user-controlled XML with unsafe options via ctxt variant
    bindings::xmlCtxtReadMemory(
        std::ptr::null_mut(),
        user_xml.as_ptr() as *const c_char, // $ MISSING: Alert[rust/xxe]
        user_xml.len() as i32,
        std::ptr::null_mut(),
        std::ptr::null_mut(),
        XML_PARSE_NOENT,
    );
}

unsafe fn test_integer_literal_bad(user_xml: &str) {
    // BAD: literal value 2 = XML_PARSE_NOENT
    bindings::xmlReadMemory(user_xml.as_ptr() as *const c_char, user_xml.len() as i32, std::ptr::null_mut(), std::ptr::null_mut(), 2); // $ MISSING: Alert[rust/xxe]
}

unsafe fn test_dataflow_bad(user_xml: &str) {
    // BAD: user-controlled XML with unsafe parser options via dataflow
    let flags = XML_PARSE_NOENT | 1024;
    bindings::xmlReadMemory(user_xml.as_ptr() as *const c_char, user_xml.len() as i32, std::ptr::null_mut(), std::ptr::null_mut(), flags); // $ MISSING: Alert[rust/xxe]
}

// --- GOOD: user-controlled XML with safe parser options ---

unsafe fn test_xml_parse_safe_options(user_xml: &str) {
    // GOOD: options = 0 means no entity expansion
    bindings::xmlReadMemory(user_xml.as_ptr() as *const c_char, user_xml.len() as i32, std::ptr::null_mut(), std::ptr::null_mut(), 0);
    bindings::xmlReadFile(user_xml.as_ptr() as *const c_char, std::ptr::null_mut(), 0);
    bindings::xmlReadDoc(user_xml.as_ptr() as *const c_uchar, std::ptr::null_mut(), std::ptr::null_mut(), 0);
}

// --- GOOD: hardcoded (non-user-controlled) XML with unsafe parser options ---

unsafe fn test_xml_hardcoded_unsafe() {
    let xml = "<root/>";
    // GOOD: XML content is not user-controlled
    bindings::xmlReadMemory(xml.as_ptr() as *const c_char, xml.len() as i32, std::ptr::null_mut(), std::ptr::null_mut(), XML_PARSE_NOENT);
    bindings::xmlReadFile("trusted/input.xml".as_ptr() as *const c_char, std::ptr::null_mut(), XML_PARSE_NOENT);
}

fn main() {
    let user_xml = std::env::args().nth(1).unwrap_or_default(); // $ MISSING: Source
    let user_filename = std::env::args().nth(2).unwrap_or_default(); // $ MISSING: Source
    let user_file = std::fs::File::open(&user_filename).ok(); // $ Source
    let user_fd = user_file.as_ref().map_or(-1, |file| file.as_raw_fd());

    unsafe {
        test_xml_parse_noent(&user_xml);
        test_xml_parse_dtdload(&user_xml);
        test_xml_parse_combined(&user_xml);
        test_xml_read_file_bad(&user_filename);
        test_xml_read_doc_bad(&user_xml);
        test_xml_read_fd_bad(user_fd);
        test_xml_ctxt_read_file_bad(&user_filename);
        test_xml_ctxt_read_doc_bad(&user_xml);
        test_xml_ctxt_read_memory_bad(&user_xml);
        test_integer_literal_bad(&user_xml);
        test_dataflow_bad(&user_xml);
        test_xml_parse_safe_options(&user_xml);
        test_xml_hardcoded_unsafe();
    }
}
