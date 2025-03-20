use crate::{
    generated::{self},
    trap::{self, TrapFile},
};
use chalk_ir::IntTy;
use chalk_ir::Scalar;
use chalk_ir::UintTy;
use chalk_ir::{FloatTy, Safety};
use itertools::Itertools;
use ra_ap_base_db::CrateGraph;
use ra_ap_base_db::CrateId;
use ra_ap_base_db::SourceDatabase;
use ra_ap_cfg::CfgAtom;
use ra_ap_hir::{DefMap, ModuleDefId, db::HirDatabase};
use ra_ap_hir::{VariantId, Visibility, db::DefDatabase};
use ra_ap_hir_def::{AssocItemId, LocalModuleId, data::adt::VariantData, nameres::ModuleData};
use ra_ap_hir_def::{HasModule, visibility::VisibilityExplicitness};
use ra_ap_hir_def::{ModuleId, resolver::HasResolver};
use ra_ap_hir_ty::TraitRefExt;
use ra_ap_hir_ty::Ty;
use ra_ap_hir_ty::TyExt;
use ra_ap_hir_ty::WhereClause;
use ra_ap_hir_ty::{Binders, FnPointer};
use ra_ap_hir_ty::{Interner, ProjectionTy};
use ra_ap_ide_db::RootDatabase;
use ra_ap_vfs::{Vfs, VfsPath};
use std::hash::Hasher;
use std::{cmp::Ordering, collections::HashMap, path::PathBuf};
use std::{hash::Hash, vec};
use tracing::{debug, error};

pub fn extract_crate_graph(trap_provider: &trap::TrapFileProvider, db: &RootDatabase, vfs: &Vfs) {
    let crate_graph = db.crate_graph();

    // According to the documentation of `CrateGraph`:
    // Each crate is defined by the `FileId` of its root module, the set of enabled
    // `cfg` flags and the set of dependencies.

    // First compute a hash map with for each crate ID, the path to its root module and a hash of all
    // its `cfg` flags and dependencies hashes. Iterate in topological order to ensure hashes of dependencies
    // are present in the map.
    let mut crate_id_map = HashMap::<CrateId, (PathBuf, u64)>::new();
    for krate_id in crate_graph.crates_in_topological_order() {
        let krate = &crate_graph[krate_id];
        let root_module_file: &VfsPath = vfs.file_path(krate.root_file_id);
        if let Some(root_module_file) = root_module_file
            .as_path()
            .map(|p| std::fs::canonicalize(p).unwrap_or(p.into()))
        {
            let mut hasher = std::hash::DefaultHasher::new();
            krate
                .cfg_options
                .as_ref()
                .into_iter()
                .sorted_by(cmp_flag)
                .for_each(|x| format!("{x}").hash(&mut hasher));

            krate
                .dependencies
                .iter()
                .flat_map(|d| crate_id_map.get(&d.crate_id))
                .sorted()
                .for_each(|x| x.hash(&mut hasher));
            let hash = hasher.finish();
            crate_id_map.insert(krate_id, (root_module_file, hash));
        }
    }
    // Extract each crate
    for krate_id in crate_graph.iter() {
        if let Some((root_module_file, hash)) = crate_id_map.get(&krate_id) {
            let path = root_module_file.join(format!("{hash:0>16x}"));
            let mut trap = trap_provider.create("crates", path.as_path());
            // If the trap file already exists, then skip extraction because we have already extracted
            // this crate with the same `cfg` flags and dependencies.
            // FIXME: this may need to b improved in case the implemenation becomes multi-threaded
            if trap.path.exists() {
                continue;
            }
            let krate = &crate_graph[krate_id];
            let root_module = emit_module(
                &crate_graph,
                db,
                db.crate_def_map(krate_id).as_ref(),
                "crate",
                DefMap::ROOT,
                &mut trap,
            );
            let file_label = trap.emit_file(root_module_file);
            trap.emit_file_only_location(file_label, root_module);

            let crate_dependencies: Vec<generated::NamedCrate> = krate
                .dependencies
                .iter()
                .flat_map(|x| crate_id_map.get(&x.crate_id).map(|y| (&x.name, y)))
                .map(|(name, (module, hash))| generated::NamedCrate {
                    id: trap::TrapId::Star,
                    name: name.to_string(),
                    crate_: trap.label(format!("{}:{hash}", module.display()).into()),
                })
                .collect();

            let element = generated::Crate {
                id: trap::TrapId::Key(format!("{}:{hash}", root_module_file.display())),
                name: krate
                    .display_name
                    .as_ref()
                    .map(|x| x.canonical_name().to_string()),
                version: krate.version.to_owned(),
                module: Some(root_module),
                cfg_options: krate
                    .cfg_options
                    .as_ref()
                    .into_iter()
                    .map(|x| format!("{x}"))
                    .collect(),
                named_dependencies: crate_dependencies
                    .into_iter()
                    .map(|dep| trap.emit(dep))
                    .collect(),
            };
            trap.emit(element);
            trap.commit().unwrap_or_else(|err| {
                error!(
                    "Failed to write trap file for crate: {}: {}",
                    root_module_file.display(),
                    err.to_string()
                )
            });
        }
    }
}

