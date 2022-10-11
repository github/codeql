class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

/*
 * It's not possible to generate fresh IDs for the new ruby_block_body nodes,
 * therefore we re-purpose the "}"-token that closes the block and use its ID instead.
 * As a result the AST will be missing the "}" tokens, but those are unlikely to be used
 * for anything.
 */

from AstNode ruby_block, AstNode body
where
  ruby_block_def(ruby_block) and
  ruby_ast_node_info(body, ruby_block, _, _) and
  ruby_tokeninfo(body, _, "}") and
  ruby_block_child(ruby_block, _, _)
select body
