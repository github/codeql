class TAstNodeParent = @file or @ruby_ast_node;

abstract class AstNodeParent extends TAstNodeParent {
  string toString() { none() }
}

class AstNode extends AstNodeParent, @ruby_ast_node { }

class File extends AstNodeParent, @file { }

class Location extends @location_default {
  string toString() { none() }
}

pragma[nomagic]
predicate hasFileParent(
  AstNode n, File f, int startline, int startcolumn, int endline, int endcolumn
) {
  exists(Location loc |
    not ruby_ast_node_parent(n, _, _) and
    ruby_ast_node_location(n, loc) and
    locations_default(loc, f, startline, startcolumn, endline, endcolumn)
  )
}

pragma[nomagic]
predicate hasFileParent(AstNode n, File f, int i) {
  n =
    rank[i + 1](AstNode n0, int startline, int startcolumn, int endline, int endcolumn |
      hasFileParent(n0, f, startline, startcolumn, endline, endcolumn)
    |
      n0 order by startline, startcolumn, endline, endcolumn
    )
}

from AstNode n, AstNodeParent parent, int i, Location location
where
  ruby_ast_node_location(n, location) and
  (
    ruby_ast_node_parent(n, parent, i)
    or
    hasFileParent(n, parent, i)
  )
select n, parent, i, location
