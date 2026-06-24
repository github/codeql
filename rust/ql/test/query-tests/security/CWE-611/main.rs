use libxml::bindings;
use std::os::fd::AsRawFd;
use std::os::raw::{c_char, c_uchar};

// --- BAD: user-controlled XML with unsafe parser options ---

unsafe fn test_xml_parse_noent(user_xml: &str) {
    // BAD: XML_PARSE_NOENT enables external entity substitution
    bindings::xmlReadMemory(user_xml.as_ptr() as *const c_char, user_xml.len() as i32, std::ptr::null_mut(), std::ptr::null_mut(), bindings::xmlParserOption_XML_PARSE_NOENT as i32); // $ Alert[rust/xxe]
}

unsafe fn test_xml_parse_dtdload(user_xml: &str) {
    // BAD: XML_PARSE_DTDLOAD enables loading of external DTD subsets
    bindings::xmlReadMemory(user_xml.as_ptr() as *const c_char, user_xml.len() as i32, std::ptr::null_mut(), std::ptr::null_mut(), bindings::xmlParserOption_XML_PARSE_DTDLOAD as i32); // $ Alert[rust/xxe]
}

unsafe fn test_xml_parse_combined(user_xml: &str) {
    // BAD: combining both unsafe options
    bindings::xmlReadMemory(user_xml.as_ptr() as *const c_char, user_xml.len() as i32, std::ptr::null_mut(), std::ptr::null_mut(), bindings::xmlParserOption_XML_PARSE_NOENT as i32 | bindings::xmlParserOption_XML_PARSE_DTDLOAD as i32); // $ Alert[rust/xxe]
}

unsafe fn test_xml_read_file_bad(user_filename: &str) {
    // BAD: user-controlled filename with XML_PARSE_NOENT
    bindings::xmlReadFile(user_filename.as_ptr() as *const c_char, std::ptr::null_mut(), bindings::xmlParserOption_XML_PARSE_NOENT as i32); // $ Alert[rust/xxe]
}

unsafe fn test_xml_read_doc_bad(user_xml: &str) {
    // BAD: user-controlled XML document with XML_PARSE_DTDLOAD
    bindings::xmlReadDoc(user_xml.as_ptr() as *const c_uchar, std::ptr::null_mut(), std::ptr::null_mut(), bindings::xmlParserOption_XML_PARSE_DTDLOAD as i32); // $ Alert[rust/xxe]
}

unsafe fn test_xml_read_fd_bad(user_fd: i32) {
    // BAD: user-controlled file descriptor with XML_PARSE_DTDLOAD
    bindings::xmlReadFd(user_fd, std::ptr::null_mut(), std::ptr::null_mut(), bindings::xmlParserOption_XML_PARSE_DTDLOAD as i32); // $ Alert[rust/xxe]
}

unsafe fn test_xml_ctxt_read_file_bad(user_filename: &str) {
    // BAD: user-controlled filename with XML_PARSE_NOENT via ctxt variant
    bindings::xmlCtxtReadFile(std::ptr::null_mut(), user_filename.as_ptr() as *const c_char, std::ptr::null_mut(), bindings::xmlParserOption_XML_PARSE_NOENT as i32); // $ Alert[rust/xxe]
}

unsafe fn test_xml_ctxt_read_doc_bad(user_xml: &str) {
    // BAD: user-controlled XML with unsafe options via ctxt variant
    bindings::xmlCtxtReadDoc(std::ptr::null_mut(), user_xml.as_ptr() as *const c_uchar, std::ptr::null_mut(), std::ptr::null_mut(), bindings::xmlParserOption_XML_PARSE_NOENT as i32); // $ Alert[rust/xxe]
}

unsafe fn test_xml_ctxt_read_memory_bad(user_xml: &str) {
    // BAD: user-controlled XML with unsafe options via ctxt variant
    bindings::xmlCtxtReadMemory( // $ Alert[rust/xxe]
        std::ptr::null_mut(),
        user_xml.as_ptr() as *const c_char,
        user_xml.len() as i32,
        std::ptr::null_mut(),
        std::ptr::null_mut(),
        bindings::xmlParserOption_XML_PARSE_NOENT as i32,
    );
}

unsafe fn test_integer_literals(user_xml: &str) {
    // BAD: literal value 2 = XML_PARSE_NOENT
    bindings::xmlReadMemory(user_xml.as_ptr() as *const c_char, user_xml.len() as i32, std::ptr::null_mut(), std::ptr::null_mut(), 2); // $ Alert[rust/xxe]

    // BAD: literal value 4 = XML_PARSE_DTDLOAD
    bindings::xmlReadMemory(user_xml.as_ptr() as *const c_char, user_xml.len() as i32, std::ptr::null_mut(), std::ptr::null_mut(), 4i32); // $ Alert[rust/xxe]

    // BAD: literal value 4 = XML_PARSE_DTDLOAD
    bindings::xmlReadMemory(user_xml.as_ptr() as *const c_char, user_xml.len() as i32, std::ptr::null_mut(), std::ptr::null_mut(), 0x4i32); // $ MISSING: Alert[rust/xxe]

    // GOOD: literal value 0 = no entity expansion
    bindings::xmlReadMemory(user_xml.as_ptr() as *const c_char, user_xml.len() as i32, std::ptr::null_mut(), std::ptr::null_mut(), 0);

    // GOOD: literal value 2048 = no entity expansion
    bindings::xmlReadMemory(user_xml.as_ptr() as *const c_char, user_xml.len() as i32, std::ptr::null_mut(), std::ptr::null_mut(), 2_048);
}

unsafe fn test_dataflow_bad(user_xml: &str) {
    // BAD: user-controlled XML with unsafe parser options via dataflow
    let flags = bindings::xmlParserOption_XML_PARSE_NOENT as i32 | 1024;
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
    bindings::xmlReadMemory(xml.as_ptr() as *const c_char, xml.len() as i32, std::ptr::null_mut(), std::ptr::null_mut(), bindings::xmlParserOption_XML_PARSE_NOENT as i32);
    bindings::xmlReadFile("trusted/input.xml".as_ptr() as *const c_char, std::ptr::null_mut(), bindings::xmlParserOption_XML_PARSE_NOENT as i32);
}

fn main() {
    let user_xml = std::env::args().nth(1).unwrap_or_default(); // $ Source
    let user_filename = std::env::args().nth(2).unwrap_or_default(); // $ Source
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
        test_integer_literals(&user_xml);
        test_dataflow_bad(&user_xml);
        test_xml_parse_safe_options(&user_xml);
        test_xml_hardcoded_unsafe();
    }
}
