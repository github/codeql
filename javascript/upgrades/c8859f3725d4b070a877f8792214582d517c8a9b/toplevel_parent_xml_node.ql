class Location extends @location {
  string toString() { none() }

  predicate startsAtLine(@file file, int line) { locations_default(this, file, line, _, _, _) }
}

class TopLevel extends @toplevel {
  string toString() { none() }

  Location getLocation() { hasLocation(this, result) }

  pragma[nomagic]
  predicate startsAtLine(@file file, int line) { getLocation().startsAtLine(file, line) }
}

class XmlNode extends @xmllocatable {
  string toString() { none() }

  Location getLocation() { xmllocations(this, result) }

  pragma[nomagic]
  predicate startsAtLine(@file file, int line) { getLocation().startsAtLine(file, line) }
}

// Based on previous implementation on HTMLNode.getCodeInAttribute and getInlineScript,
// with `startsAtLine` added for performance reasons.
from
  TopLevel top, XmlNode xml, @file f, Location l1, int sl1, int sc1, int el1, int ec1, Location l2,
  int sl2, int sc2, int el2, int ec2
where
  l1 = xml.getLocation() and
  l2 = top.getLocation() and
  xml.startsAtLine(f, sl1) and
  top.startsAtLine(f, [sl1, sl1 + 1]) and
  locations_default(l1, f, sl1, sc1, el1, ec1) and
  locations_default(l2, f, sl2, sc2, el2, ec2) and
  (
    (
      sl1 = sl2 and sc1 < sc2
      or
      sl1 < sl2
    ) and
    (
      el1 = el2 and ec1 > ec2
      or
      el1 > el2
    )
  )
select top, xml
