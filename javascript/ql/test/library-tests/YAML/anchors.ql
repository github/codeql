import semmle.javascript.YAML

from YAMLNode n
select n, n.getAnchor()
