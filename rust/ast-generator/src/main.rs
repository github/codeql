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
        _ if type_name.ends_with("Type") => format!("{}Repr", type_name),
        _ => type_name.to_owned(),
    }
}

fn property_name(type_name: &str, field_name: &str) -> String {
    let name = match (type_name, field_name) {
        ("CallExpr", "expr") => "function",
        ("LetExpr", "expr") => "scrutinee",
        ("MatchExpr", "expr") => "scrutinee",
        ("Path", "segment") => "part",
        (_, "then_branch") => "then",
        (_, "else_branch") => "else_",
        ("ArrayType", "ty") => "element_type_repr",
        ("SelfParam", "is_amp") => "is_ref",
        ("UseTree", "is_star") => "is_glob",
        (_, "ty") => "type_repr",
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
    SchemaClass {
        name: class_name(&node.name),
        bases: get_bases(&node.name, super_types),
        fields: get_fields(node)
            .iter()
            .map(|f| {
                let (ty, child) = match &f.ty {
                    FieldType::String => ("optional[string]".to_string(), false),
                    FieldType::Predicate => ("predicate".to_string(), false),
                    FieldType::Optional(ty) => (format!("optional[\"{}\"]", class_name(ty)), true),
                    FieldType::List(ty) => (format!("list[\"{}\"]", class_name(ty)), true),
                };
                SchemaField {
                    name: property_name(&node.name, &f.name),
                    ty,
                    child,
                }
            })
            .collect(),
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
    // the concat dance is currently required by bazel
    let template = mustache::compile_str(include_str!(concat!(
        env!("CARGO_MANIFEST_DIR"),
        "/src/templates/schema.mustache"
    )))?;
    let res = template.render_to_string(&schema)?;
    Ok(fix_blank_lines(&res))
}

#[derive(Eq, PartialEq)]
enum FieldType {
    String,
    Predicate,
    Optional(String),
    List(String),
}

struct FieldInfo {
    name: String,
    ty: FieldType,
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

    match node.name.as_str() {
        "Name" | "NameRef" | "Lifetime" => {
            result.push(FieldInfo {
                name: "text".to_string(),
                ty: FieldType::String,
            });
        }
        "Abi" => {
            result.push(FieldInfo {
                name: "abi_string".to_string(),
                ty: FieldType::String,
            });
        }
        "Literal" => {
            result.push(FieldInfo {
                name: "text_value".to_string(),
                ty: FieldType::String,
            });
        }
        "PrefixExpr" => {
            result.push(FieldInfo {
                name: "operator_name".to_string(),
                ty: FieldType::String,
            });
        }
        "BinExpr" => {
            result.push(FieldInfo {
                name: "lhs".to_string(),
                ty: FieldType::Optional("Expr".to_string()),
            });
            result.push(FieldInfo {
                name: "rhs".to_string(),
                ty: FieldType::Optional("Expr".to_string()),
            });
            result.push(FieldInfo {
                name: "operator_name".to_string(),
                ty: FieldType::String,
            });
        }
        "IfExpr" => {
            result.push(FieldInfo {
                name: "then_branch".to_string(),
                ty: FieldType::Optional("BlockExpr".to_string()),
            });
            result.push(FieldInfo {
                name: "else_branch".to_string(),
                ty: FieldType::Optional("ElseBranch".to_string()),
            });
            result.push(FieldInfo {
                name: "condition".to_string(),
                ty: FieldType::Optional("Expr".to_string()),
            });
        }
        "RangeExpr" => {
            result.push(FieldInfo {
                name: "start".to_string(),
                ty: FieldType::Optional("Expr".to_string()),
            });
            result.push(FieldInfo {
                name: "end".to_string(),
                ty: FieldType::Optional("Expr".to_string()),
            });
            result.push(FieldInfo {
                name: "operator_name".to_string(),
                ty: FieldType::String,
            });
        }
        "RangePat" => {
            result.push(FieldInfo {
                name: "start".to_string(),
                ty: FieldType::Optional("Pat".to_string()),
            });
            result.push(FieldInfo {
                name: "end".to_string(),
                ty: FieldType::Optional("Pat".to_string()),
            });
            result.push(FieldInfo {
                name: "operator_name".to_string(),
                ty: FieldType::String,
            });
        }
        "IndexExpr" => {
            result.push(FieldInfo {
                name: "index".to_string(),
                ty: FieldType::Optional("Expr".to_string()),
            });
            result.push(FieldInfo {
                name: "base".to_string(),
                ty: FieldType::Optional("Expr".to_string()),
            });
        }
        "Impl" => {
            result.push(FieldInfo {
                name: "trait_".to_string(),
                ty: FieldType::Optional("Type".to_string()),
            });
            result.push(FieldInfo {
                name: "self_ty".to_string(),
                ty: FieldType::Optional("Type".to_string()),
            });
        }
        "ForExpr" => {
            result.push(FieldInfo {
                name: "iterable".to_string(),
                ty: FieldType::Optional("Expr".to_string()),
            });
        }
        "WhileExpr" => {
            result.push(FieldInfo {
                name: "condition".to_string(),
                ty: FieldType::Optional("Expr".to_string()),
            });
        }
        "MatchGuard" => {
            result.push(FieldInfo {
                name: "condition".to_string(),
                ty: FieldType::Optional("Expr".to_string()),
            });
        }
        "MacroDef" => {
            result.push(FieldInfo {
                name: "args".to_string(),
                ty: FieldType::Optional("TokenTree".to_string()),
            });
            result.push(FieldInfo {
                name: "body".to_string(),
                ty: FieldType::Optional("TokenTree".to_string()),
            });
        }
        "FormatArgsExpr" => {
            result.push(FieldInfo {
                name: "args".to_string(),
                ty: FieldType::List("FormatArgsArg".to_string()),
            });
        }
        "ArgList" => {
            result.push(FieldInfo {
                name: "args".to_string(),
                ty: FieldType::List("Expr".to_string()),
            });
        }
        "Fn" => {
            result.push(FieldInfo {
                name: "body".to_string(),
                ty: FieldType::Optional("BlockExpr".to_string()),
            });
        }
        "Const" => {
            result.push(FieldInfo {
                name: "body".to_string(),
                ty: FieldType::Optional("Expr".to_string()),
            });
        }
        "Static" => {
            result.push(FieldInfo {
                name: "body".to_string(),
                ty: FieldType::Optional("Expr".to_string()),
            });
        }
        "ClosureExpr" => {
            result.push(FieldInfo {
                name: "body".to_string(),
                ty: FieldType::Optional("Expr".to_string()),
            });
        }
        "ArrayExpr" => {
            result.push(FieldInfo {
                name: "is_semicolon".to_string(),
                ty: FieldType::Predicate,
            });
        }
        "SelfParam" => {
            result.push(FieldInfo {
                name: "is_amp".to_string(),
                ty: FieldType::Predicate,
            });
        }
        "UseTree" => {
            result.push(FieldInfo {
                name: "is_star".to_string(),
                ty: FieldType::Predicate,
            });
        }
        _ => {}
    }

    for field in &node.fields {
        // The ArrayExpr type also has an 'exprs' field
        if node.name == "ArrayExpr" && field.method_name() == "expr" {
            continue;
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
        result.push(FieldInfo {
            name: field.method_name(),
            ty,
        });
    }
    for trait_ in &node.traits {
        match trait_.as_str() {
            "HasAttrs" => result.push(FieldInfo {
                name: "attrs".to_owned(),
                ty: FieldType::List("Attr".to_owned()),
            }),
            "HasName" => result.push(FieldInfo {
                name: "name".to_owned(),
                ty: FieldType::Optional("Name".to_owned()),
            }),
            "HasVisibility" => result.push(FieldInfo {
                name: "visibility".to_owned(),
                ty: FieldType::Optional("Visibility".to_owned()),
            }),
            "HasGenericParams" => {
                result.push(FieldInfo {
                    name: "generic_param_list".to_owned(),
                    ty: FieldType::Optional("GenericParamList".to_owned()),
                });
                result.push(FieldInfo {
                    name: "where_clause".to_owned(),
                    ty: FieldType::Optional("WhereClause".to_owned()),
                })
            }
            "HasGenericArgs" => result.push(FieldInfo {
                name: "generic_arg_list".to_owned(),
                ty: FieldType::Optional("GenericArgList".to_owned()),
            }),
            "HasTypeBounds" => result.push(FieldInfo {
                name: "type_bound_list".to_owned(),
                ty: FieldType::Optional("TypeBoundList".to_owned()),
            }),
            "HasModuleItem" => result.push(FieldInfo {
                name: "items".to_owned(),
                ty: FieldType::List("Item".to_owned()),
            }),
            "HasLoopBody" => {
                result.push(FieldInfo {
                    name: "label".to_owned(),
                    ty: FieldType::Optional("Label".to_owned()),
                });
                result.push(FieldInfo {
                    name: "loop_body".to_owned(),
                    ty: FieldType::Optional("BlockExpr".to_owned()),
                })
            }
            "HasArgList" => result.push(FieldInfo {
                name: "arg_list".to_owned(),
                ty: FieldType::Optional("ArgList".to_owned()),
            }),
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

fn enum_to_extractor_info(node: &AstEnumSrc) -> ExtractorEnumInfo {
    ExtractorEnumInfo {
        name: class_name(&node.name),
        snake_case_name: to_lower_snake_case(&node.name),
        ast_name: node.name.clone(),
        variants: node
            .variants
            .iter()
            .map(|v| EnumVariantInfo {
                name: v.clone(),
                snake_case_name: to_lower_snake_case(v),
            })
            .collect(),
    }
}

fn field_info_to_extractor_info(node: &AstNodeSrc, field: &FieldInfo) -> ExtractorNodeFieldInfo {
    let name = property_name(&node.name, &field.name);
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
    ExtractorNodeInfo {
        name: class_name(&node.name),
        snake_case_name: to_lower_snake_case(&node.name),
        ast_name: node.name.clone(),
        fields: fields
            .iter()
            .map(|f| field_info_to_extractor_info(node, f))
            .collect(),
        has_attrs,
    }
}

fn write_extractor(grammar: &AstSrc) -> mustache::Result<String> {
    let extractor_info = ExtractorInfo {
        enums: grammar.enums.iter().map(enum_to_extractor_info).collect(),
        nodes: grammar.nodes.iter().map(node_to_extractor_info).collect(),
    };
    // the concat dance is currently required by bazel
    let template = mustache::compile_str(include_str!(concat!(
        env!("CARGO_MANIFEST_DIR"),
        "/src/templates/extractor.mustache"
    )))?;
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
    let schema = write_schema(&grammar, super_types)?;
    let schema_path = project_root().join("schema/ast.py");
    codegen::ensure_file_contents(
        crate::flags::CodegenType::Grammar,
        &schema_path,
        &schema,
        false,
    );

    let extractor = write_extractor(&grammar)?;
    let extractor_path = project_root().join("extractor/src/translate/generated.rs");
    codegen::ensure_file_contents(
        crate::flags::CodegenType::Grammar,
        &extractor_path,
        &extractor,
        false,
    );

    Ok(())
}
