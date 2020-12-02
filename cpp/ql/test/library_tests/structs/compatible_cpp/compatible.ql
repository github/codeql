import cpp

from Class c, int i, string m, string members, string locations
where
  (if exists(c.getAMember()) then m = c.getAMember(i).toString() else (m = "<none>" and i = -1)) and
  members = count(c.getAMember()) + " members" and
  locations = count(c.getLocation()) + " locations"
select c, members, locations, i, m
