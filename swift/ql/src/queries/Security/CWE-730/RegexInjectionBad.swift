func processRemoteInput(remoteInput: String) {
  ...

  // BAD: Unsanitized user input is used to construct a regular expression
  let regex1 = try Regex(remoteInput)

  // BAD: Unsanitized user input is used to construct a regular expression
  let regexStr = "abc|\(remoteInput)"
  let regex2 = try NSRegularExpression(pattern: regexStr)

  ...
}
