use crate::config::Compression;
use crate::{config, path};
use codeql_extractor::{extractor, trap};
use log::debug;
use ra_ap_ide_db::line_index::LineCol;
use std::ffi::OsString;
use std::fmt::Debug;
use std::hash::Hash;
use std::marker::PhantomData;
use std::path::{Path, PathBuf};

pub use trap::Label as UntypedLabel;
pub use trap::Writer;

//TODO: typed labels
pub trait AsTrapKeyPart {
    fn as_key_part(&self) -> String;
}

impl AsTrapKeyPart for UntypedLabel {
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
pub enum TrapId<T: TrapEntry> {
    Star,
    Key(String),
    Label(Label<T>),
}

impl<T: TrapEntry> From<String> for TrapId<T> {
    fn from(value: String) -> Self {
        TrapId::Key(value)
    }
}

impl<T: TrapEntry> From<&str> for TrapId<T> {
    fn from(value: &str) -> Self {
        TrapId::Key(value.into())
    }
}

impl<T: TrapEntry> From<Label<T>> for TrapId<T> {
    fn from(value: Label<T>) -> Self {
        Self::Label(value)
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

#[derive(Debug, Ord, PartialOrd, Eq, PartialEq, Hash)]
pub struct Label<T: TrapEntry> {
    untyped: UntypedLabel,
    phantom: PhantomData<T>, // otherwise Rust wants `T` to be used
}

// not deriving `Clone` and `Copy` because they require `T: Clone` and `T: Copy` respectively,
// even if `T` is not actually part of the fields.
// see https://github.com/rust-lang/rust/issues/108894
impl<T: TrapEntry> Clone for Label<T> {
    fn clone(&self) -> Self {
        *self
    }
}

impl<T: TrapEntry> Copy for Label<T> {}

impl<T: TrapEntry> Label<T> {
    pub fn as_untyped(&self) -> UntypedLabel {
        self.untyped
    }

    /// # Safety
    /// The user must make sure the label respects TRAP typing
    pub unsafe fn from_untyped(untyped: UntypedLabel) -> Self {
        Self {
            untyped,
            phantom: PhantomData,
        }
    }
}

impl<T: TrapEntry> AsTrapKeyPart for Label<T> {
    fn as_key_part(&self) -> String {
        self.as_untyped().as_key_part()
    }
}

impl<T: TrapEntry> From<Label<T>> for trap::Arg {
    fn from(value: Label<T>) -> Self {
        trap::Arg::Label(value.as_untyped())
    }
}

pub trait TrapEntry: std::fmt::Debug + Sized {
    fn class_name() -> &'static str;
    fn extract_id(&mut self) -> TrapId<Self>;
    fn emit(self, id: Label<Self>, out: &mut Writer);
}

pub struct TrapFile {
    path: PathBuf,
    writer: Writer,
    compression: Compression,
}

impl TrapFile {
    pub fn emit_location<T: TrapEntry>(
        &mut self,
        file_label: UntypedLabel,
        entity_label: Label<T>,
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
            vec![entity_label.into(), location_label.into()],
        );
    }

    pub fn emit_file(&mut self, absolute_path: &Path) -> trap::Label {
        extractor::populate_file(&mut self.writer, absolute_path)
    }

    pub fn label<T: TrapEntry>(&mut self, id: TrapId<T>) -> Label<T> {
        match id {
            TrapId::Star => {
                let untyped = self.writer.fresh_id();
                // SAFETY: a `*` trap id is always safe for typing
                unsafe { Label::from_untyped(untyped) }
            }
            TrapId::Key(s) => {
                let untyped = self
                    .writer
                    .global_id(&format!("{},{}", T::class_name(), s))
                    .0;
                // SAFETY: using type names as prefixes avoids labels having a conflicting type
                unsafe { Label::from_untyped(untyped) }
            }
            TrapId::Label(l) => l,
        }
    }

    pub fn emit<T: TrapEntry>(&mut self, mut e: T) -> Label<T> {
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
