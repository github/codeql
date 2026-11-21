import rust

query predicate nestedIncludeMacroResolvesToLaterDefinition(
  string callFile, int callLine, string definitionFile, int definitionLine, boolean inMacroExpansion
) {
  exists(MacroCall call |
    call.getPath().getText() = "nested_shadow" and
    call.getFile().(ExtractedFile).isInActiveIncludeExpansion(call) and
    (
      call.getFile().getRelativePath().matches("%included/outer.rs") or
      call.getFile().getRelativePath().matches("%included/middle.rs")
    ) and
    callFile = call.getFile().getRelativePath() and
    call.getLocation().hasLocationInfo(_, callLine, _, _, _) and
    definitionFile = call.resolveMacro().getFile().getRelativePath() and
    call.resolveMacro().getLocation().hasLocationInfo(_, definitionLine, _, _, _) and
    (if call.isInMacroExpansion() then inMacroExpansion = true else inMacroExpansion = false)
  )
}
