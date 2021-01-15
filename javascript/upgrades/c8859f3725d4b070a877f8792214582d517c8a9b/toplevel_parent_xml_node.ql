class TopLevel extends @toplevel {
  string toString() { none() }
}

class XmlNode extends @xmllocatable {
  string toString() { none() }
}

// Based on previous implementation on HTMLNode.getCodeInAttribute and getInlineScript
from
  TopLevel top, XmlNode xml, @file f, @location l1, int sl1, int sc1, int el1, int ec1,
  @location l2, int sl2, int sc2, int el2, int ec2
where
  xmllocations(xml, l1) and
  hasLocation(top, l2) and
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
