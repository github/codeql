import rust

query predicate nestedIncludeMacroResolvesToLaterDefinition(string definitionFile) {
  exists(MacroCall call |
    call.getPath().getText() = "nested_shadow" and
    call.getFile().getRelativePath().matches("%included/outer.rs") and
    definitionFile = call.resolveMacro().getFile().getRelativePath()
  )
}
