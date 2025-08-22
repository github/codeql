use std::fmt::Display;

pub enum CodegenType {
    Grammar,
}

impl Display for CodegenType {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "Grammar")
    }
}
