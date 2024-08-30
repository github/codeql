use std::collections::HashMap;
use std::fs;
use std::path::{PathBuf};
use crate::trap::{TrapFile, TrapId, TrapLabel};
use crate::{generated, trap_key};
use ra_ap_hir::{Crate, Module, ModuleDef};
use anyhow;
use ra_ap_base_db::{CrateId};
use ra_ap_hir::{HasSource};
use ra_ap_vfs::{AbsPath, FileId, Vfs};
use ra_ap_syntax::ast::HasName;
use crate::archive::Archiver;
use std::io::Result;
use triomphe::Arc;
use ra_ap_ide_db::{LineIndexDatabase, RootDatabase};
use ra_ap_ide_db::line_index::LineIndex;
use ra_ap_syntax::AstNode;

#[derive(Clone)]
struct FileData {
    label: TrapLabel,
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

    fn emit_file(&mut self, file_id: FileId) -> Result<Option<FileData>> {
        if let Some(abs_path) = self.vfs.file_path(file_id).as_path() {
            let mut canonical = PathBuf::from(abs_path.as_str());
            if !self.file_labels.contains_key(&canonical) {
                self.archiver.archive(&canonical);
                canonical = fs::canonicalize(&canonical).unwrap_or(canonical);
                let name = canonical.to_string_lossy();
                let label = self.trap.emit(generated::DbFile { id: trap_key!["DbFile@", name.as_ref()], name: String::from(name) })?;
                let line_index = <dyn LineIndexDatabase>::line_index(self.db, file_id);
                self.file_labels.insert(canonical.clone(), FileData { label, line_index });
            }
            Ok(self.file_labels.get(&canonical).cloned())
        } else {
            Ok(None)
        }
    }

    fn emit_location<T: HasSource>(&mut self, entity: T) -> Result<Option<TrapLabel>> where T::Ast: AstNode {
        if let Some(source) = entity.source(self.db) {
            if let Some(file_id) = source.file_id.file_id().map(|f| f.file_id()) {
                if let Some(data) =  self.emit_file(file_id)? {
                    let range = source.value.syntax().text_range();
                    let start = data.line_index.line_col(range.start());
                    let end = data.line_index.line_col(range.end());
                    return Ok(Some(self.trap.emit(generated::DbLocation {
                        id: trap_key![data.label, ":", start.line, ":", start.col, ":", end.line, ":", end.col],
                        file: data.label,
                        start_line: start.line,
                        start_column: start.col,
                        end_line: end.line,
                        end_column: end.col,
                    })?));
                }
            }
        }
        Ok(None)
    }

    fn emit_definition(&mut self, module_label: TrapLabel, id: ModuleDef, labels: &mut Vec<TrapLabel>) -> Result<()> {
        match id {
            ModuleDef::Module(_) => {}
            ModuleDef::Function(function) => {
                let name = function.name(self.db);
                let location = self.emit_location(function)?;
                labels.push(self.trap.emit(generated::Function {
                    id: trap_key![module_label, name.as_str()],
                    location,
                    name: name.as_str().into(),
                })?);
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
        Ok(())
    }

    fn emit_module(&mut self, label: TrapLabel, module: Module) -> Result<()> {
        let mut children = Vec::new();
        for id in module.declarations(self.db) {
            self.emit_definition(label, id, &mut children)?;
        }
        self.trap.emit(generated::Module {
            id: label.into(),
            location: None,
            declarations: children,
        })?;
        Ok(())
    }

    pub fn emit_crate(&mut self) -> Result<()> {
        self.emit_file(self.krate.root_file(self.db))?;
        let mut map = HashMap::<Module, TrapLabel>::new();
        for module in self.krate.modules(self.db) {
            let mut key = String::new();
            if let Some(parent) = module.parent(self.db) {
                // assumption: parent was already listed
                let parent_label = *map.get(&parent).unwrap();
                key.push_str(&parent_label.as_key_part());
            }
            let def = module.definition_source(self.db);
            if let Some(file) = def.file_id.file_id() {
                if let Some(data) = self.emit_file(file.file_id())? {
                    key.push_str(&data.label.as_key_part());
                }
            }
            if let Some(name) = module.name(self.db) {
                key.push_str(name.as_str());
            }
            let label = self.trap.label(TrapId::Key(key))?;
            map.insert(module, label);
            self.emit_module(label, module)?;
        }
        Ok(())
    }
}