fn emit_module(
    crate_graph: &CrateGraph,
    db: &dyn HirDatabase,
    map: &DefMap,
    name: &str,
    module: LocalModuleId,
    trap: &mut TrapFile,
) -> trap::Label<generated::Module> {
    let module = &map.modules[module];
    let mut items = Vec::new();
    items.extend(emit_module_children(crate_graph, db, map, module, trap));
    items.extend(emit_module_items(crate_graph, db, module, trap));
    items.extend(emit_module_impls(crate_graph, db, module, trap));

    let name = trap.emit(generated::Name {
        id: trap::TrapId::Star,
        text: Some(name.to_owned()),
    });
    let item_list = trap.emit(generated::ItemList {
        id: trap::TrapId::Star,
        attrs: vec![],
        items,
    });
    let visibility = emit_visibility(crate_graph, db, trap, module.visibility);
    trap.emit(generated::Module {
        id: trap::TrapId::Star,
        name: Some(name),
        attrs: vec![],
        item_list: Some(item_list),
        visibility,
    })
}

fn emit_module_children(
    crate_graph: &CrateGraph,
    db: &dyn HirDatabase,
    map: &DefMap,
    module: &ModuleData,
    trap: &mut TrapFile,
) -> Vec<trap::Label<generated::Item>> {
    module
        .children
        .iter()
        .sorted_by(|a, b| Ord::cmp(&a.0, &b.0))
        .map(|(name, child)| emit_module(crate_graph, db, map, name.as_str(), *child, trap).into())
        .collect()
}

fn emit_module_items(
    crate_graph: &CrateGraph,
    db: &dyn HirDatabase,
    module: &ModuleData,
    trap: &mut TrapFile,
) -> Vec<trap::Label<generated::Item>> {
    let mut items = Vec::new();
    let item_scope = &module.scope;
    for (name, item) in item_scope.entries() {
        let def = item.filter_visibility(|x| matches!(x, ra_ap_hir::Visibility::Public));
        if let Some(ra_ap_hir_def::per_ns::Item {
            def: value,
            vis,
            import: _,
        }) = def.values
        {
            match value {
                ModuleDefId::FunctionId(function) => {
                    items.extend(emit_function(
                        crate_graph,
                        db,
                        name.as_str(),
                        trap,
                        function,
                        vis,
                    ));
                }
                ModuleDefId::ConstId(konst) => {
                    items.extend(emit_const(crate_graph, db, name.as_str(), trap, konst, vis));
                }
                ModuleDefId::StaticId(statik) => {
                    items.extend(emit_static(
                        crate_graph,
                        db,
                        name.as_str(),
                        trap,
                        statik,
                        vis,
                    ));
                }
                ModuleDefId::EnumVariantId(variant_id) => {
                    items.extend(emit_enum_variant(
                        crate_graph,
                        db,
                        name.as_str(),
                        trap,
                        variant_id,
                        vis,
                    ));
                }
                _ => (),
            }
        }
        if let Some(ra_ap_hir_def::per_ns::Item {
            def: type_id,
            vis,
            import: _,
        }) = def.types
        {
            match type_id {
                ModuleDefId::AdtId(adt_id) => {
                    items.extend(emit_adt(crate_graph, db, name.as_str(), trap, adt_id, vis));
                }
                ModuleDefId::TraitId(trait_id) => {
                    items.extend(emit_trait(
                        crate_graph,
                        db,
                        name.as_str(),
                        trap,
                        trait_id,
                        vis,
                    ));
                }
                _ => (),
            }
        }
    }
    items
}

fn emit_function(
    crate_graph: &CrateGraph,
    db: &dyn HirDatabase,
    name: &str,
    trap: &mut TrapFile,
    function: ra_ap_hir_def::FunctionId,
    visibility: Visibility,
) -> Vec<trap::Label<generated::Item>> {
    let mut items = Vec::new();
    if let Some(type_) = db.value_ty(function.into()) {
        items.push(const_or_function(
            crate_graph,
            db,
            name,
            trap,
            type_,
            visibility,
        ));
    }
    items
}

fn emit_const(
    crate_graph: &CrateGraph,
    db: &dyn HirDatabase,
    name: &str,
    trap: &mut TrapFile,
    konst: ra_ap_hir_def::ConstId,
    visibility: Visibility,
) -> Vec<trap::Label<generated::Item>> {
    let mut items = Vec::new();
    let type_ = db.value_ty(konst.into());
    let type_repr =
        type_.and_then(|type_| emit_hir_ty(trap, crate_graph, db, type_.skip_binders()));
    let name = Some(trap.emit(generated::Name {
        id: trap::TrapId::Star,
        text: Some(name.to_owned()),
    }));
    let konst = db.const_data(konst);
    let visibility = emit_visibility(crate_graph, db, trap, visibility);
    items.push(
        trap.emit(generated::Const {
            id: trap::TrapId::Star,
            name,
            attrs: vec![],
            body: None,
            is_const: true,
            is_default: konst.has_body,
            type_repr,
            visibility,
        })
        .into(),
    );
    items
}

