use std::io::Write;
use std::{fs, path::PathBuf};

pub mod codegen;
mod flags;
use codegen::grammar::ast_src::{AstNodeSrc, AstSrc};
use std::collections::{BTreeMap, BTreeSet};
use std::env;
use ungrammar::Grammar;

fn project_root() -> PathBuf {
    let dir =
        env::var("CARGO_MANIFEST_DIR").unwrap_or_else(|_| env!("CARGO_MANIFEST_DIR").to_owned());
    PathBuf::from(dir).parent().unwrap().to_owned()
}

fn class_name(type_name: &String) -> String {
    match type_name.as_str() {
        "BinExpr" => "BinaryExpr".to_owned(),
        "ElseBranch" => "Expr".to_owned(),
        "Fn" => "Function".to_owned(),
        "Literal" => "LiteralExpr".to_owned(),
        "Type" => "TypeRef".to_owned(),
        _ => type_name.to_owned(),
    }
}

fn property_name(type_name: &String, field_name: &String) -> String {
    match (type_name.as_str(), field_name.as_str()) {
        ("Path", "segment") => "part".to_owned(),
        (_, "then_branch") => "then".to_owned(),
        (_, "else_branch") => "else_".to_owned(),
        _ => field_name.to_owned(),
    }
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

fn write_schema(
    grammar: &AstSrc,
    super_types: BTreeMap<String, BTreeSet<String>>,
) -> std::io::Result<String> {
    let mut buf: Vec<u8> = Vec::new();
    writeln!(buf, "from .prelude import *\n")?;

    for node in &grammar.enums {
        let super_classses = if let Some(cls) = super_types.get(&node.name) {
            let super_classes: Vec<String> = cls.iter().map(|x| class_name(x)).collect();
            super_classes.join(",")
        } else {
            "AstNode".to_owned()
        };
        writeln!(buf, "class {}({}):", class_name(&node.name), super_classses)?;
        writeln!(buf, "   pass")?;
        writeln!(buf, "")?;
    }
    for node in &grammar.nodes {
        let super_classses = if let Some(cls) = super_types.get(&node.name) {
            let super_classes: Vec<String> = cls.iter().map(|x| class_name(x)).collect();
            super_classes.join(",")
        } else {
            "AstNode".to_owned()
        };
        writeln!(buf, "class {}({}):", class_name(&node.name), super_classses)?;
        let mut empty = true;
        for field in get_fields(node) {
            if field.tp == "SyntaxToken" {
                continue;
            }

            empty = false;
            if field.tp == "string" {
                writeln!(
                    buf,
                    "   {}: optional[string]",
                    property_name(&node.name, &field.name),
                )?;
            } else {
                let list = field.is_many;
                let (o, c) = if list {
                    ("list[", "]")
                } else {
                    ("optional[", "]")
                };
                writeln!(
                    buf,
                    "   {}: {}\"{}\"{} | child",
                    property_name(&node.name, &field.name),
                    o,
                    class_name(&field.tp),
                    c
                )?;
            };
        }
        if empty {
            writeln!(buf, "   pass")?;
        }
        writeln!(buf, "")?;
    }
    Ok(String::from_utf8_lossy(&buf).to_string())
}

struct FieldInfo {
    name: String,
    tp: String,
    is_many: bool,
}
fn get_fields(node: &AstNodeSrc) -> Vec<FieldInfo> {
    let mut result = Vec::new();

    match node.name.as_str() {
        "Name" | "NameRef" | "Lifetime" => {
            result.push(FieldInfo {
                name: "text".to_string(),
                tp: "string".to_string(),
                is_many: false,
            });
        }
        "Abi" => {
            result.push(FieldInfo {
                name: "abi_string".to_string(),
                tp: "string".to_string(),
                is_many: false,
            });
        }
        "Literal" => {
            result.push(FieldInfo {
                name: "text_value".to_string(),
                tp: "string".to_string(),
                is_many: false,
            });
        }
        "PrefixExpr" => {
            result.push(FieldInfo {
                name: "operator_name".to_string(),
                tp: "string".to_string(),
                is_many: false,
            });
        }
        "BinExpr" => {
            result.push(FieldInfo {
                name: "lhs".to_string(),
                tp: "Expr".to_string(),
                is_many: false,
            });
            result.push(FieldInfo {
                name: "rhs".to_string(),
                tp: "Expr".to_string(),
                is_many: false,
            });
            result.push(FieldInfo {
                name: "operator_name".to_string(),
                tp: "string".to_string(),
                is_many: false,
            });
        }
        "IfExpr" => {
            result.push(FieldInfo {
                name: "then_branch".to_string(),
                tp: "BlockExpr".to_string(),
                is_many: false,
            });
            result.push(FieldInfo {
                name: "else_branch".to_string(),
                tp: "ElseBranch".to_string(),
                is_many: false,
            });
            result.push(FieldInfo {
                name: "condition".to_string(),
                tp: "Expr".to_string(),
                is_many: false,
            });
        }
        "RangeExpr" => {
            result.push(FieldInfo {
                name: "start".to_string(),
                tp: "Expr".to_string(),
                is_many: false,
            });
            result.push(FieldInfo {
                name: "end".to_string(),
                tp: "Expr".to_string(),
                is_many: false,
            });
            result.push(FieldInfo {
                name: "operator_name".to_string(),
                tp: "string".to_string(),
                is_many: false,
            });
        }
        "RangePat" => {
            result.push(FieldInfo {
                name: "start".to_string(),
                tp: "Pat".to_string(),
                is_many: false,
            });
            result.push(FieldInfo {
                name: "end".to_string(),
                tp: "Pat".to_string(),
                is_many: false,
            });
            result.push(FieldInfo {
                name: "operator_name".to_string(),
                tp: "string".to_string(),
                is_many: false,
            });
        }
        "IndexExpr" => {
            result.push(FieldInfo {
                name: "index".to_string(),
                tp: "Expr".to_string(),
                is_many: false,
            });
            result.push(FieldInfo {
                name: "base".to_string(),
                tp: "Expr".to_string(),
                is_many: false,
            });
        }
        "Impl" => {
            result.push(FieldInfo {
                name: "trait_".to_string(),
                tp: "Type".to_string(),
                is_many: false,
            });
            result.push(FieldInfo {
                name: "self_ty".to_string(),
                tp: "Type".to_string(),
                is_many: false,
            });
        }
        "ForExpr" => {
            result.push(FieldInfo {
                name: "iterable".to_string(),
                tp: "Expr".to_string(),
                is_many: false,
            });
        }
        "WhileExpr" => {
            result.push(FieldInfo {
                name: "condition".to_string(),
                tp: "Expr".to_string(),
                is_many: false,
            });
        }
        "MatchGuard" => {
            result.push(FieldInfo {
                name: "condition".to_string(),
                tp: "Expr".to_string(),
                is_many: false,
            });
        }
        "MacroDef" => {
            result.push(FieldInfo {
                name: "args".to_string(),
                tp: "TokenTree".to_string(),
                is_many: false,
            });
            result.push(FieldInfo {
                name: "body".to_string(),
                tp: "TokenTree".to_string(),
                is_many: false,
            });
        }
        "FormatArgsExpr" => {
            result.push(FieldInfo {
                name: "args".to_string(),
                tp: "FormatArgsArg".to_string(),
                is_many: true,
            });
        }
        "ArgList" => {
            result.push(FieldInfo {
                name: "args".to_string(),
                tp: "Expr".to_string(),
                is_many: true,
            });
        }
        "Fn" => {
            result.push(FieldInfo {
                name: "body".to_string(),
                tp: "BlockExpr".to_string(),
                is_many: false,
            });
        }
        "Const" => {
            result.push(FieldInfo {
                name: "body".to_string(),
                tp: "Expr".to_string(),
                is_many: false,
            });
        }
        "Static" => {
            result.push(FieldInfo {
                name: "body".to_string(),
                tp: "Expr".to_string(),
                is_many: false,
            });
        }
        "ClosureExpr" => {
            result.push(FieldInfo {
                name: "body".to_string(),
                tp: "Expr".to_string(),
                is_many: false,
            });
        }
        _ => {}
    }

    for field in &node.fields {
        // The ArrayExpr type also has an 'exprs' field
        if node.name == "ArrayExpr" && field.method_name() == "expr" {
            continue;
        }
        result.push(FieldInfo {
            name: field.method_name(),
            tp: field.ty().to_string(),
            is_many: field.is_many(),
        });
    }
    for trait_ in &node.traits {
        match trait_.as_str() {
            "HasAttrs" => result.push(FieldInfo {
                name: "attrs".to_owned(),
                tp: "Attr".to_owned(),
                is_many: true,
            }),
            "HasName" => result.push(FieldInfo {
                name: "name".to_owned(),
                tp: "Name".to_owned(),
                is_many: false,
            }),
            "HasVisibility" => result.push(FieldInfo {
                name: "visibility".to_owned(),
                tp: "Visibility".to_owned(),
                is_many: false,
            }),
            "HasGenericParams" => {
                result.push(FieldInfo {
                    name: "generic_param_list".to_owned(),
                    tp: "GenericParamList".to_owned(),
                    is_many: false,
                });
                result.push(FieldInfo {
                    name: "where_clause".to_owned(),
                    tp: "WhereClause".to_owned(),
                    is_many: false,
                })
            }
            "HasGenericArgs" => result.push(FieldInfo {
                name: "generic_arg_list".to_owned(),
                tp: "GenericArgList".to_owned(),
                is_many: false,
            }),
            "HasTypeBounds" => result.push(FieldInfo {
                name: "type_bound_list".to_owned(),
                tp: "TypeBoundList".to_owned(),
                is_many: false,
            }),
            "HasModuleItem" => result.push(FieldInfo {
                name: "items".to_owned(),
                tp: "Item".to_owned(),
                is_many: true,
            }),
            "HasLoopBody" => {
                result.push(FieldInfo {
                    name: "label".to_owned(),
                    tp: "Label".to_owned(),
                    is_many: false,
                });
                result.push(FieldInfo {
                    name: "loop_body".to_owned(),
                    tp: "BlockExpr".to_owned(),
                    is_many: false,
                })
            }
            "HasArgList" => result.push(FieldInfo {
                name: "arg_list".to_owned(),
                tp: "ArgList".to_owned(),
                is_many: false,
            }),
            "HasDocComments" => {}

            _ => panic!("Unknown trait {}", trait_),
        };
    }
    result.sort_by(|x, y| x.name.cmp(&y.name));
    result
}

fn write_extractor(grammar: &AstSrc) -> std::io::Result<String> {
    let mut buf: Vec<u8> = Vec::new();

    for node in &grammar.enums {
        let type_name = &node.name;
        let class_name = class_name(&node.name);

        writeln!(
            buf,
            "    fn emit_{}(&mut self, node: ast::{}) -> Label<generated::{}> {{",
            to_lower_snake_case(type_name),
            type_name,
            class_name
        )?;
        writeln!(buf, "        match node {{")?;
        for variant in &node.variants {
            writeln!(
                buf,
                "            ast::{}::{}(inner) => self.emit_{}(inner).into(),",
                type_name,
                variant,
                to_lower_snake_case(variant)
            )?;
        }
        writeln!(buf, "        }}")?;
        writeln!(buf, "    }}\n")?;
    }

    for node in &grammar.nodes {
        let type_name = &node.name;
        let class_name = class_name(&node.name);

        writeln!(
            buf,
            "    fn emit_{}(&mut self, node: ast::{}) -> Label<generated::{}> {{",
            to_lower_snake_case(type_name),
            type_name,
            class_name
        )?;
        for field in get_fields(&node) {
            if &field.tp == "SyntaxToken" {
                continue;
            }

            let type_name = &field.tp;
            let struct_field_name = &field.name;
            let class_field_name = property_name(&node.name, &field.name);
            if field.tp == "string" {
                writeln!(
                    buf,
                    "        let {} = node.try_get_text();",
                    class_field_name,
                )?;
            } else if field.is_many {
                writeln!(
                    buf,
                    "        let {} = node.{}().map(|x| self.emit_{}(x)).collect();",
                    class_field_name,
                    struct_field_name,
                    to_lower_snake_case(type_name)
                )?;
            } else {
                writeln!(
                    buf,
                    "        let {} = node.{}().map(|x| self.emit_{}(x));",
                    class_field_name,
                    struct_field_name,
                    to_lower_snake_case(type_name)
                )?;
            }
        }
        writeln!(
            buf,
            "        let label = self.trap.emit(generated::{} {{",
            class_name
        )?;
        writeln!(buf, "            id: TrapId::Star,")?;
        for field in get_fields(&node) {
            if field.tp == "SyntaxToken" {
                continue;
            }

            let class_field_name: String = property_name(&node.name, &field.name);
            writeln!(buf, "            {},", class_field_name)?;
        }
        writeln!(buf, "        }});")?;
        writeln!(buf, "        self.emit_location(label, node);")?;
        writeln!(buf, "        label")?;

        writeln!(buf, "    }}\n")?;
    }
    Ok(String::from_utf8_lossy(&buf).into_owned())
}

fn main() -> std::io::Result<()> {
    let grammar: Grammar = fs::read_to_string(project_root().join("generate-schema/rust.ungram"))
        .unwrap()
        .parse()
        .unwrap();
    let mut grammar = codegen::grammar::lower(&grammar);
    grammar
        .nodes
        .retain(|x| x.name != "MacroStmts" && x.name != "MacroItems");

    grammar.enums.retain(|x| x.name != "Adt");

    let mut super_types: BTreeMap<String, BTreeSet<String>> = BTreeMap::new();
    for node in &grammar.enums {
        for variant in &node.variants {
            let set = super_types
                .entry(variant.to_owned())
                .or_insert_with(|| BTreeSet::new());
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
    let schema_path = PathBuf::from("../schema/ast.py");
    let extractor = write_extractor(&grammar)?;
    print!("{}", extractor);
    codegen::ensure_file_contents(
        crate::flags::CodegenType::Grammar,
        &schema_path,
        &schema,
        false,
    );
    Ok(())
}
