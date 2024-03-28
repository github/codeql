import codeql.ruby.frameworks.Gemfile

query predicate gemCalls(
  Gemfile::Gem gem, string name, Gemfile::VersionConstraint constraint, string version
) {
  name = gem.getName() and
  constraint = gem.getAVersionConstraint() and
  version = constraint.getVersion()
}

query predicate versionBefore(string before, string after) {
  exists(Gemfile::VersionConstraint c1, Gemfile::VersionConstraint c2 |
    c1.getVersion() = before and c2.getVersion() = after
  |
    c1.getVersion().before(after)
  )
}
