/**
 * Provides classes for working with GitHub Actions lockfiles.
 */

private import codeql.actions.ast.internal.Yaml

/** An `actions.lock` file. */
class ActionsLock extends YamlDocument {
  ActionsLock() { this.getFile().getBaseName() = "actions.lock" }
}
