import csharp

query predicate disable(PragmaWarningDirective pragma) { pragma.disable() }

query predicate restore(PragmaWarningDirective pragma) { pragma.restore() }

query predicate errorCodes(PragmaWarningDirective pragma, string code) {
  pragma.hasErrorCodes() and code = pragma.getAnErrorCode()
}
