use crate::{cursor::Cursor, AstCursor, Node};

pub struct Printer {}

impl Printer {
    pub fn visit<'a>(&mut self, mut cursor: AstCursor<'a>) {
        self.enter_node(cursor.node());
        let mut recurse = true;
        loop {
            if recurse && cursor.goto_first_child() {
                recurse = self.enter_node(cursor.node());
            } else {
                self.leave_node(cursor.node());

                if cursor.goto_next_sibling() {
                    recurse = self.enter_node(cursor.node());
                } else if cursor.goto_parent() {
                    recurse = false;
                } else {
                    break;
                }
            }
        }
    }

    pub fn enter_node(&mut self, node: &Node) -> bool {
        println!("enter_node: {:?}", node);
        true
    }
    pub fn leave_node(&mut self, node: &Node) -> bool {
        println!("leave_node: {:?}", node);
        true
    }
}
