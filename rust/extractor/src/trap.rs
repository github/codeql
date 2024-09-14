use crate::config::Compression;
use crate::{config, path};
use codeql_extractor::{extractor, trap};
use log::debug;
use ra_ap_ide_db::line_index::LineCol;
use std::ffi::OsString;
use std::fmt::Debug;
use std::path::{Path, PathBuf};

//TODO: typed labels
pub trait AsTrapKeyPart {
    fn as_key_part(&self) -> String;
}

impl AsTrapKeyPart for trap::Label {
    fn as_key_part(&self) -> String {
        format!("{{{}}}", self)
    }
}

impl AsTrapKeyPart for String {
    fn as_key_part(&self) -> String {
        self.clone()
    }
}

impl AsTrapKeyPart for &str {
    fn as_key_part(&self) -> String {
        String::from(*self)
    }
}

#[derive(Debug, Clone)]
pub enum TrapId {
    Star,
    Key(String),
    Label(trap::Label),
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

impl From<trap::Label> for TrapId {
    fn from(value: trap::Label) -> Self {
        TrapId::Label(value)
    }
}

#[macro_export]
macro_rules! trap_key {
    ($($x:expr),+ $(,)?) => {{
        let mut key = String::new();
        $(
            key.push_str(&$x.as_key_part());
        )*
        $crate::TrapId::Key(key)
    }};
}

pub trait TrapEntry: std::fmt::Debug {
    fn extract_id(&mut self) -> TrapId;
    fn emit(self, id: trap::Label, out: &mut trap::Writer);
}

pub struct TrapFile {
    path: PathBuf,
    writer: trap::Writer,
    compression: Compression,
}

impl TrapFile {
    pub fn emit_location(
        &mut self,
        file_label: trap::Label,
        entity_label: trap::Label,
        start: LineCol,
        end: LineCol,
    ) {
        let start_line = 1 + start.line as usize;
        let start_column = 1 + start.col as usize;
        let end_line = 1 + end.line as usize;
        let end_column = 1 + end.col as usize;
        let location_label = extractor::location_label(
            &mut self.writer,
            trap::Location {
                file_label,
                start_line,
                start_column,
                end_line,
                end_column,
            },
        );
        self.writer.add_tuple(
            "locatable_locations",
            vec![
                trap::Arg::Label(entity_label),
                trap::Arg::Label(location_label),
            ],
        );
    }

    pub fn emit_file(&mut self, absolute_path: &Path) -> trap::Label {
        extractor::populate_file(&mut self.writer, absolute_path)
    }

    pub fn label(&mut self, id: TrapId) -> trap::Label {
        match id {
            TrapId::Star => self.writer.fresh_id(),
            TrapId::Key(s) => self.writer.global_id(&s).0,
            TrapId::Label(l) => l,
        }
    }

    pub fn emit<T: TrapEntry>(&mut self, mut e: T) -> trap::Label {
        let label = self.label(e.extract_id());
        e.emit(label, &mut self.writer);
        label
    }

    pub fn commit(&self) -> std::io::Result<()> {
        std::fs::create_dir_all(self.path.parent().unwrap())?;
        self.writer
            .write_to_file(&self.path, self.compression.into())
    }
}

pub struct TrapFileProvider {
    trap_dir: PathBuf,
    compression: Compression,
}

impl TrapFileProvider {
    pub fn new(cfg: &config::Config) -> std::io::Result<TrapFileProvider> {
        let trap_dir = cfg.trap_dir.clone();
        std::fs::create_dir_all(&trap_dir)?;
        Ok(TrapFileProvider {
            trap_dir,
            compression: cfg.compression,
        })
    }

    pub fn create(&self, category: &str, key: &Path) -> TrapFile {
        let mut path = PathBuf::from(category);
        path.push(path::key(key));
        path.set_extension(
            path.extension()
                .map(|e| {
                    let mut o: OsString = e.to_owned();
                    o.push(".trap");
                    o
                })
                .unwrap_or("trap".into()),
        );
        debug!("creating trap file {}", path.display());
        path = self.trap_dir.join(path);
        let mut writer = trap::Writer::new();
        extractor::populate_empty_location(&mut writer);
        TrapFile {
            path,
            writer,
            compression: self.compression,
        }
    }
}