fn emit_static(
    crate_graph: &CrateGraph,
    db: &dyn HirDatabase,
    name: &str,
    trap: &mut TrapFile,
    statik: ra_ap_hir_def::StaticId,
    visibility: Visibility,
) -> Vec<trap::Label<generated::Item>> {
    let mut items = Vec::new();
    let type_ = db.value_ty(statik.into());
    let type_repr =
        type_.and_then(|type_| emit_hir_ty(trap, crate_graph, db, type_.skip_binders()));
    let name = Some(trap.emit(generated::Name {
        id: trap::TrapId::Star,
        text: Some(name.to_owned()),
    }));
    let statik = db.static_data(statik);
    let visibility = emit_visibility(crate_graph, db, trap, visibility);
    items.push(
        trap.emit(generated::Static {
            id: trap::TrapId::Star,
            name,
            attrs: vec![],
            body: None,
            type_repr,
            visibility,
            is_mut: statik.mutable,
            is_static: true,
            is_unsafe: statik.has_unsafe_kw,
        })
        .into(),
    );
    items
}

fn emit_enum_variant(
    crate_graph: &CrateGraph,
    db: &dyn HirDatabase,
    name: &str,
    trap: &mut TrapFile,
    variant_id: ra_ap_hir_def::EnumVariantId,
    visibility: Visibility,
) -> Vec<trap::Label<generated::Item>> {
    let mut items = Vec::new();
    if let Some(type_) = db.value_ty(variant_id.into()) {
        items.push(const_or_function(
            crate_graph,
            db,
            name,
            trap,
            type_,
            visibility,
        ));
    }
    items
}

fn emit_adt(
    crate_graph: &CrateGraph,
    db: &dyn HirDatabase,
    name: &str,
    trap: &mut TrapFile,
    adt_id: ra_ap_hir_def::AdtId,
    visibility: Visibility,
) -> Vec<trap::Label<generated::Item>> {
    let mut items = Vec::new();
    match adt_id {
        ra_ap_hir_def::AdtId::StructId(struct_id) => {
            let name = Some(trap.emit(generated::Name {
                id: trap::TrapId::Star,
                text: Some(name.to_owned()),
            }));
            let field_list = emit_variant_data(trap, crate_graph, db, struct_id.into()).into();
            let visibility = emit_visibility(crate_graph, db, trap, visibility);
            items.push(
                trap.emit(generated::Struct {
                    id: trap::TrapId::Star,
                    name,
                    attrs: vec![],
                    field_list,
                    generic_param_list: None,
                    visibility,
                    where_clause: None,
                })
                .into(),
            );
        }
        ra_ap_hir_def::AdtId::EnumId(enum_id) => {
            let data = db.enum_data(enum_id);
            let variants = data
                .variants
                .iter()
                .map(|(enum_id, name)| {
                    let name = Some(trap.emit(generated::Name {
                        id: trap::TrapId::Star,
                        text: Some(name.as_str().to_owned()),
                    }));
                    let field_list =
                        emit_variant_data(trap, crate_graph, db, (*enum_id).into()).into();
                    let visibility = None;
                    trap.emit(generated::Variant {
                        id: trap::TrapId::Star,
                        name,
                        field_list,
                        attrs: vec![],
                        expr: None,
                        visibility,
                    })
                })
                .collect();
            let variant_list = Some(trap.emit(generated::VariantList {
                id: trap::TrapId::Star,
                variants,
            }));
            let name = Some(trap.emit(generated::Name {
                id: trap::TrapId::Star,
                text: Some(name.to_owned()),
            }));
            let visibility = emit_visibility(crate_graph, db, trap, visibility);
            items.push(
                trap.emit(generated::Enum {
                    id: trap::TrapId::Star,
                    name,
                    attrs: vec![],
                    generic_param_list: None,
                    variant_list,
                    visibility,
                    where_clause: None,
                })
                .into(),
            );
        }
        ra_ap_hir_def::AdtId::UnionId(union_id) => {
            let name = Some(trap.emit(generated::Name {
                id: trap::TrapId::Star,
                text: Some(name.to_owned()),
            }));
            let struct_field_list =
                emit_variant_data(trap, crate_graph, db, union_id.into()).into();
            let visibility = emit_visibility(crate_graph, db, trap, visibility);
            items.push(
                trap.emit(generated::Union {
                    id: trap::TrapId::Star,
                    name,
                    attrs: vec![],
                    struct_field_list,
                    generic_param_list: None,
                    visibility,
                    where_clause: None,
                })
                .into(),
            );
        }
    }
    items
}

