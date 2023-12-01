#![cfg(test)]
use std::cell::Cell;
use std::fs::read_to_string;
use std::path::Path;
use std::rc::Rc;

use yeast::{captures::Captures, print::Printer, *, rules::rules};

#[test]
fn test_ruby_multiple_assignment() {
    // We want to convert this
    //
    // x, y, z = e
    //
    // into this
    //
    // tmp = e
    // x = tmp[0]
    // y = tmp[1]
    // z = tmp[2]

    // Define a desugaring rule, which is a query together with a transformation.

    let input = "for a, b in pairs_list do\n  x=y\nend";

    // Construct the thing that runs our desugaring process
    let runner = Runner::new(
        tree_sitter_ruby::language(),
        rules(),
    );

    let old_root = 0;

    // Run it on our example
    let ast = runner.run(input);
    let new_root = ast.get_root();

    let formattedInput = serde_json::to_string_pretty(&ast.print(input, old_root)).unwrap();
    let formattedOutput = serde_json::to_string_pretty(&ast.print(input, new_root)).unwrap();

    println!("before transformation: {}", formattedInput);
    println!("after transformation: {}", formattedOutput);

    assert_eq!(
        formattedInput,
        read_to_string("tests/fixtures/multiple_assignment.input.json").unwrap()
    );
    assert_eq!(
        formattedOutput,
        read_to_string("tests/fixtures/multiple_assignment.output.json").unwrap()
    );
}

#[test]
fn test_parse_input() {
    let input = read_to_string("tests/fixtures/1.rb").unwrap();
    let parsed_expected = read_to_string("tests/fixtures/1.parsed.json").unwrap();

    let runner = Runner::new(tree_sitter_ruby::language(), vec![]);
    let ast = runner.run(&input);
    let parsed_actual = serde_json::to_string_pretty(&ast.print(&input, ast.get_root())).unwrap();

    assert_eq!(parsed_actual, parsed_expected);
}

#[test]
fn test_query_input() {
    let input = read_to_string("tests/fixtures/1.rb").unwrap();
    let rewritten_expected = read_to_string("tests/fixtures/1.rewritten.json").unwrap();

    let runner = Runner::new(tree_sitter_ruby::language(), vec![]);
    let mut ast = runner.run(&input);

    let query = yeast::query::query!(
        program  child:(
            (assignment
                left: (@left)
                right: (@right)
                child*: ((@rest)*)
            )

        )
    );
    print!("query: {:?}", query);

    let mut matches = Captures::new();
    if query.do_match(&ast, ast.get_root(), &mut matches).unwrap() {
        println!("match: {:?}", matches);
    } else {
        println!("no match");
    }

    let builder = yeast::tree_builder::tree_builder!(
        program child:
            (assignment
                left: (@right)
                right: (@left)
                child*:((@rest)*)
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

#[test]
fn test_cursor() {
    let input = read_to_string("tests/fixtures/1.rb").unwrap();

    let runner = Runner::new(tree_sitter_ruby::language(), vec![]);
    let ast = runner.run(&input);
    let mut cursor = AstCursor::new(&ast);

    assert_eq!(cursor.node().id(), ast.get_root());
    assert_eq!(cursor.field_id(), None);

    assert!(cursor.goto_first_child());
    assert_eq!(cursor.node().id(), 26);

    assert!(!cursor.goto_next_sibling());
    assert_eq!(cursor.node().id(), 26);

    assert!(cursor.goto_first_child());
    assert_eq!(cursor.node().id(), 19);

    assert!(cursor.goto_first_child());
    assert_eq!(cursor.node().id(), 14);

    assert!(!cursor.goto_first_child());
    assert_eq!(cursor.node().id(), 14);

    assert!(cursor.goto_next_sibling());
    assert_eq!(cursor.node().id(), 15);
    assert_eq!(cursor.field_id(), Some(CHILD_FIELD));

    assert!(cursor.goto_parent());
    assert_eq!(cursor.node().id(), 19);

    assert_eq!(cursor.field_id(), Some(18));

    let cursor = AstCursor::new(&ast);
    let mut printer = Printer {};
    printer.visit(cursor);
}
