import cpp

int relativeLine(Locatable first, Locatable second) {
  result = second.getLocation().getStartLine() - first.getLocation().getStartLine()
}

from Class c, FriendDecl d
where
  c.getName().matches("Outer%") and
  d = c.getAFriendDecl()
select c.toString(), d.getFriend().toString(), relativeLine(c, d)