fn emit_trait(
    crate_graph: &CrateGraph,
    db: &dyn HirDatabase,
    name: &str,
    trap: &mut TrapFile,
    trait_id: ra_ap_hir_def::TraitId,
    visibility: Visibility,
) -> Vec<trap::Label<generated::Item>> {
    let mut items = Vec::new();
    let data = db.trait_data(trait_id);
    let assoc_items: Vec<trap::Label<generated::AssocItem>> = data
        .items
        .iter()
        .flat_map(|(name, item)| {
            if let AssocItemId::FunctionId(function) = item {
                let sig = db.callable_item_signature((*function).into());
                let sig = sig.skip_binders();
                let params = sig
                    .params()
                    .iter()
                    .map(|p| {
                        let type_repr = emit_hir_ty(trap, crate_graph, db, p);
                        trap.emit(generated::Param {
                            id: trap::TrapId::Star,
                            attrs: vec![],
                            type_repr,
                            pat: None,
                        })
                    })
                    .collect();

                let ret_type = emit_hir_ty(trap, crate_graph, db, sig.ret());
                let param_list = trap.emit(generated::ParamList {
                    id: trap::TrapId::Star,
                    params,
                    self_param: None,
                });
                let ret_type = ret_type.map(|ret_type| {
                    trap.emit(generated::RetTypeRepr {
                        id: trap::TrapId::Star,
                        type_repr: Some(ret_type),
                    })
                });
                let name = Some(trap.emit(generated::Name {
                    id: trap::TrapId::Star,
                    text: Some(name.as_str().to_owned()),
                }));
                let visibility = emit_visibility(crate_graph, db, trap, visibility);
                Some(
                    trap.emit(generated::Function {
                        id: trap::TrapId::Star,
                        name,
                        attrs: vec![],
                        body: None,
                        is_const: false,
                        is_default: false,
                        visibility,
                        abi: None,
                        is_async: false,
                        is_gen: false,
                        is_unsafe: matches!(sig.to_fn_ptr().sig.safety, Safety::Unsafe),
                        generic_param_list: None, //TODO
                        param_list: Some(param_list),
                        ret_type,
                        where_clause: None,
                    })
                    .into(),
                )
            } else {
                None
            }
        })
        .collect();
    let assoc_item_list = Some(trap.emit(generated::AssocItemList {
        id: trap::TrapId::Star,
        assoc_items,
        attrs: vec![],
    }));
    let name = Some(trap.emit(generated::Name {
        id: trap::TrapId::Star,
        text: Some(name.to_owned()),
    }));
    let visibility = emit_visibility(crate_graph, db, trap, visibility);
    items.push(
        trap.emit(generated::Trait {
            id: trap::TrapId::Star,
            name,
            assoc_item_list,
            attrs: vec![],
            generic_param_list: None,
            is_auto: false,
            is_unsafe: false,
            type_bound_list: None,
            visibility,
            where_clause: None,
        })
        .into(),
    );
    items
}

fn emit_module_impls(
    crate_graph: &CrateGraph,
    db: &dyn HirDatabase,
    module: &ModuleData,
    trap: &mut TrapFile,
) -> Vec<trap::Label<generated::Item>> {
    let mut items = Vec::new();
    module.scope.impls().for_each(|imp| {
        let self_ty = db.impl_self_ty(imp);
        let self_ty = emit_hir_ty(trap, crate_graph, db, self_ty.skip_binders());
        let imp = db.impl_data(imp);
        let trait_ = imp
            .target_trait
            .as_ref()
            .and_then(|t| make_qualified_path(trap, emit_hir_path(&imp.types_map[t.path])));
        let trait_ = trait_.map(|trait_| {
            trap.emit(generated::PathTypeRepr {
                id: trap::TrapId::Star,
                path: Some(trait_),
            })
            .into()
        });
        let assoc_items = imp
            .items
            .iter()
            .flat_map(|item| {
                if let (name, AssocItemId::FunctionId(function)) = item {
                    let sig = db.callable_item_signature((*function).into());
                    let sig = sig.skip_binders();
                    let params = sig
                        .params()
                        .iter()
                        .map(|p| {
                            let type_repr = emit_hir_ty(trap, crate_graph, db, p);
                            trap.emit(generated::Param {
                                id: trap::TrapId::Star,
                                attrs: vec![],
                                type_repr,
                                pat: None,
                            })
                        })
                        .collect();

                    let ret_type = emit_hir_ty(trap, crate_graph, db, sig.ret());
                    let param_list = trap.emit(generated::ParamList {
                        id: trap::TrapId::Star,
                        params,
                        self_param: None,
                    });
                    let ret_type = ret_type.map(|ret_type| {
                        trap.emit(generated::RetTypeRepr {
                            id: trap::TrapId::Star,
                            type_repr: Some(ret_type),
                        })
                    });
                    let name = Some(trap.emit(generated::Name {
                        id: trap::TrapId::Star,
                        text: Some(name.as_str().to_owned()),
                    }));
                    let data = db.function_data(*function);
                    let visibility = emit_visibility(
                        crate_graph,
                        db,
                        trap,
                        data.visibility
                            .resolve(db.upcast(), &function.resolver(db.upcast())),
                    );

                    Some(
                        trap.emit(generated::Function {
                            id: trap::TrapId::Star,
                            name,
                            attrs: vec![],
                            body: None,
                            is_const: false,
                            is_default: false,
                            visibility,
                            abi: None,
                            is_async: false,
                            is_gen: false,
                            is_unsafe: matches!(sig.to_fn_ptr().sig.safety, Safety::Unsafe),
                            generic_param_list: None, //TODO
                            param_list: Some(param_list),
                            ret_type,
                            where_clause: None,
                        })
                        .into(),
                    )
                } else {
                    None
                }
            })
            .collect();
        let assoc_item_list = Some(trap.emit(generated::AssocItemList {
            id: trap::TrapId::Star,
            assoc_items,
            attrs: vec![],
        }));
        items.push(
            trap.emit(generated::Impl {
                id: trap::TrapId::Star,
                trait_,
                self_ty,
                assoc_item_list,
                attrs: vec![],
                generic_param_list: None,
                is_const: false,
                is_default: false,
                is_unsafe: false,
                visibility: None,
                where_clause: None,
            })
            .into(),
        );
    });
    items
}

