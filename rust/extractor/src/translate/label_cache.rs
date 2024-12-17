use crate::generated::{self};
use crate::trap::{Label, TrapClass, UntypedLabel};
use ra_ap_hir::{
    Adt, Crate, Enum, Function, Module, Struct, Trait, TraitRef, Type, Union, Variant,
};
use std::collections::HashMap;

#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub enum Key {
    Type(Type),
    Function(Function),
    Trait(Trait),
    Enum(Enum),
    Union(Union),
    Struct(Struct),
    Crate(Crate),
    Module(Module),
    TraitRef(TraitRef),
    Variant(Variant),
}

pub trait StorableAsCanonicalPath {
    type TrapClass: TrapClass;

    fn to_key(&self) -> Key;
}

pub trait StorableAsModuleItemCanonicalPath {
    fn to_key(&self) -> Key;
}

impl<T: StorableAsModuleItemCanonicalPath> StorableAsCanonicalPath for T {
    type TrapClass = generated::ModuleItemCanonicalPath;

    fn to_key(&self) -> Key {
        <Self as StorableAsModuleItemCanonicalPath>::to_key(self)
    }
}

impl StorableAsCanonicalPath for Type {
    type TrapClass = generated::TypeCanonicalPath;

    fn to_key(&self) -> Key {
        Key::Type(self.clone())
    }
}

impl StorableAsCanonicalPath for Function {
    type TrapClass = generated::CanonicalPath;

    fn to_key(&self) -> Key {
        Key::Function(*self)
    }
}

impl StorableAsModuleItemCanonicalPath for Trait {
    fn to_key(&self) -> Key {
        Key::Trait(*self)
    }
}

impl StorableAsModuleItemCanonicalPath for Adt {
    fn to_key(&self) -> Key {
        match *self {
            Adt::Struct(it) => Key::Struct(it),
            Adt::Union(it) => Key::Union(it),
            Adt::Enum(it) => Key::Enum(it),
        }
    }
}

impl StorableAsModuleItemCanonicalPath for Enum {
    fn to_key(&self) -> Key {
        Key::Enum(*self)
    }
}

impl StorableAsModuleItemCanonicalPath for Union {
    fn to_key(&self) -> Key {
        Key::Union(*self)
    }
}

impl StorableAsModuleItemCanonicalPath for Struct {
    fn to_key(&self) -> Key {
        Key::Struct(*self)
    }
}

impl StorableAsCanonicalPath for Crate {
    type TrapClass = generated::CrateRef;

    fn to_key(&self) -> Key {
        Key::Crate(*self)
    }
}

impl StorableAsCanonicalPath for Module {
    type TrapClass = generated::Namespace;

    fn to_key(&self) -> Key {
        Key::Module(*self)
    }
}

impl StorableAsCanonicalPath for TraitRef {
    type TrapClass = generated::ParametrizedCanonicalPath;

    fn to_key(&self) -> Key {
        Key::TraitRef(self.clone())
    }
}

impl StorableAsCanonicalPath for Variant {
    type TrapClass = generated::CanonicalPath;

    fn to_key(&self) -> Key {
        Key::Variant(*self)
    }
}

pub struct CanonicalPathLabelCache {
    cache: HashMap<Key, Option<UntypedLabel>>,
}

impl CanonicalPathLabelCache {
    pub fn new() -> Self {
        Self {
            cache: HashMap::new(),
        }
    }

    pub fn get<T: StorableAsCanonicalPath>(&self, key: &T) -> Option<Option<Label<T::TrapClass>>> {
        self.cache.get(&key.to_key()).map(|maybe| {
            maybe.map(|l| {
                // UNSAFE: The label can only have been inserted as Label<T::TrapClass>
                unsafe { Label::from_untyped(l) }
            })
        })
    }

    pub fn insert<T: StorableAsCanonicalPath>(
        &mut self,
        key: &T,
        label: Option<Label<T::TrapClass>>,
    ) {
        self.cache
            .insert(key.to_key(), label.map(|l| l.as_untyped()));
    }
}

#[macro_export]
macro_rules! cache_get_or_assign {
    ($cache:expr, $key:expr, $get:expr) => {{
        if let Some(label) = $cache.get(&$key) {
            label
        } else {
            let label = $get;
            $cache.insert(&$key, label.clone());
            label
        }
    }};
}
