import rust
import codeql.rust.Diagnostics

query predicate attribute_macros(Item i, int index, Item expanded) {
  i.fromSource() and expanded = i.getAttributeMacroExpansion().getItem(index)
}

query predicate derive_macros(TypeItem i, int index, int subIndex, Item expanded) {
  i.fromSource() and expanded = i.getDeriveMacroExpansion(index).getItem(subIndex)
}

query predicate macro_calls(MacroCall c, AstNode expansion) {
  c.fromSource() and
  not c.getLocation().getFile().getAbsolutePath().matches("%proc_macro.rs") and
  expansion = c.getMacroCallExpansion()
}

query predicate unexpanded_macro_calls(MacroCall c) {
  c.fromSource() and not c.hasMacroCallExpansion()
}

query predicate warnings(ExtractionWarning w) { any() }

query predicate includedArgumentLocation(AstNode node, int line) {
  exists(CallExpr call |
    call.isInMacroExpansion() and
    call.getFunction().(PathExpr).getPath().getText() = "dangerous_call" and
    call = node.getParentNode*() and
    line = node.getLocation().getStartLine()
  )
}

query predicate includedMacroShadowing(string definitionFile) {
  exists(MacroCall call |
    call.getPath().getText() = "shadowed" and
    call.getFile().getRelativePath().matches("%included/included.rs") and
    definitionFile = call.resolveMacro().getFile().getRelativePath()
  )
}

query predicate includedStandaloneMacroCount(int macros) {
  macros =
    count(MacroCall call |
      call.getFile().getRelativePath().matches("%included/included.rs") and
      not call.getFile().(ExtractedFile).isInActiveIncludeExpansion(call)
    )
}

query predicate includedMacroExpansionMembership(string name, boolean active) {
  exists(MacroCall call |
    call.getFile().getRelativePath().matches("%included/included.rs") and
    name = call.getPath().getText() and
    (
      if call.getFile().(ExtractedFile).isInActiveIncludeExpansion(call)
      then active = true
      else active = false
    )
  )
}
