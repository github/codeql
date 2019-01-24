import semmle.javascript.YAML

from YAMLMapping m, YAMLValue k, YAMLValue v
where m.maps(k, v)
select m, k, v
