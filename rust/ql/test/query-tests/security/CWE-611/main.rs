// Stub types and constants to simulate libxml2 bindings
pub struct XmlDoc;
pub struct XmlParserCtxt;

// xmlParserOption constants
const XML_PARSE_NOENT: i32 = 2; // substitute entities
const XML_PARSE_DTDLOAD: i32 = 4; // load the external subset

// Stub libxml2 parsing functions (simplified signatures using &str for clarity)
fn xmlReadFile(_url: &str, _encoding: &str, _options: i32) -> *mut XmlDoc {
    std::ptr::null_mut()
}

fn xmlReadMemory(buffer: &str, _size: i32, _url: &str, _encoding: &str, _options: i32) -> *mut XmlDoc {
    let _ = buffer;
    std::ptr::null_mut()
}

fn xmlReadDoc(cur: &str, _url: &str, _encoding: &str, _options: i32) -> *mut XmlDoc {
    let _ = cur;
    std::ptr::null_mut()
}

fn xmlReadFd(_fd: i32, _url: &str, _encoding: &str, _options: i32) -> *mut XmlDoc {
    std::ptr::null_mut()
}

fn xmlCtxtReadFile(
    _ctxt: *mut XmlParserCtxt,
    _url: &str,
    _encoding: &str,
    _options: i32,
) -> *mut XmlDoc {
    std::ptr::null_mut()
}

fn xmlCtxtReadDoc(
    _ctxt: *mut XmlParserCtxt,
    cur: &str,
    _url: &str,
    _encoding: &str,
    _options: i32,
) -> *mut XmlDoc {
    let _ = cur;
    std::ptr::null_mut()
}

fn xmlCtxtReadMemory(
    _ctxt: *mut XmlParserCtxt,
    buffer: &str,
    _size: i32,
    _url: &str,
    _encoding: &str,
    _options: i32,
) -> *mut XmlDoc {
    let _ = buffer;
    std::ptr::null_mut()
}

fn xmlCtxtUseOptions(_ctxt: *mut XmlParserCtxt, _options: i32) -> i32 {
    0
}

// --- BAD: user-controlled XML with unsafe parser options ---

fn test_xml_parse_noent(user_xml: &str) {
    // BAD: XML_PARSE_NOENT enables external entity substitution
    xmlReadMemory(user_xml, user_xml.len() as i32, "", "", XML_PARSE_NOENT); // $ Alert[rust/xxe]
}

fn test_xml_parse_dtdload(user_xml: &str) {
    // BAD: XML_PARSE_DTDLOAD enables loading of external DTD subsets
    xmlReadMemory(user_xml, user_xml.len() as i32, "", "", XML_PARSE_DTDLOAD); // $ Alert[rust/xxe]
}

fn test_xml_parse_combined(user_xml: &str) {
    // BAD: combining both unsafe options
    xmlReadMemory(user_xml, user_xml.len() as i32, "", "", XML_PARSE_NOENT | XML_PARSE_DTDLOAD); // $ Alert[rust/xxe]
}

fn test_xml_read_file_bad(user_filename: &str) {
    // BAD: user-controlled filename with XML_PARSE_NOENT
    xmlReadFile(user_filename, "", XML_PARSE_NOENT); // $ Alert[rust/xxe]
}

fn test_xml_read_doc_bad(user_xml: &str) {
    // BAD: user-controlled XML document with XML_PARSE_DTDLOAD
    xmlReadDoc(user_xml, "", "", XML_PARSE_DTDLOAD); // $ Alert[rust/xxe]
}

fn test_xml_ctxt_read_doc_bad(user_xml: &str) {
    // BAD: user-controlled XML with unsafe options via ctxt variant
    xmlCtxtReadDoc(std::ptr::null_mut(), user_xml, "", "", XML_PARSE_NOENT); // $ Alert[rust/xxe]
}

fn test_xml_ctxt_read_memory_bad(user_xml: &str) {
    // BAD: user-controlled XML with unsafe options via ctxt variant
    xmlCtxtReadMemory(
        std::ptr::null_mut(),
        user_xml, // $ Alert[rust/xxe]
        user_xml.len() as i32,
        "",
        "",
        XML_PARSE_NOENT,
    );
}

fn test_integer_literal_bad(user_xml: &str) {
    // BAD: literal value 2 = XML_PARSE_NOENT
    xmlReadMemory(user_xml, user_xml.len() as i32, "", "", 2); // $ Alert[rust/xxe]
}

// --- GOOD: user-controlled XML with safe parser options ---

fn test_xml_parse_safe_options(user_xml: &str) {
    // GOOD: options = 0 means no entity expansion
    xmlReadMemory(user_xml, user_xml.len() as i32, "", "", 0);
    xmlReadFile(user_xml, "", 0);
    xmlReadDoc(user_xml, "", "", 0);
}

// --- GOOD: hardcoded (non-user-controlled) XML with unsafe parser options ---

fn test_xml_hardcoded_unsafe() {
    let xml = "<root/>";
    // GOOD: XML content is not user-controlled
    xmlReadMemory(xml, xml.len() as i32, "", "", XML_PARSE_NOENT);
    xmlReadFile("trusted/input.xml", "", XML_PARSE_NOENT);
}

fn main() {
    let user_xml = std::env::args().nth(1).unwrap_or_default(); // $ Source
    let user_filename = std::env::args().nth(2).unwrap_or_default(); // $ Source

    test_xml_parse_noent(&user_xml);
    test_xml_parse_dtdload(&user_xml);
    test_xml_parse_combined(&user_xml);
    test_xml_read_file_bad(&user_filename);
    test_xml_read_doc_bad(&user_xml);
    test_xml_ctxt_read_doc_bad(&user_xml);
    test_xml_ctxt_read_memory_bad(&user_xml);
    test_integer_literal_bad(&user_xml);
    test_xml_parse_safe_options(&user_xml);
    test_xml_hardcoded_unsafe();
}
