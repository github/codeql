use std::{fs, path::PathBuf};

pub mod codegen;
mod flags;
use crate::codegen::grammar::ast_src::{AstEnumSrc, Cardinality};
use codegen::grammar::ast_src::{AstNodeSrc, AstSrc, Field};
use itertools::Itertools;
use serde::Serialize;
use std::collections::{BTreeMap, BTreeSet};
use std::env;
use ungrammar::Grammar;

fn project_root() -> PathBuf {
    let dir = env::var("CARGO_MANIFEST_DIR").unwrap().to_owned();
    PathBuf::from(dir).parent().unwrap().to_owned()
}

fn class_name(type_name: &str) -> String {
    match type_name {
        "BinExpr" => "BinaryExpr".to_owned(),
        "ElseBranch" => "Expr".to_owned(),
        "Fn" => "Function".to_owned(),
        "Literal" => "LiteralExpr".to_owned(),
        "ArrayExpr" => "ArrayExprInternal".to_owned(),
        "AsmOptions" => "AsmOptionsList".to_owned(),
        "MacroStmts" => "MacroBlockExpr".to_owned(),
        _ if type_name.starts_with("Record") => type_name.replacen("Record", "Struct", 1),
        _ if type_name.ends_with("Type") => format!("{}Repr", type_name),
        _ => type_name.to_owned(),
    }
}

fn property_name(type_name: &str, field_name: &str) -> String {
    let name = match (type_name, field_name) {
        ("CallExpr", "expr") => "function",
        ("LetExpr", "expr") => "scrutinee",
        ("MatchExpr", "expr") => "scrutinee",
        ("Variant", "expr") => "discriminant",
        ("FieldExpr", "expr") => "container",
        ("MacroBlockExpr", "expr") => "tail_expr",
        (_, "name_ref") => "identifier",
        (_, "then_branch") => "then",
        (_, "else_branch") => "else_",
        ("ArrayTypeRepr", "ty") => "element_type_repr",
        ("SelfParam", "is_amp") => "is_ref",
        ("StructField", "expr") => "default",
        ("UseTree", "is_star") => "is_glob",
        (_, "ty") => "type_repr",
        _ if field_name.contains("record") => &field_name.replacen("record", "struct", 1),
        _ => field_name,
    };
    name.to_owned()
}

fn to_lower_snake_case(s: &str) -> String {
    let mut buf = String::with_capacity(s.len());
    let mut prev = false;
    for c in s.chars() {
        if c.is_ascii_uppercase() && prev {
            buf.push('_')
        }
        prev = true;

        buf.push(c.to_ascii_lowercase());
    }
    buf
}

#[derive(Serialize)]
struct SchemaField {
    name: String,
    ty: String,
    child: bool,
}

#[derive(Serialize)]
struct SchemaClass {
    name: String,
    bases: Vec<String>,
    fields: Vec<SchemaField>,
}

#[derive(Serialize, Default)]
struct Schema {
    classes: Vec<SchemaClass>,
}

fn get_bases(name: &str, super_types: &BTreeMap<String, BTreeSet<String>>) -> Vec<String> {
    super_types
        .get(name)
        .map(|tys| tys.iter().map(|t| class_name(t)).collect())
        .unwrap_or_else(|| vec!["AstNode".to_string()])
}

fn enum_src_to_schema_class(
    node: &AstEnumSrc,
    super_types: &BTreeMap<String, BTreeSet<String>>,
) -> SchemaClass {
    SchemaClass {
        name: class_name(&node.name),
        bases: get_bases(&node.name, super_types),
        fields: Vec::new(),
    }
}

fn node_src_to_schema_class(
    node: &AstNodeSrc,
    super_types: &BTreeMap<String, BTreeSet<String>>,
) -> SchemaClass {
    let name = class_name(&node.name);
    let fields = get_fields(node)
        .iter()
        .map(|f| {
            let (ty, child) = match &f.ty {
                FieldType::String => ("optional[string]".to_string(), false),
                FieldType::Predicate => ("predicate".to_string(), false),
                FieldType::Optional(ty) | FieldType::Body(ty) => {
                    (format!("optional[\"{}\"]", class_name(ty)), true)
                }
                FieldType::List(ty) => (format!("list[\"{}\"]", class_name(ty)), true),
            };
            SchemaField {
                name: property_name(&name, &f.name),
                ty,
                child,
            }
        })
        .collect();
    SchemaClass {
        name,
        fields,
        bases: get_bases(&node.name, super_types),
    }
}

