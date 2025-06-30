#[derive(Eq, PartialEq)]
pub enum FieldType {
    String,
    Predicate,
    Optional(String),
    Body(String),
    List(String),
}

pub struct FieldInfo {
    pub name: String,
    pub ty: FieldType,
}

impl FieldInfo {
    pub fn optional(name: &str, ty: &str) -> FieldInfo {
        FieldInfo {
            name: name.to_string(),
            ty: FieldType::Optional(ty.to_string()),
        }
    }

    pub fn body(name: &str, ty: &str) -> FieldInfo {
        FieldInfo {
            name: name.to_string(),
            ty: FieldType::Body(ty.to_string()),
        }
    }

    pub fn string(name: &str) -> FieldInfo {
        FieldInfo {
            name: name.to_string(),
            ty: FieldType::String,
        }
    }

    pub fn predicate(name: &str) -> FieldInfo {
        FieldInfo {
            name: name.to_string(),
            ty: FieldType::Predicate,
        }
    }

    pub fn list(name: &str, ty: &str) -> FieldInfo {
        FieldInfo {
            name: name.to_string(),
            ty: FieldType::List(ty.to_string()),
        }
    }
}
