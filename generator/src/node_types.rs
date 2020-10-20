use serde::Deserialize;
use std::collections::BTreeMap;

#[derive(Deserialize)]
pub struct NodeInfo {
    #[serde(rename = "type")]
    pub kind: String,
    pub named: bool,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub fields: Option<BTreeMap<String, FieldInfo>>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub children: Option<FieldInfo>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub subtypes: Option<Vec<NodeType>>,
}

#[derive(Deserialize)]
pub struct NodeType {
    #[serde(rename = "type")]
    pub kind: String,
    pub named: bool,
}

#[derive(Deserialize)]
pub struct FieldInfo {
    pub multiple: bool,
    pub required: bool,
    pub types: Vec<NodeType>,
}

impl Default for FieldInfo {
    fn default() -> Self {
        FieldInfo {
            multiple: false,
            required: true,
            types: Vec::new(),
        }
    }
}
