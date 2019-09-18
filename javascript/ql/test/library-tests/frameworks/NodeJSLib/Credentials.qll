import javascript

query predicate test_Credentials(NodeJSLib::Credentials cr, string res) {
  res = cr.getCredentialsKind()
}
