from int i, int j
where
  i in [1, 2] and
  j in [1, 2] and
  not (i = 2 and j = 2)
select "#select", i, j, "foo"
