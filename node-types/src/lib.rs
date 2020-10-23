use serde::Deserialize;
use std::collections::BTreeMap;
use std::fmt;
use std::path::Path;

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

pub enum Error {
    IOError(std::io::Error),
    JsonError(serde_json::error::Error),
}

impl From<std::io::Error> for Error {
    fn from(error: std::io::Error) -> Self {
        Error::IOError(error)
    }
}

impl From<serde_json::Error> for Error {
    fn from(error: serde_json::Error) -> Self {
        Error::JsonError(error)
    }
}

impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Error::IOError(e) => write!(f, "{}", e),
            Error::JsonError(e) => write!(f, "{}", e),
        }
    }
}

/// Deserializes the node types from the JSON at the given `path`.
pub fn read(path: &Path) -> Result<Vec<NodeInfo>, Error> {
    let json_data = std::fs::read_to_string(path)?;
    let node_types: Vec<NodeInfo> = serde_json::from_str(&json_data)?;
    Ok(node_types)
}
