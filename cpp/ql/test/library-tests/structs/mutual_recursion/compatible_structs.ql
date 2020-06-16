import cpp

from Struct s, string distinct
where
  distinct =
    count(Struct x | x.getName() = s.getName()) + " different struct(s) called " + s.getName()
select s, distinct