fn emit_visibility(
    crate_graph: &CrateGraph,
    db: &dyn HirDatabase,
    trap: &mut TrapFile,
    visibility: Visibility,
) -> Option<trap::Label<generated::Visibility>> {
    let path = match visibility {
        Visibility::Module(module_id, VisibilityExplicitness::Explicit) => {
            Some(make_path_mod(crate_graph, db.upcast(), module_id))
        }
        Visibility::Public => Some(vec![]),
        Visibility::Module(_, VisibilityExplicitness::Implicit) => None,
    };
    path.map(|path| {
        let path = make_qualified_path(trap, path);
        trap.emit(generated::Visibility {
            id: trap::TrapId::Star,
            path,
        })
    })
}
fn const_or_function(
    crate_graph: &CrateGraph,
    db: &dyn HirDatabase,
    name: &str,
    trap: &mut TrapFile,
    type_: Binders<Ty>,
    visibility: Visibility,
) -> trap::Label<generated::Item> {
    let type_: &chalk_ir::Ty<Interner> = type_.skip_binders();
    match type_.kind(ra_ap_hir_ty::Interner) {
        chalk_ir::TyKind::FnDef(fn_def_id, parameters) => {
            let data = db.fn_def_datum(*fn_def_id);

            let sig = ra_ap_hir_ty::CallableSig::from_def(db, *fn_def_id, parameters);
            let params = sig
                .params()
                .iter()
                .map(|p| {
                    let type_repr = emit_hir_ty(trap, crate_graph, db, p);
                    trap.emit(generated::Param {
                        id: trap::TrapId::Star,
                        attrs: vec![],
                        type_repr,
                        pat: None,
                    })
                })
                .collect();

            let ret_type = emit_hir_ty(trap, crate_graph, db, sig.ret());
            let param_list = trap.emit(generated::ParamList {
                id: trap::TrapId::Star,
                params,
                self_param: None,
            });
            let ret_type = ret_type.map(|ret_type| {
                trap.emit(generated::RetTypeRepr {
                    id: trap::TrapId::Star,
                    type_repr: Some(ret_type),
                })
            });
            let name = Some(trap.emit(generated::Name {
                id: trap::TrapId::Star,
                text: Some(name.to_owned()),
            }));
            let visibility = emit_visibility(crate_graph, db, trap, visibility);
            trap.emit(generated::Function {
                id: trap::TrapId::Star,
                name,
                attrs: vec![],
                body: None,
                is_const: false,
                is_default: false,
                visibility,
                abi: None,
                is_async: false,
                is_gen: false,
                is_unsafe: matches!(data.sig.safety, Safety::Unsafe),
                generic_param_list: None, //TODO
                param_list: Some(param_list),
                ret_type,
                where_clause: None,
            })
            .into()
        }
        _ => {
            let type_repr = emit_hir_ty(trap, crate_graph, db, type_);
            let name = Some(trap.emit(generated::Name {
                id: trap::TrapId::Star,
                text: Some(name.to_owned()),
            }));
            let visibility = emit_visibility(crate_graph, db, trap, visibility);
            trap.emit(generated::Const {
                id: trap::TrapId::Star,
                name,
                attrs: vec![],
                body: None,
                is_const: false,
                is_default: false,
                type_repr,
                visibility,
            })
            .into()
        }
    }
}
fn emit_hir_type_bound(
    crate_graph: &CrateGraph,
    db: &dyn HirDatabase,
    trap: &mut TrapFile,
    type_bound: &Binders<chalk_ir::WhereClause<Interner>>,
) -> Option<trap::Label<generated::TypeBound>> {
    match type_bound.skip_binders() {
        WhereClause::Implemented(trait_ref) => {
            let mut path = make_path(crate_graph, db, trait_ref.hir_trait_id());
            path.push(
                db.trait_data(trait_ref.hir_trait_id())
                    .name
                    .as_str()
                    .to_owned(),
            );
            let path = make_qualified_path(trap, path);
            let type_repr = Some(
                trap.emit(generated::PathTypeRepr {
                    id: trap::TrapId::Star,
                    path,
                })
                .into(),
            );
            Some(trap.emit(generated::TypeBound {
                id: trap::TrapId::Star,
                is_async: false,
                is_const: false,
                lifetime: None,
                type_repr,
                use_bound_generic_args: None,
            }))
        }
        _ => None,
    }
}

fn emit_hir_path(path: &ra_ap_hir_def::path::Path) -> Vec<String> {
    path.segments()
        .iter()
        .map(|x| x.name.as_str().to_owned())
        .collect()
}

