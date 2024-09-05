use crate::archive::Archiver;
use crate::trap::{AsTrapKeyPart, TrapFile, TrapId};
use crate::{generated, trap_key};
use anyhow;
use codeql_extractor::trap;
use ra_ap_hir::HasSource;
use ra_ap_hir::{Crate, Module, ModuleDef};
use ra_ap_ide_db::line_index::LineIndex;
use ra_ap_ide_db::{LineIndexDatabase, RootDatabase};
use ra_ap_syntax::ast::HasName;
use ra_ap_syntax::AstNode;
use ra_ap_vfs::{AbsPath, FileId, Vfs};
use std::collections::HashMap;
use std::fs;
use std::io::Result;
use std::path::PathBuf;
use triomphe::Arc;

#[derive(Clone)]
struct FileData {
    label: trap::Label,
    line_index: Arc<LineIndex>,
}
pub struct CrateTranslator<'a> {
    db: &'a RootDatabase,
    trap: TrapFile,
    krate: &'a Crate,
    vfs: &'a Vfs,
    archiver: &'a Archiver,
    file_labels: HashMap<PathBuf, FileData>,
}

impl CrateTranslator<'_> {
    pub fn new<'a>(
        db: &'a RootDatabase,
        trap: TrapFile,
        krate: &'a Crate,
        vfs: &'a Vfs,
        archiver: &'a Archiver,
    ) -> CrateTranslator<'a> {
        CrateTranslator {
            db,
            trap,
            krate,
            vfs,
            archiver,
            file_labels: HashMap::new(),
        }
    }

    fn emit_file(&mut self, file_id: FileId) -> Option<FileData> {
        self.vfs.file_path(file_id).as_path().and_then(|abs_path| {
            let mut canonical = PathBuf::from(abs_path.as_str());
            if !self.file_labels.contains_key(&canonical) {
                self.archiver.archive(&canonical);
                canonical = fs::canonicalize(&canonical).unwrap_or(canonical);
                let name = canonical.to_string_lossy();
                let label = self.trap.emit(generated::DbFile {
                    id: trap_key!["file;", name.as_ref()],
                    name: String::from(name),
                });
                let line_index = <dyn LineIndexDatabase>::line_index(self.db, file_id);
                self.file_labels
                    .insert(canonical.clone(), FileData { label, line_index });
            }
            self.file_labels.get(&canonical).cloned()
        })
    }

    fn emit_location<T: HasSource>(&mut self, entity: T) -> Option<trap::Label>
    where
        T::Ast: AstNode,
    {
        entity
            .source(self.db)
            .and_then(|source| source.file_id.file_id().map(|f| (f.file_id(), source)))
            .and_then(|(file_id, source)| self.emit_file(file_id).map(|data| (data, source)))
            .and_then(|(data, source)| {
                let range = source.value.syntax().text_range();
                let start = data.line_index.line_col(range.start());
                let end = data.line_index.line_col(range.end());
                Some(self.trap.emit_location(data.label, start, end))
            })
    }

    fn emit_definition(
        &mut self,
        module_label: trap::Label,
        id: ModuleDef,
        labels: &mut Vec<trap::Label>,
    ) {
        match id {
            ModuleDef::Module(_) => {}
            ModuleDef::Function(function) => {
                let name = function.name(self.db);
                let location = self.emit_location(function);
                labels.push(self.trap.emit(generated::Function {
                    id: trap_key![module_label, name.as_str()],
                    location,
                    name: name.as_str().into(),
                }));
            }
            ModuleDef::Adt(_) => {}
            ModuleDef::Variant(_) => {}
            ModuleDef::Const(_) => {}
            ModuleDef::Static(_) => {}
            ModuleDef::Trait(_) => {}
            ModuleDef::TraitAlias(_) => {}
            ModuleDef::TypeAlias(_) => {}
            ModuleDef::BuiltinType(_) => {}
            ModuleDef::Macro(_) => {}
        }
    }

    fn emit_module(&mut self, label: trap::Label, module: Module) {
        let mut children = Vec::new();
        for id in module.declarations(self.db) {
            self.emit_definition(label, id, &mut children);
        }
        self.trap.emit(generated::Module {
            id: label.into(),
            location: None,
            declarations: children,
        });
    }

    pub fn emit_crate(&mut self) -> std::io::Result<()> {
        self.emit_file(self.krate.root_file(self.db));
        let mut map = HashMap::<Module, trap::Label>::new();
        for module in self.krate.modules(self.db) {
            let mut key = String::new();
            if let Some(parent) = module.parent(self.db) {
                // assumption: parent was already listed
                let parent_label = *map.get(&parent).unwrap();
                key.push_str(&parent_label.as_key_part());
            }
            let def = module.definition_source(self.db);
            if let Some(file) = def.file_id.file_id() {
                if let Some(data) = self.emit_file(file.file_id()) {
                    key.push_str(&data.label.as_key_part());
                }
            }
            if let Some(name) = module.name(self.db) {
                key.push_str(name.as_str());
            }
            let label = self.trap.label(TrapId::Key(key));
            map.insert(module, label);
            self.emit_module(label, module);
        }
        self.trap.commit()
    }
}
