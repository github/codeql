use crate::config::Compression;
use crate::{config, generated};
use codeql_extractor::{extractor, file_paths, trap};
use log::debug;
use ra_ap_ide_db::line_index::LineCol;
use std::fmt::Debug;
use std::hash::Hash;
use std::marker::PhantomData;
use std::path::{Path, PathBuf};

pub use trap::Label as UntypedLabel;
pub use trap::Writer;

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

pub trait TrapClass {
    fn class_name() -> &'static str;
}

pub trait TrapEntry: Debug + Sized + TrapClass {
    fn extract_id(&mut self) -> TrapId<Self>;
    fn emit(self, id: Label<Self>, out: &mut Writer);
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
pub struct Label<T: TrapClass> {
    untyped: UntypedLabel,
    phantom: PhantomData<T>, // otherwise Rust wants `T` to be used
}

// not deriving `Clone` and `Copy` because they require `T: Clone` and `T: Copy` respectively,
// even if `T` is not actually part of the fields.
// see https://github.com/rust-lang/rust/issues/108894
impl<T: TrapClass> Clone for Label<T> {
    fn clone(&self) -> Self {
        *self
    }
}

impl<T: TrapClass> Copy for Label<T> {}

impl<T: TrapClass> Label<T> {
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

impl<T: TrapClass> AsTrapKeyPart for Label<T> {
    fn as_key_part(&self) -> String {
        self.as_untyped().as_key_part()
    }
}

impl<T: TrapClass> From<Label<T>> for trap::Arg {
    fn from(value: Label<T>) -> Self {
        trap::Arg::Label(value.as_untyped())
    }
}

pub struct TrapFile {
    path: PathBuf,
    pub writer: Writer,
    compression: Compression,
}

#[derive(Copy, Clone, PartialEq, Eq, PartialOrd, Ord)]
pub enum DiagnosticSeverity {
    Debug = 10,
    Info = 20,
    Warning = 30,
    Error = 40,
}
impl TrapFile {
    pub fn emit_location_label(
        &mut self,
        file_label: Label<generated::File>,
        start: LineCol,
        end: LineCol,
    ) -> UntypedLabel {
        let start_line = 1 + start.line as usize;
        let start_column = 1 + start.col as usize;
        let end_line = 1 + end.line as usize;
        let end_column = 1 + end.col as usize;
        extractor::location_label(
            &mut self.writer,
            trap::Location {
                file_label: file_label.as_untyped(),
                start_line,
                start_column,
                end_line,
                end_column,
            },
        )
    }
    pub fn emit_location<E: TrapClass>(
        &mut self,
        file_label: Label<generated::File>,
        entity_label: Label<E>,
        start: LineCol,
        end: LineCol,
    ) {
        let location_label = self.emit_location_label(file_label, start, end);
        self.writer.add_tuple(
            "locatable_locations",
            vec![entity_label.into(), location_label.into()],
        );
    }

    pub fn emit_diagnostic(
        &mut self,
        severity: DiagnosticSeverity,
        error_tag: String,
        error_message: String,
        full_error_message: String,
        location: UntypedLabel,
    ) {
        let label = self.writer.fresh_id();
        self.writer.add_tuple(
            "diagnostics",
            vec![
                trap::Arg::Label(label),
                trap::Arg::Int(severity as usize),
                trap::Arg::String(error_tag),
                trap::Arg::String(error_message),
                trap::Arg::String(full_error_message),
                trap::Arg::Label(location),
            ],
        );
    }
    pub fn emit_file(&mut self, absolute_path: &Path) -> Label<generated::File> {
        let untyped = extractor::populate_file(&mut self.writer, absolute_path);
        // SAFETY: populate_file emits `@file` typed labels
        unsafe { Label::from_untyped(untyped) }
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

    pub fn create(&self, category: &str, key: impl AsRef<Path>) -> TrapFile {
        let path = file_paths::path_for(&self.trap_dir.join(category), key.as_ref(), "trap");
        debug!("creating trap file {}", path.display());
        let mut writer = trap::Writer::new();
        extractor::populate_empty_location(&mut writer);
        TrapFile {
            path,
            writer,
            compression: self.compression,
        }
    }
}
