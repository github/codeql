import csharp

query predicate regionDirectives(RegionDirective d, string name, EndRegionDirective end) {
  d.getName() = name and
  d.getEnd() = end
}
