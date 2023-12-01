//#![feature(trace_macros)]
#![cfg(test)]
use std::cell::Cell;
use std::path::Path;
use std::rc::Rc;

use yeast::{captures::Captures, print::Printer, *};

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

    let fresh_ids = Rc::new(Cell::new(0));
    let fresh_ids2: Rc<Cell<i32>> = fresh_ids.clone();

    let assign_query = query!(
            (assignment
                left: (
                    left_assignment_list child*: ((((identifier) @ left) (",")?)*)
                )
                right: (@right)
            )
    );
    let assign_transform = move |ast: &mut Ast, mut match_: Captures| {
        println!("match: {:?}", match_);
        let fresh = fresh_ids.get();
        fresh_ids.set(fresh + 1);

        let new_ident = format!("tmp-{}", fresh);
        match_.insert("tmp_lhs", ast.create_named_token("identifier", new_ident.clone()));

        let mut i = 0;
        match_.map_captures_to("left", "assigns", &mut |old_id| {
            let mut local_capture = Captures::new();
            local_capture.insert("lhs", old_id);
            local_capture.insert("tmp", ast.create_named_token("identifier", new_ident.clone()));
            let index: i32 = i;
            i += 1;
            local_capture.insert("index", ast.create_named_token("integer", index.to_string()));
            return tree_builder!(
                (assignment
                    left: (identifier child: (@lhs))
                    right: (
                        element_reference
                            left: (@tmp)
                            right: (@index)
                    )
                )
            )
            .build_tree(ast, &local_capture)
            .unwrap();
        });

        // construct the new tree here maybe
        // captures is probably a HashMap from capture name to AST node
        trees_builder!(
            (assignment
                left: (@tmp_lhs)
                right: (@right)
            )
            (
                @assigns
            )*
        )
        .build_trees(ast, &match_)
        .unwrap()
    };

    let assign_rule = Rule::new(assign_query, Box::new(assign_transform));

    // TODO: There is a spurious end token
    let for_query = query!(
        (for
            pattern: (@pat)
            value: (in child*: ("in" @val))
            body: (do child*: (("do")? (@body)*))
        )
    );
    let for_transform = move |ast: &mut Ast, mut match_: Captures| {
        let fresh = fresh_ids2.get();
        fresh_ids2.set(fresh + 1);

        let new_ident = format!("tmp-{}", fresh);
        match_.insert("tmp_rhs", ast.create_named_token("identifier", new_ident.clone()));
        match_.insert(
            "tmp_param",
            ast.create_named_token("identifier", new_ident.clone()),
        );
        match_.insert("each", ast.create_named_token("identifier", "each".to_string()));

        // construct the new tree here maybe
        // captures is probably a HashMap from capture name to AST node
        trees_builder!(
            (call
                receiver: (@val)
                method: (@each)
                block: (block
                    parameters: (
                        block_parameters 
                            child: (@tmp_param)
                    )
                    child*: (
                        (assignment
                            left: (@pat)
                            right: (@tmp_rhs)
                        )
                        (@body)*
                    )
                )
            )
            
        )
        .build_trees(ast, &match_)
        .unwrap()
    };

    let for_rule = Rule::new(for_query, Box::new(for_transform));

    // Just get rid of all end tokens as they aren't needed
    let end_query = query!(
        ("end")
    );
    let end_transform = |_ast: &mut Ast, _match: Captures| {
        return vec![];
    };
    let end_rule = Rule::new(end_query, Box::new(end_transform));

    let input = "for a, b in pairs_list do\n  call(a, b)\n  a+=b\nend";

    // Construct the thing that runs our desugaring process
    let runner = Runner::new(tree_sitter_ruby::language(), vec![assign_rule, for_rule, end_rule]);

    let old_root = 0;

    // Run it on our example
    let ast = runner.run(input);
    let new_root = ast.get_root();

    let formattedInput = serde_json::to_string_pretty(&ast.print(&input, old_root)).unwrap();
    let formattedOutput = serde_json::to_string_pretty(&ast.print(&input, new_root)).unwrap();

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
    let ast = runner.run(&input);
    let parsed_actual = serde_json::to_string_pretty(&ast.print(&input, ast.get_root())).unwrap();

    assert_eq!(parsed_actual, parsed_expected);
}

#[test]
fn test_query_input() {
    let input = std::fs::read_to_string("tests/fixtures/1.rb").unwrap();
    let rewritten_expected = std::fs::read_to_string("tests/fixtures/1.rewritten.json").unwrap();

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
fn test_output() {
    let input = std::fs::read_to_string("tests/fixtures/1.rb").unwrap();
    let parsed_expected = std::fs::read_to_string("tests/fixtures/1.parsed.json").unwrap();

    let runner = Runner::new(tree_sitter_ruby::language(), vec![]);
    let ast = runner.run(&input);
    let cursor = AstCursor::new(&ast);
    let mut printer = Printer {};
    printer.visit(cursor);
    panic!()
}

#[test]
fn test_cursor() {
    let input = std::fs::read_to_string("tests/fixtures/1.rb").unwrap();

    let runner = Runner::new(tree_sitter_ruby::language(), vec![]);
    let ast = runner.run(&input);
    let mut cursor = AstCursor::new(&ast);

    assert_eq!(cursor.node().id(), ast.get_root());
    assert_eq!(cursor.field_id(), None);

    assert_eq!(cursor.goto_first_child(), true);
    assert_eq!(cursor.node().id(), 26);

    assert_eq!(cursor.goto_next_sibling(), false);
    assert_eq!(cursor.node().id(), 26);

    assert_eq!(cursor.goto_first_child(), true);
    assert_eq!(cursor.node().id(), 19);

    assert_eq!(cursor.goto_first_child(), true);
    assert_eq!(cursor.node().id(), 14);

    assert_eq!(cursor.goto_first_child(), false);
    assert_eq!(cursor.node().id(), 14);

    assert_eq!(cursor.goto_next_sibling(), true);
    assert_eq!(cursor.node().id(), 15);
    assert_eq!(cursor.field_id(), Some(CHILD_FIELD));

    assert_eq!(cursor.goto_parent(), true);
    assert_eq!(cursor.node().id(), 19);

    assert_eq!(cursor.field_id(), Some(18));

    let cursor = AstCursor::new(&ast);
    let mut printer = Printer {};
    printer.visit(cursor);
}
