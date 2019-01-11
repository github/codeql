import javascript

from JSDocTag t
where
  t.getTitle() = "param" and
  not exists(t.getName())
select t, "@param tag is missing name."
