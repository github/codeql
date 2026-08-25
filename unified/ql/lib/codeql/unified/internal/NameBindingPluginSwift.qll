/**
 * Provides Swift-specific name binding rules.
 */

private import unified
private import codeql.unified.internal.NameBindingPlugin

class NameBindingPluginSwift extends NameBindingPlugin {
  // Note: For now we assume all code is Swift, but in the future we must restrict these rules to Swift-files
  bindingset[cls, member]
  override predicate isInstanceMember(ClassLikeDeclaration cls, Member member) {
    exists(cls) and
    not member.hasModifier(["static", "class", "enum_case"])
  }

  bindingset[member, binding]
  override predicate isPrivateToLocalScope(Stmt member, AstNode binding) {
    // Private top-level members
    member = any(TopLevel top).getBody().getAStmt() and
    member.hasModifier(["private", "fileprivate"])
    or
    // Imports are always file-local, except `@_exported` import which re-export everything
    member instanceof ImportDeclaration and
    not (
      member.hasModifier("@_exported") and
      binding instanceof BulkImportingPattern
    )
    //
    // Note: Private class members can be seen within type-extensions in the same file,
    // so we can't declare those private to their local scope.
  }
}

private predicate predefinedSourceFolders(string folder, int ordering) {
  folder = "Sources,Source,src,srcs".splitAt(",", ordering)
}

bindingset[targetKind]
private predicate predefinedSourceFoldersByTarget(string targetKind, string folder, int ordering) {
  predefinedSourceFolders(folder, ordering)
  or
  ordering = -1 and
  (
    targetKind = "testTarget" and
    folder = "Tests"
    or
    targetKind = "plugin" and
    folder = "Plugins"
  )
}

/**
 * A call to `.target()` or similar target spec, in a `Package.swift` file.
 */
class SwiftPackageTarget extends ModuleScopeRepr, CallExpr {
  private string targetKind;

  SwiftPackageTarget() {
    this.getFile().getBaseName() = "Package.swift" and
    this.getCallee().(MemberAccessExpr).getMember().getValue() = targetKind and
    targetKind =
      [
        "target", "executableTarget", "testTarget", "systemLibrary", "binaryTarget", "plugin",
        "macro"
      ]
  }

  Folder getFolder() { result = this.getFile().getParentContainer() }

  /** Gets the intermediate folder such as `Sources/` containing the sources, but without the target name. */
  Folder getSourceMidFolder() {
    result =
      min(int i, string name, Folder subfolder |
        predefinedSourceFoldersByTarget(targetKind, name, i) and
        subfolder = this.getFolder().getFolder(name)
      |
        subfolder order by i
      )
  }

  /** Gets the source folder to use if no explicit `path:` is given, typically `Sources/<Target>`. */
  Folder getDefaultSourceFolder() {
    exists(Folder subfolder | subfolder = this.getSourceMidFolder() |
      result = subfolder.getFolder(this.getName())
      or
      not exists(subfolder.getFolder(this.getName())) and
      result = subfolder
    )
  }

  string getName() { result = this.getNamedArgument("name").getStringValue() }

  string getExplicitPath() { result = this.getNamedArgument("path").getStringValue() }

  override predicate shouldInclude(Container c, string path) {
    c = this.getFolder() and
    path = this.getExplicitPath() + "/**/*.swift"
    or
    not exists(this.getExplicitPath()) and
    c = this.getDefaultSourceFolder() and
    path = "**/*.swift"
  }

  override predicate hasImportableName(string name) {
    targetKind = "target" and
    name = this.getName()
  }
}
