use crate::{
    generated,
    trap::{self, TrapFile},
};
use chalk_ir::FloatTy;
use chalk_ir::IntTy;
use chalk_ir::Scalar;
use chalk_ir::UintTy;
use itertools::Itertools;
use ra_ap_base_db::CrateGraph;
use ra_ap_base_db::CrateId;
use ra_ap_base_db::SourceDatabase;
use ra_ap_cfg::CfgAtom;
use ra_ap_hir::{db::DefDatabase, VariantId};
use ra_ap_hir::{db::HirDatabase, DefMap, ModuleDefId};
use ra_ap_hir_def::HasModule;
use ra_ap_hir_def::{data::adt::VariantData, AssocItemId, LocalModuleId};
use ra_ap_hir_ty::Interner;
use ra_ap_hir_ty::TraitRefExt;
use ra_ap_hir_ty::Ty;
use ra_ap_hir_ty::TyExt;
use ra_ap_hir_ty::WhereClause;
use ra_ap_hir_ty::{Binders, FnPointer};
use ra_ap_ide_db::RootDatabase;
use ra_ap_vfs::{Vfs, VfsPath};
use std::hash::Hash;
use std::hash::Hasher;
use std::{cmp::Ordering, collections::HashMap, path::PathBuf};

pub fn extract_crate_graph(trap_provider: &trap::TrapFileProvider, db: &RootDatabase, vfs: &Vfs) {
    let crate_graph = db.crate_graph();

    // According to the documentation of `CrateGraph`:
    // Each crate is defined by the `FileId` of its root module, the set of enabled
    // `cfg` flags and the set of dependencies.
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
    for krate_id in crate_graph.iter() {
        if let Some((root_module_file, hash)) = crate_id_map.get(&krate_id) {
            let path = root_module_file.join(format!("{hash:0>16x}"));
            let mut trap = trap_provider.create("crates", path.as_path());
            if trap.path.exists() {
                continue;
            }
            let krate = &crate_graph[krate_id];
            let element = generated::Crate {
                id: trap::TrapId::Key(format!("crate:{}:{hash}", root_module_file.display())),
                name: krate
                    .display_name
                    .as_ref()
                    .map(|x| x.canonical_name().to_string()),
                version: krate.version.to_owned(),
                cfg_options: krate
                    .cfg_options
                    .as_ref()
                    .into_iter()
                    .map(|x| format!("{x}"))
                    .collect(),
                dependencies: krate
                    .dependencies
                    .iter()
                    .flat_map(|x| crate_id_map.get(&x.crate_id))
                    .map(|(module, hash)| {
                        trap.label(format!("crate:{}:{hash}", module.display()).into())
                    })
                    .collect(),
            };
            let parent = trap.emit(element);

            go(
                &crate_graph,
                db,
                db.crate_def_map(krate_id).as_ref(),
                parent.into(),
                "crate",
                DefMap::ROOT,
                &mut trap,
            );
            trap.commit().unwrap_or_else(|err| {
                log::error!(
                    "Failed to write trap file for crate: {}: {}",
                    root_module_file.display(),
                    err.to_string()
                )
            });
        }
        fn go(
            crate_graph: &CrateGraph,
            db: &dyn HirDatabase,
            map: &DefMap,
            parent: trap::Label<generated::ModuleContainer>,
            name: &str,
            module: LocalModuleId,
            trap: &mut TrapFile,
        ) {
            let module = &map.modules[module];
            let items = &module.scope;
            let mut values = Vec::new();
            let mut types = Vec::new();
            for (name, item) in items.entries() {
                let def = item.with_visibility(ra_ap_hir::Visibility::Public);
                if let Some(ra_ap_hir_def::per_ns::Item {
                    def: value,
                    vis: _,
                    import: _,
                }) = def.values
                {
                    match value {
                        ModuleDefId::FunctionId(function) => {
                            let type_ = db.value_ty(function.into());

                            if let Some(type_) = type_.map(|type_| {
                                emit_hir_ty(trap, crate_graph, db, type_.skip_binders())
                            }) {
                                values.push(trap.emit(generated::ValueItem {
                                    id: trap::TrapId::Star,
                                    name: name.as_str().to_owned(),
                                    type_,
                                }));
                            }
                        }
                        ModuleDefId::ConstId(konst) => {
                            let type_ = db.value_ty(konst.into());
                            if let Some(type_) = type_.map(|type_| {
                                emit_hir_ty(trap, crate_graph, db, type_.skip_binders())
                            }) {
                                values.push(trap.emit(generated::ValueItem {
                                    id: trap::TrapId::Star,
                                    name: name.as_str().to_owned(),
                                    type_,
                                }));
                            }
                        }
                        ModuleDefId::StaticId(statik) => {
                            let type_ = db.value_ty(statik.into());
                            if let Some(type_) = type_.map(|type_| {
                                emit_hir_ty(trap, crate_graph, db, type_.skip_binders())
                            }) {
                                values.push(trap.emit(generated::ValueItem {
                                    id: trap::TrapId::Star,
                                    name: name.as_str().to_owned(),
                                    type_,
                                }));
                            }
                        }
                        ModuleDefId::EnumVariantId(variant_id) => {
                            let type_ = db.value_ty(variant_id.into());
                            let type_ = type_.map(|type_| {
                                emit_hir_ty(trap, crate_graph, db, type_.skip_binders())
                            });
                            if let Some(type_) = type_ {
                                values.push(trap.emit(generated::ValueItem {
                                    id: trap::TrapId::Star,
                                    name: name.as_str().to_owned(),
                                    type_,
                                }));
                            }
                        }
                        _ => (),
                    }
                }
                if let Some(ra_ap_hir_def::per_ns::Item {
                    def: type_id,
                    vis: _,
                    import: _,
                }) = def.types
                {
                    if let ModuleDefId::AdtId(adt_id) = type_id {
                        match adt_id {
                            ra_ap_hir_def::AdtId::StructId(struct_id) => {
                                let content =
                                    emit_variant_data(trap, crate_graph, db, struct_id.into());
                                types.push(
                                    trap.emit(generated::StructItem {
                                        id: trap::TrapId::Star,
                                        name: name.as_str().to_owned(),
                                        content,
                                        is_union: false,
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
                                        let content = emit_variant_data(
                                            trap,
                                            crate_graph,
                                            db,
                                            (*enum_id).into(),
                                        );
                                        trap.emit(generated::EnumVariant {
                                            id: trap::TrapId::Star,
                                            name: name.as_str().to_owned(),
                                            content,
                                        })
                                    })
                                    .collect();
                                types.push(
                                    trap.emit(generated::EnumItem {
                                        id: trap::TrapId::Star,
                                        name: name.as_str().to_owned(),
                                        variants,
                                    })
                                    .into(),
                                );
                            }
                            ra_ap_hir_def::AdtId::UnionId(union_id) => {
                                let content =
                                    emit_variant_data(trap, crate_graph, db, union_id.into());
                                types.push(
                                    trap.emit(generated::StructItem {
                                        id: trap::TrapId::Star,
                                        name: name.as_str().to_owned(),
                                        content,
                                        is_union: true,
                                    })
                                    .into(),
                                );
                            }
                        }
                    }
                    if let ModuleDefId::TraitId(trait_id) = type_id {
                        let data = db.trait_data(trait_id);
                        let mut method_names = Vec::new();
                        let mut method_types = Vec::new();
                        for (name, item) in &data.items {
                            if let AssocItemId::FunctionId(function) = item {
                                let method_type = db
                                    .callable_item_signature((*function).into())
                                    .skip_binders()
                                    .to_fn_ptr();
                                let method_type = emit_hir_fn(trap, crate_graph, db, &method_type);
                                method_names.push(name.as_str().to_owned());
                                method_types.push(method_type);
                            };
                        }

                        types.push(
                            trap.emit(generated::TraitItem {
                                id: trap::TrapId::Star,
                                name: name.as_str().to_owned(),
                                method_names,
                                method_types,
                            })
                            .into(),
                        );
                    }
                }
            }
            let impls: Vec<_> = items
                .impls()
                .map(|imp| {
                    let self_ty = db.impl_self_ty(imp);
                    let self_ty = emit_hir_ty(trap, crate_graph, db, self_ty.skip_binders());
                    let imp = db.impl_data(imp);
                    let target_trait = match imp.target_trait.as_ref() {
                        Some(t) => emit_hir_path(&imp.types_map[t.path]),
                        None => vec![],
                    };
                    let mut method_names = Vec::new();
                    let mut method_types = Vec::new();
                    for item in &imp.items {
                        if let AssocItemId::FunctionId(function) = item {
                            let method_type = db
                                .callable_item_signature((*function).into())
                                .skip_binders()
                                .to_fn_ptr();
                            let method_type = emit_hir_fn(trap, crate_graph, db, &method_type);
                            let function = db.function_data(*function);
                            method_names.push(function.name.as_str().to_owned());
                            method_types.push(method_type);
                        };
                    }

                    trap.emit(generated::ImplItem {
                        id: trap::TrapId::Star,
                        target_trait,
                        self_ty,
                        method_names,
                        method_types,
                    })
                })
                .collect();

            let label = trap.emit(generated::CrateModule {
                id: trap::TrapId::Star,
                name: name.to_owned(),
                parent,
                values,
                types,
                impls,
            });
            for (name, child) in module
                .children
                .iter()
                .sorted_by(|a, b| Ord::cmp(&a.0, &b.0))
            {
                go(
                    crate_graph,
                    db,
                    map,
                    label.into(),
                    name.as_str(),
                    *child,
                    trap,
                );
            }
        }
    }
}

fn emit_hir_type_bound(
    crate_graph: &CrateGraph,
    db: &dyn HirDatabase,
    trap: &mut TrapFile,
    type_bound: &Binders<chalk_ir::WhereClause<Interner>>,
) -> Option<trap::Label<generated::TypeBoundType>> {
    match type_bound.skip_binders() {
        WhereClause::Implemented(trait_ref) => {
            let mut path = make_path(crate_graph, db, trait_ref.hir_trait_id());
            path.push(
                db.trait_data(trait_ref.hir_trait_id())
                    .name
                    .as_str()
                    .to_owned(),
            );
            Some(
                trap.emit(generated::TraitTypeBound {
                    id: trap::TrapId::Star,
                    path,
                })
                .into(),
            )
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

fn emit_hir_fn(
    trap: &mut TrapFile,
    crate_graph: &CrateGraph,
    db: &dyn HirDatabase,
    function: &FnPointer,
) -> trap::Label<generated::FunctionType> {
    let parameters: Vec<_> = function.substitution.0.type_parameters(Interner).collect();

    let (ret_type, params) = parameters.split_last().unwrap();

    let ret_type = emit_hir_ty(trap, crate_graph, db, ret_type);

    let self_type = None; // TODO: ?
    let self_type = self_type.map(|ty| emit_hir_ty(trap, crate_graph, db, &ty));
    let params = params
        .iter()
        .map(|t| emit_hir_ty(trap, crate_graph, db, t))
        .collect();
    let is_unsafe = matches!(function.sig.safety, ra_ap_hir::Safety::Unsafe);
    trap.emit(generated::FunctionType {
        id: trap::TrapId::Star,
        is_async: false,
        is_const: false,
        is_unsafe,
        self_type,
        ret_type,
        params,
        has_varargs: false,
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
    let mut path = Vec::new();
    let db = db.upcast();
    let mut module = item.module(db);
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

fn emit_hir_ty(
    trap: &mut TrapFile,
    crate_graph: &CrateGraph,
    db: &dyn HirDatabase,
    ty: &Ty,
) -> trap::Label<generated::Type> {
    match ty.kind(ra_ap_hir_ty::Interner) {
        chalk_ir::TyKind::Never => trap
            .emit(generated::NeverType {
                id: trap::TrapId::Star,
            })
            .into(),

        chalk_ir::TyKind::Placeholder(_index) => trap
            .emit(generated::PlaceholderType {
                id: trap::TrapId::Star,
            })
            .into(),

        chalk_ir::TyKind::Tuple(_size, substitution) => {
            let fields = substitution.type_parameters(ra_ap_hir_ty::Interner);
            let fields = fields
                .map(|field| emit_hir_ty(trap, crate_graph, db, &field))
                .collect();

            trap.emit(generated::TupleType {
                id: trap::TrapId::Star,
                fields,
            })
            .into()
        }
        chalk_ir::TyKind::Raw(mutability, ty) => {
            let type_ = emit_hir_ty(trap, crate_graph, db, ty);

            trap.emit(generated::RawPtrType {
                id: trap::TrapId::Star,
                is_mut: matches!(mutability, chalk_ir::Mutability::Mut),
                type_,
            })
            .into()
        }
        chalk_ir::TyKind::Ref(mutability, _lifetime, ty) => {
            let type_ = emit_hir_ty(trap, crate_graph, db, ty);
            let lifetime = None; //TODO: ?
            trap.emit(generated::ReferenceType {
                id: trap::TrapId::Star,
                is_mut: matches!(mutability, chalk_ir::Mutability::Mut),
                type_,
                lifetime,
            })
            .into()
        }
        chalk_ir::TyKind::Array(ty, _konst) => {
            let type_ = emit_hir_ty(trap, crate_graph, db, ty);
            // TODO: handle array size constant
            trap.emit(generated::ArrayType {
                id: trap::TrapId::Star,
                type_,
            })
            .into()
        }
        chalk_ir::TyKind::Slice(ty) => {
            let type_ = emit_hir_ty(trap, crate_graph, db, ty);
            trap.emit(generated::SliceType {
                id: trap::TrapId::Star,
                type_,
            })
            .into()
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
            trap.emit(generated::PathType {
                id: trap::TrapId::Star,
                path,
            })
            .into()
        }
        chalk_ir::TyKind::Scalar(scalar) => trap
            .emit(generated::PathType {
                id: trap::TrapId::Star,
                path: vec![scalar_to_str(scalar).to_owned()],
            })
            .into(),
        chalk_ir::TyKind::Str => trap
            .emit(generated::PathType {
                id: trap::TrapId::Star,
                path: vec!["str".to_owned()],
            })
            .into(),
        chalk_ir::TyKind::Function(fn_pointer) => {
            emit_hir_fn(trap, crate_graph, db, fn_pointer).into()
        }
        chalk_ir::TyKind::OpaqueType(_, _) => {
            let type_bounds = ty
                .impl_trait_bounds(db)
                .iter()
                .flatten()
                .flat_map(|t| emit_hir_type_bound(crate_graph, db, trap, t))
                .collect();
            trap.emit(generated::ImplTraitType {
                id: trap::TrapId::Star,
                type_bounds,
            })
            .into()
        }
        chalk_ir::TyKind::Dyn(dyn_ty) => {
            let type_bounds = dyn_ty
                .bounds
                .skip_binders()
                .iter(ra_ap_hir_ty::Interner)
                .flat_map(|t| emit_hir_type_bound(crate_graph, db, trap, t))
                .collect();
            trap.emit(generated::DynTraitType {
                id: trap::TrapId::Star,
                type_bounds,
            })
            .into()
        }
        chalk_ir::TyKind::AssociatedType(_, _)
        | chalk_ir::TyKind::FnDef(_, _)
        | chalk_ir::TyKind::Closure(_, _)
        | chalk_ir::TyKind::Coroutine(_, _)
        | chalk_ir::TyKind::CoroutineWitness(_, _)
        | chalk_ir::TyKind::Foreign(_)
        | chalk_ir::TyKind::Alias(_)
        | chalk_ir::TyKind::BoundVar(_)
        | chalk_ir::TyKind::InferenceVar(_, _)
        | chalk_ir::TyKind::Error => trap
            .emit(generated::ErrorType {
                id: trap::TrapId::Star,
            })
            .into(),
    }
}

fn emit_variant_data(
    trap: &mut TrapFile,
    crate_graph: &CrateGraph,
    db: &dyn HirDatabase,
    variant_id: VariantId,
) -> Option<trap::Label<generated::VariantData>> {
    let variant = variant_id.variant_data(db.upcast());
    match variant.as_ref() {
        VariantData::Record {
            fields: field_data,
            types_map: _,
        }
        | VariantData::Tuple {
            fields: field_data,
            types_map: _,
        } => {
            let field_types = db.field_types(variant_id);
            let mut types = Vec::new();
            let mut fields = Vec::new();
            for (field_id, ty) in field_types.iter() {
                let tp = emit_hir_ty(trap, crate_graph, db, ty.skip_binders());
                fields.push(field_data[field_id].name.as_str().to_owned());
                types.push(tp);
            }
            Some(trap.emit(generated::VariantData {
                id: trap::TrapId::Star,
                types,
                fields,
                is_record: matches!(*variant, VariantData::Record { .. }),
            }))
        }
        VariantData::Unit => None,
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
