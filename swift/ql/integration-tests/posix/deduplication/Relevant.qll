import swift

predicate relevant(Locatable loc) {
  loc.getLocation().getFile().getName().matches("%/swift/ql/integration-tests/%/Sources/%")
}
