func processRemoteInput(remoteInput: String) {
  ...

  // GOOD: Regular expression is not derived from user input
  let regex1 = try Regex(myRegex)

  // GOOD: User input is sanitized before being used to construct a regular expression
  let escapedInput = NSRegularExpression.escapedPattern(for: remoteInput)
  let regexStr = "abc|\(escapedInput)"
  let regex2 = try NSRegularExpression(pattern: regexStr)

  ...
}
