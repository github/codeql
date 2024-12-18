import actions

class UnversionedImmutableAction extends UsesStep {
  string immutable_action;

  UnversionedImmutableAction() {
    isImmutableAction(this, immutable_action) and
    not isSemVer(this.getVersion())
  }
}

bindingset[version]
predicate isSemVer(string version) {
  // https://semver.org/#is-there-a-suggested-regular-expression-regex-to-check-a-semver-string with optional v prefix
  version
      .regexpMatch("^v?(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?$") or
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
