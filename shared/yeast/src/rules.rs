use std::cell::Cell;
use std::rc::Rc;

use crate::{captures::Captures, *};

pub fn rules() -> Vec<Rule> {
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
        match_.insert(
            "tmp_lhs",
            ast.create_named_token("identifier", new_ident.clone()),
        );

        let mut i = 0;
        match_.map_captures_to("left", "assigns", &mut |old_id| {
            let mut local_capture = Captures::new();
            local_capture.insert("lhs", old_id);
            local_capture.insert(
                "tmp",
                ast.create_named_token("identifier", new_ident.clone()),
            );
            let index: i32 = i;
            i += 1;
            local_capture.insert(
                "index",
                ast.create_named_token("integer", index.to_string()),
            );
            tree_builder!(
                (assignment
                    left: (@lhs)
                    right: (
                        element_reference
                            object: (@tmp)
                            child: (@index)
                    )
                )
            )
            .build_tree(ast, &local_capture)
            .unwrap()
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
        match_.insert(
            "tmp_rhs",
            ast.create_named_token("identifier", new_ident.clone()),
        );
        match_.insert(
            "tmp_param",
            ast.create_named_token("identifier", new_ident.clone()),
        );
        match_.insert(
            "each",
            ast.create_named_token("identifier", "each".to_string()),
        );

        trees_builder!(
            (call
                receiver: (@val)
                method: (@each)
                block: (block
                    parameters: (
                        block_parameters
                            child: (@tmp_param)
                    )
                    body: (block_body
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

        )
        .build_trees(ast, &match_)
        .unwrap()
    };

    let for_rule = Rule::new(for_query, Box::new(for_transform));

    // Just get rid of all end tokens as they aren't needed
    let end_query = query!(("end"));
    let end_transform = |_ast: &mut Ast, _match: Captures| vec![];
    let end_rule = Rule::new(end_query, Box::new(end_transform));
    vec![assign_rule, for_rule, end_rule]
}
