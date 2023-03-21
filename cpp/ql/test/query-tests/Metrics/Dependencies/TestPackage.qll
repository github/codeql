import Metrics.Dependencies.ExternalDependencies

/**
 * Count directories as libraries for testing purposes.
 */
class TestPackage extends LibraryElement instanceof Folder {
  override string getName() { result = super.getBaseName() }

  override string getVersion() { result = "1.0" }

  override File getAFile() { result.getParentContainer() = this }
}
