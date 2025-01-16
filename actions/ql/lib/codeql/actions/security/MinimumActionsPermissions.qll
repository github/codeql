import actions
class MinimumActionsPermissions extends UsesStep {
  string action;
  string minimum_permissions;

  MinimumActionsPermissions() {
    minimumPermissionsDataModel(action, minimum_permissions) and
    this.getCallee() = action
  }

  string getMinimumPermissions() { result = minimum_permissions }

  string getAction() { result = action }
}
