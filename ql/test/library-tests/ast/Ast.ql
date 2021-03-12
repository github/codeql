/**
 * @kind graph
 */

import codeql_ruby.printAst as P

query predicate nodes = P::nodes/3;

query predicate graphProperties = P::graphProperties/2;

query predicate edges(P::PrintAstNode source, P::PrintAstNode target, string key, string value) {
  P::edges(source, target, key, value)
  or
  P::edges(source, target, _, _) and
  key = "semmle.order" and
  value = target.(OrderedAstNode).getProperty("semmle.order")
}

class OrderedAstNode extends P::PrintAstNode {
  override string getProperty(string key) {
    result = super.getProperty(key)
    or
    key = "semmle.order" and
    result =
      any(int i |
        this =
          rank[i](P::AstNode p |
            |
            p
            order by
              p.getLocation().getFile().getBaseName(), p.getLocation().getFile().getAbsolutePath(),
              p.getLocation().getStartLine(), p.getLocation().getStartColumn()
          )
      ).toString()
  }
}
