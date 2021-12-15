import javascript
private import AngularJS

from NgDataFlowNode node, NgToken token, NgSource source, string prettyLocation
where
  // get a source location to distinguish identical sources
  node.getAstNode().at(token, _) and
  token.at(source, _) and
  prettyLocation = source.getProvider().getLocation().toString() and
  // limit output
  node instanceof NgVarExpr
select prettyLocation, node, node.getAScope()
