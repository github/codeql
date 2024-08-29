use std::fmt::{Debug, Display, Formatter};
use std::fs::File;
use std::io::Write;
use std::path::{Path, PathBuf};
use log::{debug, trace};
use crate::{config, path};

#[derive(Debug, Clone, Copy)]
pub struct TrapLabel(u64);

impl Display for TrapLabel {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        write!(f, "#{:x}", self.0)
    }
}

//TODO: typed labels

#[derive(Debug, Clone)]
pub enum KeyPart {
    Label(TrapLabel),
    Text(String),
}

impl From<String> for KeyPart {
    fn from(value: String) -> Self {
        KeyPart::Text(value)
    }
}

impl From<&str> for KeyPart {
    fn from(value: &str) -> Self {
        KeyPart::Text(value.into())
    }
}

impl From<TrapLabel> for KeyPart {
    fn from(value: TrapLabel) -> Self {
        KeyPart::Label(value)
    }
}

#[derive(Debug, Clone)]
pub enum TrapId {
    Star,
    Key(Vec<KeyPart>),
    Label(TrapLabel),
}

impl<T: Into<KeyPart>> From<T> for TrapId {
    fn from(value: T) -> Self {
        TrapId::Key(vec![value.into()])
    }
}

#[macro_export]
macro_rules! trap_key {
    ($($x:expr),+ $(,)?) => (
        $crate::trap::TrapId::Key(vec![$($x.into()),+])
    );
}

impl Display for TrapId {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        match self {
            TrapId::Star => write!(f, "*"),
            TrapId::Key(k) => {
                f.write_str("@\"")?;
                for p in k {
                    match p {
                        KeyPart::Label(l) => write!(f, "{{{l}}}")?,
                        KeyPart::Text(s) => f.write_str(&escaped(s))?,
                    }
                }
                f.write_str("\"")
            }
            TrapId::Label(l) => Display::fmt(&l, f)
        }
    }
}

pub fn escaped(s: &str) -> String {
    s.replace("\"", "\"\"")
}

pub fn quoted(s: &str) -> String {
    format!("\"{}\"", escaped(s))
}


pub trait TrapEntry: std::fmt::Debug {
    fn extract_id(&mut self) -> TrapId;
    fn emit<W: Write>(self, id: TrapLabel, out: &mut W) -> std::io::Result<()>;
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

    pub fn label(&mut self, id: TrapId) -> std::io::Result<TrapLabel> {
        if let TrapId::Label(l) = id {
            return Ok(l);
        }
        let ret = self.create_label();
        trace!("emit -> {}: {ret:?} = {id:?}", self.trap_name);
        write!(self.file, "{ret}={id}\n")?;
        Ok(ret)
    }

    pub fn emit<T: TrapEntry>(&mut self, mut entry: T) -> std::io::Result<TrapLabel> {
        trace!("emit -> {}: {entry:?}", self.trap_name);
        let id = self.label(entry.extract_id())?;
        entry.emit(id, &mut self.file)?;
        Ok(id)
    }

    fn create_label(&mut self) -> TrapLabel {
        let ret = TrapLabel(self.label_index);
        self.label_index += 1;
        ret
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