fn emit_hir_fn_ptr(
    trap: &mut TrapFile,
    crate_graph: &CrateGraph,
    db: &dyn HirDatabase,
    function: &FnPointer,
) -> trap::Label<generated::FnPtrTypeRepr> {
    let parameters: Vec<_> = function.substitution.0.type_parameters(Interner).collect();

    let (ret_type, params) = parameters.split_last().unwrap();

    let ret_type = emit_hir_ty(trap, crate_graph, db, ret_type);
    let ret_type = Some(trap.emit(generated::RetTypeRepr {
        id: trap::TrapId::Star,
        type_repr: ret_type,
    }));
    let params = params
        .iter()
        .map(|t| {
            let type_repr = emit_hir_ty(trap, crate_graph, db, t);
            trap.emit(generated::Param {
                id: trap::TrapId::Star,
                attrs: vec![],
                type_repr,
                pat: None,
            })
        })
        .collect();
    let param_list = Some(trap.emit(generated::ParamList {
        id: trap::TrapId::Star,
        params,
        self_param: None,
    }));
    let is_unsafe = matches!(function.sig.safety, ra_ap_hir::Safety::Unsafe);
    trap.emit(generated::FnPtrTypeRepr {
        id: trap::TrapId::Star,
        abi: None,
        is_async: false,
        is_const: false,
        is_unsafe,
        ret_type,
        param_list,
    })
}

fn scalar_to_str(scalar: &Scalar) -> &'static str {
    match scalar {
        Scalar::Bool => "bool",
        Scalar::Char => "char",
        Scalar::Int(IntTy::I8) => "i8",
        Scalar::Int(IntTy::I16) => "i16",
        Scalar::Int(IntTy::I32) => "i32",
        Scalar::Int(IntTy::I64) => "i64",
        Scalar::Int(IntTy::I128) => "i128",
        Scalar::Int(IntTy::Isize) => "isize",
        Scalar::Uint(UintTy::U8) => "u8",
        Scalar::Uint(UintTy::U16) => "u16",
        Scalar::Uint(UintTy::U32) => "u32",
        Scalar::Uint(UintTy::U64) => "u64",
        Scalar::Uint(UintTy::U128) => "u128",
        Scalar::Uint(UintTy::Usize) => "usize",
        Scalar::Float(FloatTy::F16) => "f16",
        Scalar::Float(FloatTy::F32) => "f32",
        Scalar::Float(FloatTy::F64) => "f64",
        Scalar::Float(FloatTy::F128) => "f128",
    }
}

fn make_path(crate_graph: &CrateGraph, db: &dyn HirDatabase, item: impl HasModule) -> Vec<String> {
    let db = db.upcast();
    let module = item.module(db);
    make_path_mod(crate_graph, db, module)
}

