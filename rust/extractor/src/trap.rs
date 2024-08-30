use std::ffi::OsString;
use std::fmt::{Debug, Display, Formatter};
use std::fs::File;
use std::io::Write;
use std::path::{Path, PathBuf};
use log::{debug, trace};
use crate::{config, path};

#[derive(Clone, Copy)]
pub struct TrapLabel(u64);

impl Debug for TrapLabel {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        write!(f, "TrapLabel({:x})", self.0)
    }
}

impl Display for TrapLabel {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        write!(f, "#{:x}", self.0)
    }
}

//TODO: typed labels

impl TrapLabel {
    pub fn as_key_part(&self) -> String {
        format!("{{{}}}", self)
    }
}

#[derive(Debug, Clone)]
pub enum TrapId {
    Star,
    Key(String),
    Label(TrapLabel),
}

impl From<String> for TrapId {
    fn from(value: String) -> Self {
        TrapId::Key(value)
    }
}

impl From<&str> for TrapId {
    fn from(value: &str) -> Self {
        TrapId::Key(value.into())
    }
}

impl From<TrapLabel> for TrapId {
    fn from(value: TrapLabel) -> Self {
        TrapId::Label(value)
    }
}

#[macro_export]
macro_rules! trap_key {
    ($($x:expr),+ $(,)?) => {{
        trait BlanketKeyPart: std::fmt::Display {
            fn as_key_part(&self) -> String {
                format!("{}", self)
            }
        }
        impl<T: std::fmt::Display> BlanketKeyPart for T {}
        let mut key = String::new();
        $(
            key.push_str(&$x.as_key_part());
        )*
        $crate::TrapId::Key(key)
    }};
}

impl Display for TrapId {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        match self {
            TrapId::Star => write!(f, "*"),
            TrapId::Key(k) => write!(f, "@{}", quoted(k)),
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

    pub fn label(&mut self, mut id: TrapId) -> std::io::Result<TrapLabel> {
        match id {
            TrapId::Star => {}
            TrapId::Key(ref s) => {
                if s.is_empty() {
                    id = TrapId::Star;
                }
            }
            TrapId::Label(l) => {
                return Ok(l);
            }
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
        path.set_extension(path.extension().map(|e| {
            let mut o : OsString = e.to_owned();
            o.push(".trap");
            o
        }).unwrap_or("trap".into()));
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
