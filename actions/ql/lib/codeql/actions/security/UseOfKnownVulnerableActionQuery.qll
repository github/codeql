import actions

class KnownVulnerableAction extends UsesStep {
  string vulnerable_action;
  string fixed_version;
  string vulnerable_version;
  string vulnerable_sha;

  KnownVulnerableAction() {
    vulnerableActionsDataModel(vulnerable_action, vulnerable_version, vulnerable_sha, fixed_version) and
    this.getCallee() = vulnerable_action and
    (this.getVersion() = vulnerable_version or this.getVersion() = vulnerable_sha)
  }

  string getFixedVersion() { result = fixed_version }

  string getVulnerableAction() { result = vulnerable_action }

  string getVulnerableVersion() { result = vulnerable_version }

  string getVulnerableSha() { result = vulnerable_sha }
}
