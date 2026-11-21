import rust

query predicate telemetryKeepsStandaloneAndIncludedCopies(boolean included) {
  exists(Function function, ExtractedFile file |
    function.getName().getText() = "shared_function" and
    file = function.getFile() and
    file.getRelativePath().matches("%shared.rs") and
    file.isNotInactiveStandaloneCopy(function) and
    (if file.isInActiveIncludeExpansion(function) then included = true else included = false)
  )
}
