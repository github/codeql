import powershell

class ModuleManifestFile extends File {
  ModuleManifestFile() { this.getExtension() = "psd1" }
}

private Expr getEntry(HashTableExpr ht, string key) {
  result = ht.getElementFromConstant(key).(CmdExpr).getExpr() and
  not result instanceof ArrayLiteral
}

private Expr getAnEntry(HashTableExpr ht, string key) {
  exists(Expr e | e = ht.getElementFromConstant(key).(CmdExpr).getExpr() |
    not e instanceof ArrayLiteral and result = e
    or
    result = e.(ArrayLiteral).getAnElement()
  )
}

class ModuleManifest extends HashTableExpr {
  string moduleVersion;

  ModuleManifest() {
    // The hash table is in a .psd1 file
    this.getLocation().getFile() instanceof ModuleManifestFile and
    // It's at the top level of the file
    this.getParent().(CmdExpr).getParent().(NamedBlock).getParent() instanceof TopLevel and
    // It has a `ModuleVersion` entry. The only required field is ModuleVersion.
    // https://learn.microsoft.com/en-us/powershell/scripting/developer/module/how-to-write-a-powershell-module-manifest?view=powershell-7.4#to-create-and-use-a-module-manifest
    moduleVersion = getEntry(this, "ModuleVersion").getValue().asString()
  }

  string getModuleVersion() { result = moduleVersion }

  string getModuleName() {
    result + ".psd1" = this.getLocation().getFile().getBaseName()
  }

  string getAFunctionToExport() {
    result = getAnEntry(this, "FunctionsToExport").getValue().asString()
  }

  string getACmdLetToExport() { result = getAnEntry(this, "CmdletsToExport").getValue().asString() }
}
