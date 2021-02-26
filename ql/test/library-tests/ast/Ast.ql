/**
 * @kind graph
 */

import codeql_ruby.printAst

class OrderedAstNode extends PrintAstNode {
  override string getProperty(string key) {
    result = super.getProperty(key)
    or
    key = "semmle.order" and
    result =
      any(int i |
        this =
          rank[i](AstNode p |
            |
            p
            order by
              p.getLocation().getFile().getBaseName(), p.getLocation().getFile().getAbsolutePath(),
              p.getLocation().getStartLine()
          )
      ).toString()
  }
}
