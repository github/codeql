import csharp

string elementToString(Element e) {
  if exists(e.toString()) then result = e.toString() else result = "unknown"
}

from Call c, string target
where if exists(c.getTarget()) then target = c.getTarget().toString() else target = "none"
select c.getLocation(), elementToString(c), target
