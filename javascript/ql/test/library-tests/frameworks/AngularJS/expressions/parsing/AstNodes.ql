import javascript
private import AngularJS

from NgSourceProvider provider, NgAst n, NgToken start, NgSource src
where
  provider.providesSourceAt(src.getText(), _, _, _, _, _) and n.at(start, _) and start.at(src, _)
select provider, n
