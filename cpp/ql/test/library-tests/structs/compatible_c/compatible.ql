import cpp

from Struct s, int i, string m, string members, string locations
where
  (if exists(s.getAMember()) then m = s.getAMember(i).toString() else (m = "<none>" and i = -1)) and
  members = count(s.getAMember()) + " members" and
  locations = count(s.getLocation()) + " locations"
select s, members, locations, i, m
