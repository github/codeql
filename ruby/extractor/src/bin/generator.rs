use clap::arg;
use std::fs::File;
use std::io::LineWriter;
use std::io::Write;
use std::path::PathBuf;

use codeql_extractor::generator::{
    convert_nodes, create_ast_node_info_table, create_container_union,
    create_containerparent_table, create_diagnostics, create_files_table, create_folders_table,
    create_location_union, create_locations_default_table, create_source_location_prefix_table,
    create_token_case, create_tokeninfo, dbscheme, language::Language, ql, ql_gen,
};
use codeql_extractor::node_types;

fn main() -> std::io::Result<()> {
    tracing_subscriber::fmt()
        .with_target(false)
        .without_time()
        .with_level(true)
        .with_env_filter(tracing_subscriber::EnvFilter::from_default_env())
        .init();

    let matches = clap::App::new("Ruby dbscheme generator")
        .version("1.0")
        .author("GitHub")
        .about("CodeQL Ruby dbscheme generator")
        .arg(arg!(--dbscheme <FILE>                  "Path of the generated dbscheme file"))
        .arg(arg!(--library <FILE>                   "Path of the generated QLL file"))
        .get_matches();
    let dbscheme_path = matches.value_of("dbscheme").expect("missing --dbscheme");
    let dbscheme_path = PathBuf::from(dbscheme_path);

    let ql_library_path = matches.value_of("library").expect("missing --library");
    let ql_library_path = PathBuf::from(ql_library_path);

    let languages = vec![
        Language {
            name: "Ruby".to_owned(),
            node_types: tree_sitter_ruby::NODE_TYPES,
        },
        Language {
            name: "Erb".to_owned(),
            node_types: tree_sitter_embedded_template::NODE_TYPES,
        },
    ];

    let dbscheme_file = File::create(dbscheme_path).map_err(|e| {
        tracing::error!("Failed to create dbscheme file: {}", e);
        e
    })?;
    let mut dbscheme_writer = LineWriter::new(dbscheme_file);
    write!(
        dbscheme_writer,
        "// CodeQL database schema for {}\n\
         // Automatically generated from the tree-sitter grammar; do not edit\n\n",
        languages[0].name
    )?;
    let (diagnostics_case, diagnostics_table) = create_diagnostics();
    dbscheme::write(
        &mut dbscheme_writer,
        &[
            create_location_union(),
            create_locations_default_table(),
            create_files_table(),
            create_folders_table(),
            create_container_union(),
            create_containerparent_table(),
            create_source_location_prefix_table(),
            dbscheme::Entry::Table(diagnostics_table),
            dbscheme::Entry::Case(diagnostics_case),
        ],
    )?;

    let ql_library_file = File::create(ql_library_path).map_err(|e| {
        tracing::error!("Failed to create ql library file: {}", e);
        e
    })?;
    let mut ql_writer = LineWriter::new(ql_library_file);
    write!(
        ql_writer,
        "/**\n\
          * CodeQL library for {}
          * Automatically generated from the tree-sitter grammar; do not edit\n\
          */\n\n",
        languages[0].name
    )?;
    ql::write(
        &mut ql_writer,
        &[ql::TopLevel::Import(ql::Import {
            module: "codeql.Locations",
            alias: Some("L"),
        })],
    )?;

    for language in languages {
        let prefix = node_types::to_snake_case(&language.name);
        let ast_node_name = format!("{}_ast_node", &prefix);
        let node_info_table_name = format!("{}_ast_node_info", &prefix);
        let ast_node_parent_name = format!("{}_ast_node_parent", &prefix);
        let token_name = format!("{}_token", &prefix);
        let tokeninfo_name = format!("{}_tokeninfo", &prefix);
        let reserved_word_name = format!("{}_reserved_word", &prefix);
        let nodes = node_types::read_node_types_str(&prefix, language.node_types)?;
        let (dbscheme_entries, mut ast_node_members, token_kinds) = convert_nodes(&nodes);
        ast_node_members.insert(&token_name);
        dbscheme::write(&mut dbscheme_writer, &dbscheme_entries)?;
        let token_case = create_token_case(&token_name, token_kinds);
        dbscheme::write(
            &mut dbscheme_writer,
            &[
                dbscheme::Entry::Table(create_tokeninfo(&tokeninfo_name, &token_name)),
                dbscheme::Entry::Case(token_case),
                dbscheme::Entry::Union(dbscheme::Union {
                    name: &ast_node_name,
                    members: ast_node_members,
                }),
                dbscheme::Entry::Union(dbscheme::Union {
                    name: &ast_node_parent_name,
                    members: [&ast_node_name, "file"].iter().cloned().collect(),
                }),
                dbscheme::Entry::Table(create_ast_node_info_table(
                    &node_info_table_name,
                    &ast_node_parent_name,
                    &ast_node_name,
                )),
            ],
        )?;

        let mut body = vec![
            ql::TopLevel::Class(ql_gen::create_ast_node_class(
                &ast_node_name,
                &node_info_table_name,
            )),
            ql::TopLevel::Class(ql_gen::create_token_class(&token_name, &tokeninfo_name)),
            ql::TopLevel::Class(ql_gen::create_reserved_word_class(&reserved_word_name)),
        ];
        body.append(&mut ql_gen::convert_nodes(&nodes));
        ql::write(
            &mut ql_writer,
            &[ql::TopLevel::Module(ql::Module {
                qldoc: None,
                name: &language.name,
                body,
            })],
        )?;
    }
    Ok(())
}
