import Metrics.Dependencies.ExternalDependencies

/**
 * Count directories as libraries for testing purposes.
 */
class TestPackage extends LibraryElement {
  TestPackage() { this instanceof Folder }

  override string getName() { result = this.(Folder).getBaseName() }

  override string getVersion() { result = "1.0" }

  override File getAFile() { result.getParentContainer() = this }
}
