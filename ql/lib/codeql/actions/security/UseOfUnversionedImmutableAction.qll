import actions

class UnversionedImmutableAction extends UsesStep {
  string immutable_action;

  UnversionedImmutableAction() {
    immutableActionsDataModel(immutable_action) and
    this.getCallee() = immutable_action and
    not this.getVersion().regexpMatch("^(v)?[0-9]+(\\.[0-9]+)*(\\.[xX])?$")
  }
}
