use std::fmt::Formatter;
use std::fs::File;
use std::io::Write;
use std::path::{PathBuf};

#[derive(Debug)]
struct TrapLabel(u64);

impl std::fmt::Display for TrapLabel {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        write!(f, "#{:x}", self.0)
    }
}

trait TrapEntry: std::fmt::Display {}

#[derive(Debug)]
struct TrapFile {
    label_index: u64,
    file: File,
}

impl TrapFile {
    pub fn new(path: &PathBuf) -> std::io::Result<TrapFile> {
        let file = File::create(path)?;
        Ok(TrapFile {
            label_index: 0,
            file: file,
        })
    }

    pub fn insert_comment(&mut self, comment: &str) -> std::io::Result<()> {
        write!(self.file, "/* {comment} */\n")
    }

    pub fn allocate_label(&mut self) -> std::io::Result<TrapLabel> {
        let ret = TrapLabel(self.label_index);
        write!(self.file, "{ret}=*\n")?;
        self.label_index += 1;
        Ok(ret)
    }

    pub fn allocate_label_for(&mut self, key: &str) -> std::io::Result<TrapLabel> {
        let ret = TrapLabel(self.label_index);
        write!(self.file, "{ret}=\"{}\"\n", key.replace("\"", "\"\""))?;
        self.label_index += 1;
        Ok(ret)
    }

    pub fn emit<T: TrapEntry>(&mut self, entry: T) -> std::io::Result<()> {
        write!(self.file, "{entry}\n")
    }
}
