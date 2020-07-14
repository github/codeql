class StaticAssert extends @static_assert {
  string toString() { none() }
}

class Expr extends @expr {
  string toString() { none() }
}

class Location extends @location_default {
  string toString() { none() }
}

class NameSpace extends @namespace {
  string toString() { none() }
}

from StaticAssert sa, Expr condition, string message, Location loc, NameSpace ns
where
  static_asserts(sa, condition, message, loc) and
  namespaces(ns, "")
select sa, condition, message, loc, ns
