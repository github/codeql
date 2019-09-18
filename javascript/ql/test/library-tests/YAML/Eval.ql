import semmle.javascript.YAML

from YAMLNode n
where not n.eval() = n
select n, n.eval()
