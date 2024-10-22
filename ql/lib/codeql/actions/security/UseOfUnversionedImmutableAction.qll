import actions

class UnversionedImmutableAction extends UsesStep {
  string immutable_action;

  UnversionedImmutableAction() {
    immutableActionsDataModel(immutable_action) and
    this.getCallee() = immutable_action and
    isNotSemVer(this.getVersion())
  }
}

bindingset[version]
predicate isNotSemVer(string version) {
  not version.regexpMatch("^(v)?[0-9]+(\\.[0-9]+)*(\\.[xX])?$")
}
