private import csharp

private SourceLocation fromMappedLocation(SourceLocation loc) { result.getMappedLocation() = loc }

pragma[nomagic]
private Location unmap(Location l, File f) {
  (
    result = fromMappedLocation(l)
    or
    not exists(fromMappedLocation(l)) and
    result = l
  ) and
  f = result.getFile()
}

bindingset[l1, l2]
pragma[inline_late]
private predicate inSameFile0(Location l1, Location l2) { l1.getFile() = l2.getFile() }

/** Holds if `l1` and `l2` are in the same file. */
bindingset[l1, l2]
pragma[inline_late]
predicate inSameFile(Location l1, Location l2) { inSameFile0(unmap(l1, _), unmap(l2, _)) }

/** Gets a source location for `e`, if any. */
pragma[nomagic]
SourceLocation getASourceLocation(Element e) {
  result = e.getALocation() and
  not exists(result.getMappedLocation())
  or
  result = e.getALocation().(SourceLocation).getMappedLocation()
}

/** Provides the input to `NearestLocation`. */
signature module NearestLocationInputSig {
  class C {
    string toString();

    Location getLocation();
  }

  predicate relevantLocations(C c, Location l1, Location l2);
}

module NearestLocation<NearestLocationInputSig Input> {
  pragma[nomagic]
  private predicate relevantLocationsUnmapped(
    Input::C c, Location l1, Location l2, Location l1unmapped
  ) {
    exists(Location l2unmapped, File f |
      Input::relevantLocations(c, pragma[only_bind_into](l1), pragma[only_bind_into](l2)) and
      l1unmapped = unmap(l1, f) and
      l2unmapped = unmap(l2, f) and
      l1unmapped.before(l2unmapped)
    )
  }

  /**
   * Holds if `l1` is the location nearest to (and before) `l2` amongst
   * all locations `l` such that `Input::relevantLocations(c, l, l2)` holds.
   */
  pragma[nomagic]
  predicate nearestLocation(Input::C c, Location l1, Location l2) {
    l1 =
      max(Location loc, Location l1unmapped, int startline1, int startcolumn1 |
        relevantLocationsUnmapped(c, loc, l2, l1unmapped) and
        l1unmapped.hasLocationInfo(_, startline1, startcolumn1, _, _)
      |
        loc order by startline1, startcolumn1
      )
  }
}