fn make_path_mod(crate_graph: &CrateGraph, db: &dyn DefDatabase, module: ModuleId) -> Vec<String> {
    let mut path = Vec::new();
    let mut module = module;
    loop {
        if module.is_block_module() {
            path.push("<block>".to_owned());
        } else if let Some(name) = module.name(db).map(|x| x.as_str().to_owned()).or_else(|| {
            module.as_crate_root().and_then(|k| {
                let krate = &crate_graph[k.krate()];
                krate
                    .display_name
                    .as_ref()
                    .map(|x| x.canonical_name().to_string())
            })
        }) {
            path.push(name);
        } else {
            path.push("<unnamed>".to_owned());
        }
        if let Some(parent) = module.containing_module(db) {
            module = parent;
        } else {
            break;
        }
    }
    path.reverse();
    path
}
fn make_qualified_path(
    trap: &mut TrapFile,
    path: Vec<String>,
) -> Option<trap::Label<generated::Path>> {
    fn qualified_path(
        trap: &mut TrapFile,
        qualifier: Option<trap::Label<generated::Path>>,
        name: String,
    ) -> trap::Label<generated::Path> {
        let name_ref = Some(trap.emit(generated::NameRef {
            id: trap::TrapId::Star,
            text: Some(name),
        }));
        let part = Some(trap.emit(generated::PathSegment {
            id: trap::TrapId::Star,
            generic_arg_list: None,
            name_ref,
            parenthesized_arg_list: None,
            ret_type: None,
            return_type_syntax: None,
        }));
        trap.emit(generated::Path {
            id: trap::TrapId::Star,
            qualifier,
            part,
        })
    }
    path.into_iter()
        .fold(None, |q, p| Some(qualified_path(trap, q, p)))
}
fn emit_hir_ty(
    trap: &mut TrapFile,
    crate_graph: &CrateGraph,
    db: &dyn HirDatabase,
    ty: &Ty,
) -> Option<trap::Label<generated::TypeRepr>> {
    match ty.kind(ra_ap_hir_ty::Interner) {
        chalk_ir::TyKind::Never => Some(
            trap.emit(generated::NeverTypeRepr {
                id: trap::TrapId::Star,
            })
            .into(),
        ),

        chalk_ir::TyKind::Placeholder(_index) => Some(
            trap.emit(generated::InferTypeRepr {
                id: trap::TrapId::Star,
            })
            .into(),
        ),

        chalk_ir::TyKind::Tuple(_size, substitution) => {
            let fields = substitution.type_parameters(ra_ap_hir_ty::Interner);
            let fields = fields
                .flat_map(|field| emit_hir_ty(trap, crate_graph, db, &field))
                .collect();

            Some(
                trap.emit(generated::TupleTypeRepr {
                    id: trap::TrapId::Star,
                    fields,
                })
                .into(),
            )
        }
        chalk_ir::TyKind::Raw(mutability, ty) => {
            let type_repr = emit_hir_ty(trap, crate_graph, db, ty);

            Some(
                trap.emit(generated::PtrTypeRepr {
                    id: trap::TrapId::Star,
                    is_mut: matches!(mutability, chalk_ir::Mutability::Mut),
                    is_const: false,
                    type_repr,
                })
                .into(),
            )
        }
        chalk_ir::TyKind::Ref(mutability, _lifetime, ty) => {
            let type_repr = emit_hir_ty(trap, crate_graph, db, ty);
            let lifetime = None; //TODO: ?
            Some(
                trap.emit(generated::RefTypeRepr {
                    id: trap::TrapId::Star,
                    is_mut: matches!(mutability, chalk_ir::Mutability::Mut),
                    lifetime,
                    type_repr,
                })
                .into(),
            )
        }
        chalk_ir::TyKind::Array(ty, _konst) => {
            let element_type_repr = emit_hir_ty(trap, crate_graph, db, ty);
            // TODO: handle array size constant
            Some(
                trap.emit(generated::ArrayTypeRepr {
                    id: trap::TrapId::Star,
                    const_arg: None,
                    element_type_repr,
                })
                .into(),
            )
        }
        chalk_ir::TyKind::Slice(ty) => {
            let type_repr = emit_hir_ty(trap, crate_graph, db, ty);
            Some(
                trap.emit(generated::SliceTypeRepr {
                    id: trap::TrapId::Star,
                    type_repr,
                })
                .into(),
            )
        }

        chalk_ir::TyKind::Adt(adt_id, _substitution) => {
            let mut path = make_path(crate_graph, db, adt_id.0);
            let name = match adt_id.0 {
                ra_ap_hir_def::AdtId::StructId(struct_id) => {
                    db.struct_data(struct_id).name.as_str().to_owned()
                }
                ra_ap_hir_def::AdtId::UnionId(union_id) => {
                    db.union_data(union_id).name.as_str().to_owned()
                }
                ra_ap_hir_def::AdtId::EnumId(enum_id) => {
                    db.enum_data(enum_id).name.as_str().to_owned()
                }
            };
            path.push(name);
            let path = make_qualified_path(trap, path);
            Some(
                trap.emit(generated::PathTypeRepr {
                    id: trap::TrapId::Star,
                    path,
                })
                .into(),
            )
        }
        chalk_ir::TyKind::Scalar(scalar) => {
            let path = make_qualified_path(trap, vec![scalar_to_str(scalar).to_owned()]);
            Some(
                trap.emit(generated::PathTypeRepr {
                    id: trap::TrapId::Star,
                    path,
                })
                .into(),
            )
        }
        chalk_ir::TyKind::Str => {
            let path = make_qualified_path(trap, vec!["str".to_owned()]);
            Some(
                trap.emit(generated::PathTypeRepr {
                    id: trap::TrapId::Star,
                    path,
                })
                .into(),
            )
        }
        chalk_ir::TyKind::Function(fn_pointer) => {
            Some(emit_hir_fn_ptr(trap, crate_graph, db, fn_pointer).into())
        }
        chalk_ir::TyKind::OpaqueType(_, _)
        | chalk_ir::TyKind::Alias(chalk_ir::AliasTy::Opaque(_)) => {
            let bounds = ty
                .impl_trait_bounds(db)
                .iter()
                .flatten()
                .flat_map(|t| emit_hir_type_bound(crate_graph, db, trap, t))
                .collect();
            let type_bound_list = Some(trap.emit(generated::TypeBoundList {
                id: trap::TrapId::Star,
                bounds,
            }));
            Some(
                trap.emit(generated::ImplTraitTypeRepr {
                    id: trap::TrapId::Star,
                    type_bound_list,
                })
                .into(),
            )
        }
        chalk_ir::TyKind::Dyn(dyn_ty) => {
            let bounds = dyn_ty
                .bounds
                .skip_binders()
                .iter(ra_ap_hir_ty::Interner)
                .flat_map(|t| emit_hir_type_bound(crate_graph, db, trap, t))
                .collect();
            let type_bound_list = Some(trap.emit(generated::TypeBoundList {
                id: trap::TrapId::Star,
                bounds,
            }));
            Some(
                trap.emit(generated::DynTraitTypeRepr {
                    id: trap::TrapId::Star,
                    type_bound_list,
                })
                .into(),
            )
        }
        chalk_ir::TyKind::FnDef(fn_def_id, parameters) => {
            let sig = ra_ap_hir_ty::CallableSig::from_def(db, *fn_def_id, parameters);
            Some(emit_hir_fn_ptr(trap, crate_graph, db, &sig.to_fn_ptr()).into())
        }

        chalk_ir::TyKind::Alias(chalk_ir::AliasTy::Projection(ProjectionTy {
            associated_ty_id,
            substitution: _,
        }))
        | chalk_ir::TyKind::AssociatedType(associated_ty_id, _) => {
            let assoc_ty_data = db.associated_ty_data(*associated_ty_id);

            let _name = db
                .type_alias_data(assoc_ty_data.name)
                .name
                .as_str()
                .to_owned();

            let trait_ref = ra_ap_hir_ty::TraitRef {
                trait_id: assoc_ty_data.trait_id,
                substitution: assoc_ty_data.binders.identity_substitution(Interner),
            };
            let mut trait_path = make_path(crate_graph, db, trait_ref.hir_trait_id());
            trait_path.push(
                db.trait_data(trait_ref.hir_trait_id())
                    .name
                    .as_str()
                    .to_owned(),
            );
            //TODO
            // trap.emit(generated::AssociatedType {
            //     id: trap::TrapId::Star,
            //     trait_path,
            //     name,
            // })
            // .into()
            None
        }
        chalk_ir::TyKind::BoundVar(var) => {
            let var = format!("T_{}_{}", var.debruijn.depth(), var.index);
            let path = make_qualified_path(trap, vec![var]);
            Some(
                trap.emit(generated::PathTypeRepr {
                    id: trap::TrapId::Star,
                    path,
                })
                .into(),
            )
        }
        chalk_ir::TyKind::Foreign(_)
        | chalk_ir::TyKind::Closure(_, _)
        | chalk_ir::TyKind::Coroutine(_, _)
        | chalk_ir::TyKind::CoroutineWitness(_, _)
        | chalk_ir::TyKind::InferenceVar(_, _)
        | chalk_ir::TyKind::Error => {
            debug!("Unexpected type {:#?}", ty.kind(ra_ap_hir_ty::Interner));
            None
        }
    }
}

