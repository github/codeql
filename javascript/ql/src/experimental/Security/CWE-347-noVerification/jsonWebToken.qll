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
}