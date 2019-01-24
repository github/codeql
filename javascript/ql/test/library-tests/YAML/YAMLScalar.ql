import semmle.javascript.YAML

from YAMLScalar s
select s, s.getStyle(), s.getValue()
