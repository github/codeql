import csharp

query predicate disable(PragmaWarningDirective pragma) { pragma.isDisable() }

query predicate restore(PragmaWarningDirective pragma) { pragma.isRestore() }

query predicate errorCodes(PragmaWarningDirective pragma, string code) {
  pragma.hasErrorCodes() and code = pragma.getAnErrorCode()
}
