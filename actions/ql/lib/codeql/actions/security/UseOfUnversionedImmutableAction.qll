import actions

class UnversionedImmutableAction extends UsesStep {
  UnversionedImmutableAction() {
    isImmutableAction(this, _) and
    not isSemVer(this.getVersion())
  }
}

/**
 * Holds if `version` is a complete SemVer version (`X.Y.Z`, optionally with a `v` prefix,
 * pre-release and build metadata), as opposed to a floating tag such as `v4` or `v4.1`.
 *
 * Only complete version tags (and full commit SHAs) of an immutable Action are immutable.
 * Floating tags are moved by the Action's maintainers and so can change under a consumer.
 */
bindingset[version]
predicate isFullSemVer(string version) {
  // https://semver.org/#is-there-a-suggested-regular-expression-regex-to-check-a-semver-string with optional v prefix
  version
      .regexpMatch("^v?(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?$")
}

bindingset[version]
predicate isSemVer(string version) {
  isFullSemVer(version) or
  // or N or N.x or N.N.x with optional v prefix
  version.regexpMatch("^v?[1-9]\\d*$") or
  version.regexpMatch("^v?[1-9]\\d*\\.(x|0|([1-9]\\d*))$") or
  version.regexpMatch("^v?[1-9]\\d*\\.(0|([1-9]\\d*))\\.(x|0|([1-9]\\d*))$") or
  // or latest which will work
  version = "latest"
}

predicate isImmutableAction(UsesStep actionStep, string actionName) {
  immutableActionsDataModel(actionName) and
  actionStep.getCallee() = actionName
}
