import javascript

DataFlow::Node unverifiedDecode() {
  result = API::moduleImport("jsonwebtoken").getMember("decode").getParameter(0).asSink()
  or
  exists(API::Node verify | verify = API::moduleImport("jsonwebtoken").getMember("verify") |
    verify
        .getParameter(2)
        .getMember("algorithms")
        .getUnknownMember()
        .asSink()
        .mayHaveStringValue("none") and
    result = verify.getParameter(0).asSink()
  )
  or
  // jwt-simple
  exists(API::Node n | n = API::moduleImport("jwt-simple").getMember("decode") |
    n.getParameter(2).asSink().asExpr() = any(BoolLiteral b | b.getBoolValue() = true) and
    result = n.getParameter(0).asSink()
  )
  or
  // jwt-decode
  result = API::moduleImport("jwt-decode").getParameter(0).asSink()
  or
  //jose
  result = API::moduleImport("jose").getMember("decodeJwt").getParameter(0).asSink()
}

DataFlow::Node verifiedDecode() {
  exists(API::Node verify | verify = API::moduleImport("jsonwebtoken").getMember("verify") |
    (
      not verify
          .getParameter(2)
          .getMember("algorithms")
          .getUnknownMember()
          .asSink()
          .mayHaveStringValue("none") or
      not exists(verify.getParameter(2).getMember("algorithms"))
    ) and
    result = verify.getParameter(0).asSink()
  )
  or
  // jwt-simple
  exists(API::Node n | n = API::moduleImport("jwt-simple").getMember("decode") |
    (
      n.getParameter(2).asSink().asExpr() = any(BoolLiteral b | b.getBoolValue() = false) or
      not exists(n.getParameter(2))
    ) and
    result = n.getParameter(0).asSink()
    or
    //jose
    result = API::moduleImport("jose").getMember("jwtVerify").getParameter(0).asSink()
  )
}
