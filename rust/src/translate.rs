use crate::trap::TrapFile;
use ra_ap_hir::{ModuleDefId, db::{DefDatabase, ExpandDatabase}, AdtId::{EnumId, UnionId, StructId}};
use ra_ap_ide_db::RootDatabase;
use anyhow;
use ra_ap_ide_db::base_db::Upcast;

struct Translator<'a> {
    pub db: &'a dyn DefDatabase,
    pub trap: TrapFile,
}

impl Translator<'_> {
    pub fn emit_definition(&mut self, id: &ModuleDefId) -> anyhow::Result<()> {
        match id {
            ModuleDefId::FunctionId(id) => {
                let function = self.db.function_data(*id);
                let name = format!("{}", function.name.display(self.db.upcast()));
                println!("function {name}");
            }
            // ModuleDefId::AdtId(StructId(id)) => {
            //     let s = self.db.struct_data(*id);
            //     println!("    Struct: {:?}", s);
            // }
            // ModuleDefId::AdtId(EnumId(id)) => {
            //     let e = self.db.enum_data(*id);
            //     println!("    Enum: {:?}", e);
            // }
            // ModuleDefId::AdtId(UnionId(id)) => {
            //     let u = self.db.union_data(*id);
            //     println!("    Union: {:?}", u);
            // }
            _ => {}
        }
        Ok(())
    }
}
