#![cfg(test)]
use std::path::Path;

use yeast::captures::Captures;
use yeast::*;
#[test]
fn test_ruby_multiple_assignment() {
    // We want to convert this
    //
    // x, y, z = e
    //
    // into this
    //
    // __tmp_1 = e
    // x = __tmp_1[0]
    // y = __tmp_1[1]
    // z = __tmp_1[2]

    // Define a desugaring rule, which is a query together with a transformation.

    /* List all  node kinds
    for i in 0..1000 {
        match tree_sitter_ruby::language().node_kind_for_id(i) {
            Some(name) => println!("{}", name),
            None => {}
        }
    }*/

    let conjuncts = vec![
        Query::NodeKind {
            kind: tree_sitter_ruby::language().id_for_node_kind("left_assignment_list", true),
        },
        Query::MultipleChildren
    ];

    let query = Query::Conjunction { conjuncts };

    let transform = |ast: &mut Ast, match_: Match| {
        let mut newChildren = Vec::new();
        newChildren.push(ast.nodes[match_.node].children[0]);

        let newNode = Node {
            id: ast.nodes.len(),
            kind: ast.nodes[match_.node].kind,
            children: newChildren,
            fields: ast.nodes[match_.node].fields.clone(),
            content: ast.nodes[match_.node].content.clone(),
        };

        ast.nodes.push(newNode);

        return ast.nodes.len() - 1;
    };

    let rule = Rule::new(query, Box::new(transform));

    let input = "x, y, z = e";

    // Construct the thing that runs our desugaring process
    let runner = Runner::new(tree_sitter_ruby::language(), vec![rule]);

    // Run it on our example
    let (ast, newRootId) = runner.run(input);

    let formattedInput = serde_json::to_string_pretty(&ast.print(&input, 0)).unwrap();
    let formattedOutput = serde_json::to_string_pretty(&ast.print(&input, newRootId)).unwrap();

    println!("before transformation: {}", formattedInput);
    println!("after transformation: {}", formattedOutput);

    // we could create a macro for this
    // let expected_output = ast! {
    //     assignment {
    //         left: identifier { name: "__tmp" },
    //         right: identifier { name: "e" },
    //     },
    //     assignment {
    //         left: identifier { name: "x" },
    //         right: element_reference {
    //             object: identifier { name: "__tmp" },
    //             index: integer(0)
    //         },
    //     },
    //     assignment {
    //         left: identifier { name: "y" },
    //         right: element_reference {
    //             object: identifier { name: "__tmp" },
    //             index: integer(1)
    //         },
    //     },
    //     assignment {
    //         left: identifier { name: "z" },
    //         right: element_reference {
    //             object: identifier { name: "__tmp" },
    //             index: integer(2)
    //         },
    //     },
    // };
    let expected_output = todo!();

    assert_eq!(ast, expected_output);
}

#[test]
fn test_parse_input() {
    let input = std::fs::read_to_string("tests/fixtures/1.rb").unwrap();
    let parsed_expected = std::fs::read_to_string("tests/fixtures/1.parsed.json").unwrap();

    let runner = Runner::new(tree_sitter_ruby::language(), vec![]);
    let (ast, newRootId) = runner.run(&input);
    let parsed_actual = serde_json::to_string_pretty(&ast.print(&input, newRootId)).unwrap();

    assert_eq!(parsed_actual, parsed_expected);
}

#[test]
fn test_query_input() {
    let input = std::fs::read_to_string("tests/fixtures/1.rb").unwrap();
    let rewritten_expected = std::fs::read_to_string("tests/fixtures/1.rewritten.json").unwrap();

    let runner = Runner::new(tree_sitter_ruby::language(), vec![]);
    let (mut ast, root) = runner.run(&input);

    let query = yeast::query::query!(
        program (
            (assignment
                left: (@left)
                right: (@right)
                (@rest)*
            )
        )
    );
    print!("query: {:?}", query);

    let mut matches = Captures::new();
    if query.do_match(&ast, root, &mut matches).unwrap() {
        println!("match: {:?}", matches);
    } else {
        println!("no match");
    }

    let builder = yeast::tree_builder::tree_builder!(
        program (
            (assignment
                left: (@right)
                right: (@left)
                (@rest)*
            )
        )
    );

    let new_id = builder.build_tree(&mut ast, &matches).unwrap();

    let rewritten_actual = serde_json::to_string_pretty(&ast.print(&input, new_id)).unwrap();

    write_expected("tests/fixtures/1.rewritten.json", &rewritten_actual);
    assert_eq!(rewritten_actual, rewritten_expected);
}

/// Useful for updating fixtures
/// ```
/// write_expected("tests/fixtures/1.parsed.json", &parsed_actual);
/// ```
fn write_expected<P: AsRef<Path>>(file: P, content: &str) {
    use std::io::Write;
    std::fs::File::create(file)
        .unwrap()
        .write_all(content.as_bytes())
        .unwrap();
}
