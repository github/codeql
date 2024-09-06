/**
 * INTERNAL: Do not use.
 * This module holds thin fully generated class definitions around DB entities.
 */
module Raw {
  /**
   * INTERNAL: Do not use.
   */
  class Element extends @element {
    string toString() { none() }
  }

  /**
   * INTERNAL: Do not use.
   */
  class File extends @file, Element {
    /**
     * Gets the name of this file.
     */
    string getName() { files(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class Locatable extends @locatable, Element {
    /**
     * Gets the location of this locatable, if it exists.
     */
    Location getLocation() { locatable_locations(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class Location extends @location, Element {
    /**
     * Gets the file of this location.
     */
    File getFile() { locations(this, result, _, _, _, _) }

    /**
     * Gets the start line of this location.
     */
    int getStartLine() { locations(this, _, result, _, _, _) }

    /**
     * Gets the start column of this location.
     */
    int getStartColumn() { locations(this, _, _, result, _, _) }

    /**
     * Gets the end line of this location.
     */
    int getEndLine() { locations(this, _, _, _, result, _) }

    /**
     * Gets the end column of this location.
     */
    int getEndColumn() { locations(this, _, _, _, _, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class DbFile extends @db_file, File {
    override string toString() { result = "DbFile" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class DbLocation extends @db_location, Location {
    override string toString() { result = "DbLocation" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class Declaration extends @declaration, Locatable { }

  /**
   * INTERNAL: Do not use.
   * A function declaration. For example
   * ```
   * fn foo(x: u32) -> u64 { (x + 1).into()
   *  }
   * ```
   * A function declaration within a trait might not have a body:
   * ```
   * trait Trait {
   *     fn bar();
   * }
   * ```
   */
  class Function extends @function, Declaration {
    override string toString() { result = "Function" }

    /**
     * Gets the name of this function.
     */
    string getName() { functions(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class Module extends @module, Declaration {
    override string toString() { result = "Module" }

    /**
     * Gets the `index`th declaration of this module (0-based).
     */
    Declaration getDeclaration(int index) { module_declarations(this, index, result) }
  }
}
