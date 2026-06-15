pub mod grammar;
pub fn reformat(x: String) -> String {
    x
}

pub fn add_preamble(_x: crate::flags::CodegenType, y: String) -> String {
    y
}
pub fn ensure_file_contents(
    _x: crate::flags::CodegenType,
    path: &std::path::Path,
    contents: &String,
    _check: bool,
) {
    std::fs::write(path, contents).unwrap_or_else(|_| panic!("Unable to write {}", path.display()));
}
