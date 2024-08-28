use std::fmt::{Debug, Display, Formatter};
use std::fs::File;
use std::io::Write;
use std::path::{Path, PathBuf};
use log::{debug, trace};
use crate::{config, path};

#[derive(Debug, Clone, Copy)]
pub struct TrapLabel(u64);

//TODO: typed labels

impl From<u64> for TrapLabel {
    fn from(value: u64) -> Self {
        TrapLabel(value)
    }
}

pub fn escaped(s: &str) -> String {
    s.replace("\"", "\"\"")
}

pub fn quoted(s: &str) -> String {
    format!("\"{}\"", escaped(s))
}

impl Display for TrapLabel {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        write!(f, "#{:x}", self.0)
    }
}

pub trait TrapEntry: std::fmt::Debug {
    type Label: Display + From<u64>;

    fn prefix() -> &'static str { "" }

    fn key(&self) -> Option<&str>;

    fn emit<W: Write>(&self, id: &Self::Label, out: &mut W) -> std::io::Result<()>;
}

#[derive(Debug)]
pub struct TrapFile {
    label_index: u64,
    file: File,
    trap_name: String,
}

impl TrapFile {
    pub fn comment(&mut self, message: &str) -> std::io::Result<()> {
        for part in message.split("\n") {
            trace!("emit -> {}: // {part}", self.trap_name);
            write!(self.file, "// {part}\n")?;
        }
        Ok(())
    }

    pub fn emit<T: TrapEntry>(&mut self, entry: T) -> std::io::Result<T::Label> {
        let ret = match entry.key() {
            None => self.create_star_label::<T>()?,
            Some(key) => self.create_key_label::<T>(key)?,
        };
        trace!("emit -> {}: {entry:?}", self.trap_name);
        entry.emit(&ret, &mut self.file)?;
        Ok(ret)
    }

    fn create_star_label<T: TrapEntry>(&mut self) -> std::io::Result<T::Label> {
        let ret = T::Label::from(self.label_index);
        write!(self.file, "{ret}=*\n")?;
        self.label_index += 1;
        Ok(ret)
    }

    fn create_key_label<T: TrapEntry>(&mut self, key: &str) -> std::io::Result<T::Label> {
        let ret = T::Label::from(self.label_index);
        write!(self.file, "{ret}=@\"{}{}\"\n", T::prefix(), escaped(key))?;
        self.label_index += 1;
        Ok(ret)
    }
}

pub struct TrapFileProvider {
    trap_dir: PathBuf,
}

impl TrapFileProvider {
    pub fn new(cfg: &config::Config) -> std::io::Result<TrapFileProvider> {
        let trap_dir = cfg.trap_dir.clone();
        std::fs::create_dir_all(&trap_dir)?;
        Ok(TrapFileProvider {
            trap_dir
        })
    }

    pub fn create(&self, category: &str, key: &Path) -> std::io::Result<TrapFile> {
        let mut path = PathBuf::from(category);
        path.push(path::key(key));
        path.add_extension("trap");
        let trap_name = String::from(path.to_string_lossy());
        debug!("creating trap file {}", trap_name);
        path = self.trap_dir.join(path);
        std::fs::create_dir_all(path.parent().unwrap())?;
        let file = File::create(path)?;
        Ok(TrapFile {
            label_index: 0,
            file,
            trap_name,
        })
    }
}