fn fix_blank_lines(s: &str) -> String {
    // mustache is not very good at avoiding blank lines
    // adopting the workaround from https://github.com/groue/GRMustache/issues/46#issuecomment-19498046
    s.split("\n")
        .filter(|line| !line.trim().is_empty())
        .map(|line| if line == "¶" { "" } else { line })
        .join("\n")
        + "\n"
}

fn write_schema(
    grammar: &AstSrc,
    super_types: BTreeMap<String, BTreeSet<String>>,
    mustache_ctx: &mustache::Context,
) -> mustache::Result<String> {
    let mut schema = Schema::default();
    schema.classes.extend(
        grammar
            .enums
            .iter()
            .map(|node| enum_src_to_schema_class(node, &super_types)),
    );
    schema.classes.extend(
        grammar
            .nodes
            .iter()
            .map(|node| node_src_to_schema_class(node, &super_types)),
    );
    let template = mustache_ctx.compile_path("schema")?;
    let res = template.render_to_string(&schema)?;
    Ok(fix_blank_lines(&res))
}

#[derive(Eq, PartialEq)]
enum FieldType {
    String,
    Predicate,
    Optional(String),
    Body(String),
    List(String),
}

struct FieldInfo {
    name: String,
    ty: FieldType,
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

fn get_additional_fields(node: &AstNodeSrc) -> Vec<FieldInfo> {
    match node.name.as_str() {
        "Name" | "NameRef" | "Lifetime" => vec![FieldInfo::string("text")],
        "Abi" => vec![FieldInfo::string("abi_string")],
        "Literal" => vec![FieldInfo::string("text_value")],
        "PrefixExpr" => vec![FieldInfo::string("operator_name")],
        "BinExpr" => vec![
            FieldInfo::optional("lhs", "Expr"),
            FieldInfo::optional("rhs", "Expr"),
            FieldInfo::string("operator_name"),
        ],
        "IfExpr" => vec![
            FieldInfo::optional("then_branch", "BlockExpr"),
            FieldInfo::optional("else_branch", "ElseBranch"),
            FieldInfo::optional("condition", "Expr"),
        ],
        "RangeExpr" => vec![
            FieldInfo::optional("start", "Expr"),
            FieldInfo::optional("end", "Expr"),
            FieldInfo::string("operator_name"),
        ],
        "RangePat" => vec![
            FieldInfo::optional("start", "Pat"),
            FieldInfo::optional("end", "Pat"),
            FieldInfo::string("operator_name"),
        ],
        "IndexExpr" => vec![
            FieldInfo::optional("index", "Expr"),
            FieldInfo::optional("base", "Expr"),
        ],
        "Impl" => vec![
            FieldInfo::optional("trait_", "Type"),
            FieldInfo::optional("self_ty", "Type"),
        ],
        "ForExpr" => vec![FieldInfo::optional("iterable", "Expr")],
        "WhileExpr" => vec![FieldInfo::optional("condition", "Expr")],
        "MatchGuard" => vec![FieldInfo::optional("condition", "Expr")],
        "MacroDef" => vec![
            FieldInfo::body("args", "TokenTree"),
            FieldInfo::body("body", "TokenTree"),
        ],
        "MacroCall" => vec![FieldInfo::body("token_tree", "TokenTree")],
        "FormatArgsExpr" => vec![FieldInfo::list("args", "FormatArgsArg")],
        "ArgList" => vec![FieldInfo::list("args", "Expr")],
        "Fn" => vec![FieldInfo::body("body", "BlockExpr")],
        "Const" => vec![FieldInfo::body("body", "Expr")],
        "Static" => vec![FieldInfo::body("body", "Expr")],
        "Param" => vec![FieldInfo::body("pat", "Pat")],
        "ClosureExpr" => vec![FieldInfo::optional("body", "Expr")],
        "ArrayExpr" => vec![FieldInfo::predicate("is_semicolon")],
        "SelfParam" => vec![FieldInfo::predicate("is_amp")],
        "UseTree" => vec![FieldInfo::predicate("is_star")],
        _ => vec![],
    }
}
fn get_fields(node: &AstNodeSrc) -> Vec<FieldInfo> {
    let mut result = Vec::new();
    let predicates = [
        "async", "auto", "const", "default", "gen", "move", "mut", "raw", "ref", "static", "try",
        "unsafe",
    ];
    for field in &node.fields {
        if let Field::Token(name) = field {
            if predicates.contains(&name.as_str()) {
                result.push(FieldInfo {
                    name: format!("is_{name}"),
                    ty: FieldType::Predicate,
                });
            }
        }
    }

    result.extend(get_additional_fields(node));

    for field in &node.fields {
        let name = field.method_name();
        match (node.name.as_str(), name.as_str()) {
            ("ArrayExpr", "expr") // The ArrayExpr type also has an 'exprs' field
            | ("PathSegment", "type_anchor")  // we flatten TypeAnchor into PathSegment in the extractor
            | ("Param", "pat") | ("MacroCall", "token_tree") // handled manually to use `body`
            => continue,
            _ => {}
        }
        let ty = match field {
            Field::Token(_) => continue,
            Field::Node {
                ty, cardinality, ..
            } => match cardinality {
                Cardinality::Optional => FieldType::Optional(ty.clone()),
                Cardinality::Many => FieldType::List(ty.clone()),
            },
        };
        result.push(FieldInfo { name, ty });
    }
    for trait_ in &node.traits {
        match trait_.as_str() {
            "HasAttrs" => result.push(FieldInfo::list("attrs", "Attr")),
            "HasName" => result.push(FieldInfo::optional("name", "Name")),
            "HasVisibility" => result.push(FieldInfo::optional("visibility", "Visibility")),
            "HasGenericParams" => {
                result.push(FieldInfo::optional(
                    "generic_param_list",
                    "GenericParamList",
                ));
                result.push(FieldInfo::optional("where_clause", "WhereClause"))
            }
            "HasGenericArgs" => {
                result.push(FieldInfo::optional("generic_arg_list", "GenericArgList"))
            }
            "HasTypeBounds" => result.push(FieldInfo::optional("type_bound_list", "TypeBoundList")),
            "HasModuleItem" => result.push(FieldInfo::list("items", "Item")),
            "HasLoopBody" => {
                result.push(FieldInfo::optional("label", "Label"));
                result.push(FieldInfo::optional("loop_body", "BlockExpr"))
            }
            "HasArgList" => result.push(FieldInfo::optional("arg_list", "ArgList")),
            "HasDocComments" => {}

            _ => panic!("Unknown trait {}", trait_),
        };
    }
    result.sort_by(|x, y| x.name.cmp(&y.name));
    result
}

#[derive(Serialize)]
struct EnumVariantInfo {
    name: String,
    snake_case_name: String,
    variant_ast_name: String,
}

#[derive(Serialize)]
struct ExtractorEnumInfo {
    name: String,
    snake_case_name: String,
    ast_name: String,
    variants: Vec<EnumVariantInfo>,
}

#[derive(Serialize, Default)]
struct ExtractorNodeFieldInfo {
    name: String,
    method: String,
    snake_case_ty: String,
    string: bool,
    predicate: bool,
    optional: bool,
    list: bool,
    body: bool,
}

#[derive(Serialize)]
struct ExtractorNodeInfo {
    name: String,
    snake_case_name: String,
    ast_name: String,
    fields: Vec<ExtractorNodeFieldInfo>,
    has_attrs: bool,
}

#[derive(Serialize)]
struct ExtractorInfo {
    enums: Vec<ExtractorEnumInfo>,
    nodes: Vec<ExtractorNodeInfo>,
}

fn enum_to_extractor_info(node: &AstEnumSrc) -> Option<ExtractorEnumInfo> {
    if node.name == "VariantDef" {
        // currently defined but unused
        return None;
    }
    Some(ExtractorEnumInfo {
        name: class_name(&node.name),
        snake_case_name: to_lower_snake_case(&node.name),
        ast_name: node.name.clone(),
        variants: node
            .variants
            .iter()
            .map(|v| {
                let name = class_name(v);
                let snake_case_name = to_lower_snake_case(v);
                EnumVariantInfo {
                    name,
                    snake_case_name,
                    variant_ast_name: v.clone(),
                }
            })
            .collect(),
    })
}

fn field_info_to_extractor_info(name: &str, field: &FieldInfo) -> ExtractorNodeFieldInfo {
    let name = property_name(name, &field.name);
    match &field.ty {
        FieldType::String => ExtractorNodeFieldInfo {
            name,
            string: true,
            ..Default::default()
        },
        FieldType::Predicate => ExtractorNodeFieldInfo {
            name,
            method: format!("{}_token", &field.name[3..]),
            predicate: true,
            ..Default::default()
        },
        FieldType::Optional(ty) => ExtractorNodeFieldInfo {
            name,
            method: field.name.clone(),
            snake_case_ty: to_lower_snake_case(ty),
            optional: true,
            ..Default::default()
        },
        FieldType::Body(ty) => ExtractorNodeFieldInfo {
            name,
            method: field.name.clone(),
            snake_case_ty: to_lower_snake_case(ty),
            body: true,
            ..Default::default()
        },
        FieldType::List(ty) => ExtractorNodeFieldInfo {
            name,
            method: field.name.clone(),
            snake_case_ty: to_lower_snake_case(ty),
            list: true,
            ..Default::default()
        },
    }
}
fn node_to_extractor_info(node: &AstNodeSrc) -> ExtractorNodeInfo {
    let fields = get_fields(node);
    let has_attrs = fields.iter().any(|f| f.name == "attrs");
    let name = class_name(&node.name);
    let fields = fields
        .iter()
        .map(|f| field_info_to_extractor_info(&name, f))
        .collect();
    ExtractorNodeInfo {
        name,
        snake_case_name: to_lower_snake_case(&node.name),
        ast_name: node.name.clone(),
        fields,
        has_attrs,
    }
}

fn write_extractor(grammar: &AstSrc, mustache_ctx: &mustache::Context) -> mustache::Result<String> {
    let extractor_info = ExtractorInfo {
        enums: grammar
            .enums
            .iter()
            .filter_map(enum_to_extractor_info)
            .collect(),
        nodes: grammar.nodes.iter().map(node_to_extractor_info).collect(),
    };
    let template = mustache_ctx.compile_path("extractor")?;
    let res = template.render_to_string(&extractor_info)?;
    Ok(fix_blank_lines(&res))
}

fn main() -> anyhow::Result<()> {
    let grammar = PathBuf::from("..").join(env::args().nth(1).expect("grammar file path required"));
    let grammar: Grammar = fs::read_to_string(&grammar)
        .unwrap_or_else(|_| panic!("Failed to parse grammar file: {}", grammar.display()))
        .parse()
        .expect("Failed to parse grammar");
    let mut grammar = codegen::grammar::lower(&grammar);

    grammar.enums.retain(|x| x.name != "Adt");

    // we flatten TypeAnchor into PathSegment in the extractor
    grammar.nodes.retain(|x| x.name != "TypeAnchor");

    let mut super_types: BTreeMap<String, BTreeSet<String>> = BTreeMap::new();
    for node in &grammar.enums {
        for variant in &node.variants {
            let set = super_types.entry(variant.to_owned()).or_default();
            set.insert(node.name.to_owned());
        }
    }
    // sort things while ensuring super clases are defined before they are used
    grammar.enums.sort_by(|x, y| {
        let super_class_x = super_types.get(&x.name).into_iter().flatten().max();
        let super_class_y = super_types.get(&y.name).into_iter().flatten().max();
        super_class_x.cmp(&super_class_y).then(x.name.cmp(&y.name))
    });
    let root = project_root();
    let mustache_ctx = mustache::Context {
        template_path: root.join("ast-generator").join("templates"),
        template_extension: "mustache".to_string(),
    };
    let schema = write_schema(&grammar, super_types, &mustache_ctx)?;
    let schema_path = root.join("schema/ast.py");
    codegen::ensure_file_contents(
        crate::flags::CodegenType::Grammar,
        &schema_path,
        &schema,
        false,
    );

    let extractor = write_extractor(&grammar, &mustache_ctx)?;
    let extractor_path = project_root().join("extractor/src/translate/generated.rs");
    codegen::ensure_file_contents(
        crate::flags::CodegenType::Grammar,
        &extractor_path,
        &extractor,
        false,
    );

    Ok(())
}
