class ScopeResolutionMethodCall extends @ruby_call {
  private @ruby_scope_resolution scope;

  ScopeResolutionMethodCall() { ruby_call_def(this, scope) }

  @ruby_scope_resolution getScopeResolution() { result = scope }

  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

class RubyAstNode extends @ruby_ast_node {
  string toString() { none() }
}

class RubyAstNodeParent extends @ruby_ast_node_parent {
  string toString() { none() }
}

from RubyAstNode node, RubyAstNodeParent parent, int index, Location loc
where
  ruby_ast_node_info(node, parent, index, loc) and
  not node = any(ScopeResolutionMethodCall c).getScopeResolution() and
  not parent = any(ScopeResolutionMethodCall c) and
  not parent = any(ScopeResolutionMethodCall c).getScopeResolution()
  or
  ruby_ast_node_info(node, _, _, loc) and
  parent instanceof ScopeResolutionMethodCall and
  node =
    rank[index + 1](RubyAstNode child, int x, int oldIndex |
      exists(RubyAstNodeParent oldParent |
        ruby_ast_node_info(child, oldParent, oldIndex, _) and
        child != parent.(ScopeResolutionMethodCall).getScopeResolution()
      |
        oldParent = parent and x = 1
        or
        oldParent = parent.(ScopeResolutionMethodCall).getScopeResolution() and x = 0
      )
    |
      child order by x, oldIndex
    )
select node, parent, index, loc