enum Variant {
    Unit,
    Record(trap::Label<generated::RecordFieldList>),
    Tuple(trap::Label<generated::TupleFieldList>),
}

impl From<Variant> for Option<trap::Label<generated::RecordFieldList>> {
    fn from(val: Variant) -> Self {
        match val {
            Variant::Record(label) => Some(label),
            _ => None,
        }
    }
}

impl From<Variant> for Option<trap::Label<generated::FieldList>> {
    fn from(val: Variant) -> Self {
        match val {
            Variant::Record(label) => Some(label.into()),
            Variant::Tuple(label) => Some(label.into()),
            Variant::Unit => None,
        }
    }
}

fn emit_variant_data(
    trap: &mut TrapFile,
    crate_graph: &CrateGraph,
    db: &dyn HirDatabase,
    variant_id: VariantId,
) -> Variant {
    let variant = variant_id.variant_data(db.upcast());
    match variant.as_ref() {
        VariantData::Record {
            fields: field_data,
            types_map: _,
        } => {
            let field_types = db.field_types(variant_id);
            let fields = field_types
                .iter()
                .map(|(field_id, ty)| {
                    let name = Some(trap.emit(generated::Name {
                        id: trap::TrapId::Star,
                        text: Some(field_data[field_id].name.as_str().to_owned()),
                    }));
                    let type_repr = emit_hir_ty(trap, crate_graph, db, ty.skip_binders());
                    let visibility = emit_visibility(
                        crate_graph,
                        db,
                        trap,
                        field_data[field_id]
                            .visibility
                            .resolve(db.upcast(), &variant_id.resolver(db.upcast())),
                    );
                    trap.emit(generated::StructField {
                        id: trap::TrapId::Star,
                        attrs: vec![],
                        name,
                        type_repr,
                        visibility,
                        expr: None,
                    })
                })
                .collect();
            Variant::Record(trap.emit(generated::RecordFieldList {
                id: trap::TrapId::Star,
                fields,
            }))
        }
        VariantData::Tuple {
            fields: field_data, ..
        } => {
            let field_types = db.field_types(variant_id);
            let fields = field_types
                .iter()
                .map(|(field_id, ty)| {
                    let type_repr = emit_hir_ty(trap, crate_graph, db, ty.skip_binders());
                    let visibility = emit_visibility(
                        crate_graph,
                        db,
                        trap,
                        field_data[field_id]
                            .visibility
                            .resolve(db.upcast(), &variant_id.resolver(db.upcast())),
                    );

                    trap.emit(generated::TupleField {
                        id: trap::TrapId::Star,
                        attrs: vec![],
                        type_repr,
                        visibility,
                    })
                })
                .collect();
            Variant::Tuple(trap.emit(generated::TupleFieldList {
                id: trap::TrapId::Star,
                fields,
            }))
        }
        VariantData::Unit => Variant::Unit,
    }
}

fn cmp_flag(a: &&CfgAtom, b: &&CfgAtom) -> Ordering {
    match (a, b) {
        (CfgAtom::Flag(a), CfgAtom::Flag(b)) => a.as_str().cmp(b.as_str()),
        (CfgAtom::Flag(a), CfgAtom::KeyValue { key: b, value: _ }) => {
            a.as_str().cmp(b.as_str()).then(Ordering::Less)
        }
        (CfgAtom::KeyValue { key: a, value: _ }, CfgAtom::Flag(b)) => {
            a.as_str().cmp(b.as_str()).then(Ordering::Greater)
        }
        (CfgAtom::KeyValue { key: a, value: av }, CfgAtom::KeyValue { key: b, value: bv }) => a
            .as_str()
            .cmp(b.as_str())
            .then(av.as_str().cmp(bv.as_str())),
    }
}
