import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.Concepts
import utils.test.InlineExpectationsTest
private import semmle.python.dataflow.new.internal.PrintNode
private import codeql.threatmodels.ThreatModels

module SystemCommandExecutionTest implements TestSig {
  string getARelevantTag() { result = "getCommand" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(SystemCommandExecution sce, DataFlow::Node command |
      command = sce.getCommand() and
      location = command.getLocation() and
      element = command.toString() and
      value = prettyNodeForInlineTest(command) and
      tag = "getCommand"
    )
  }
}

module DecodingTest implements TestSig {
  string getARelevantTag() {
    result in ["decodeInput", "decodeOutput", "decodeFormat", "decodeMayExecuteInput"]
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(Decoding d |
      exists(DataFlow::Node data |
        location = data.getLocation() and
        element = data.toString() and
        value = prettyNodeForInlineTest(data) and
        (
          data = d.getAnInput() and
          tag = "decodeInput"
          or
          data = d.getOutput() and
          tag = "decodeOutput"
        )
      )
      or
      exists(string format |
        location = d.getLocation() and
        element = format and
        value = format and
        format = d.getFormat() and
        tag = "decodeFormat"
      )
      or
      d.mayExecuteInput() and
      location = d.getLocation() and
      element = d.toString() and
      value = "" and
      tag = "decodeMayExecuteInput"
    )
  }
}

module EncodingTest implements TestSig {
  string getARelevantTag() { result in ["encodeInput", "encodeOutput", "encodeFormat"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(Encoding e |
      exists(DataFlow::Node data |
        location = data.getLocation() and
        element = data.toString() and
        value = prettyNodeForInlineTest(data) and
        (
          data = e.getAnInput() and
          tag = "encodeInput"
          or
          data = e.getOutput() and
          tag = "encodeOutput"
        )
      )
      or
      exists(string format |
        location = e.getLocation() and
        element = format and
        value = format and
        format = e.getFormat() and
        tag = "encodeFormat"
      )
    )
  }
}

module LoggingTest implements TestSig {
  string getARelevantTag() { result = "loggingInput" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(Logging logging, DataFlow::Node data |
      location = data.getLocation() and
      element = data.toString() and
      value = prettyNodeForInlineTest(data) and
      data = logging.getAnInput() and
      tag = "loggingInput"
    )
  }
}

module CodeExecutionTest implements TestSig {
  string getARelevantTag() { result = "getCode" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(CodeExecution ce, DataFlow::Node code |
      exists(location.getFile().getRelativePath()) and
      code = ce.getCode() and
      location = code.getLocation() and
      element = code.toString() and
      value = prettyNodeForInlineTest(code) and
      tag = "getCode"
    )
  }
}

module SqlConstructionTest implements TestSig {
  string getARelevantTag() { result = "constructedSql" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(SqlConstruction e, DataFlow::Node sql |
      exists(location.getFile().getRelativePath()) and
      sql = e.getSql() and
      location = e.getLocation() and
      element = sql.toString() and
      value = prettyNodeForInlineTest(sql) and
      tag = "constructedSql"
    )
  }
}

module SqlExecutionTest implements TestSig {
  string getARelevantTag() { result = "getSql" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(SqlExecution e, DataFlow::Node sql |
      exists(location.getFile().getRelativePath()) and
      sql = e.getSql() and
      location = e.getLocation() and
      element = sql.toString() and
      value = prettyNodeForInlineTest(sql) and
      tag = "getSql"
    )
  }
}

module XPathConstructionTest implements TestSig {
  string getARelevantTag() { result = "constructedXPath" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(XML::XPathConstruction e, DataFlow::Node xpath |
      exists(location.getFile().getRelativePath()) and
      xpath = e.getXPath() and
      location = e.getLocation() and
      element = xpath.toString() and
      value = prettyNodeForInlineTest(xpath) and
      tag = "constructedXPath"
    )
  }
}

module XPathExecutionTest implements TestSig {
  string getARelevantTag() { result = "getXPath" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(XML::XPathExecution e, DataFlow::Node xpath |
      exists(location.getFile().getRelativePath()) and
      xpath = e.getXPath() and
      location = e.getLocation() and
      element = xpath.toString() and
      value = prettyNodeForInlineTest(xpath) and
      tag = "getXPath"
    )
  }
}

module EscapingTest implements TestSig {
  string getARelevantTag() { result in ["escapeInput", "escapeOutput", "escapeKind"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(Escaping esc |
      exists(DataFlow::Node data |
        location = data.getLocation() and
        element = data.toString() and
        value = prettyNodeForInlineTest(data) and
        (
          data = esc.getAnInput() and
          tag = "escapeInput"
          or
          data = esc.getOutput() and
          tag = "escapeOutput"
        )
      )
      or
      exists(string format |
        location = esc.getLocation() and
        element = format and
        value = format and
        format = esc.getKind() and
        tag = "escapeKind"
      )
    )
  }
}

module HttpServerRouteSetupTest implements TestSig {
  string getARelevantTag() { result = "routeSetup" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(Http::Server::RouteSetup setup |
      location = setup.getLocation() and
      element = setup.toString() and
      (
        value = "\"" + setup.getUrlPattern() + "\""
        or
        not exists(setup.getUrlPattern()) and
        value = ""
      ) and
      tag = "routeSetup"
    )
  }
}

module HttpServerRequestHandlerTest implements TestSig {
  string getARelevantTag() { result in ["requestHandler", "routedParameter"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    (
      exists(Http::Server::RequestHandler handler |
        location = handler.getLocation() and
        element = handler.toString() and
        value = "" and
        tag = "requestHandler"
      )
      or
      exists(Http::Server::RequestHandler handler, Parameter param |
        param = handler.getARoutedParameter() and
        location = param.getLocation() and
        element = param.toString() and
        value = param.asName().getId() and
        tag = "routedParameter"
      )
    )
  }
}

abstract class DedicatedResponseTest extends string {
  bindingset[this]
  DedicatedResponseTest() { any() }

  string toString() { result = this }

  abstract predicate isDedicatedFile(File file);
}

module HttpServerHttpResponseTest implements TestSig {
  string getARelevantTag() { result in ["HttpResponse", "responseBody", "mimetype"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    // By adding `file` as a class field, and these two restrictions, it's possible to
    // say that we only want to check _some_ tags for certain files. This helped make
    // flask tests more readable since adding full annotations for HttpResponses in the
    // the tests for routing setup is both annoying and not very useful.
    exists(File file |
      location.getFile() = file and
      file.getExtension() = "py" and
      exists(file.getRelativePath()) and
      // we need to do this step since we expect subclasses could override getARelevantTag
      tag = getARelevantTag() and
      (
        exists(Http::Server::HttpResponse response |
          location = response.getLocation() and
          element = response.toString() and
          value = "" and
          tag = "HttpResponse"
        )
        or
        (
          not exists(DedicatedResponseTest d)
          or
          exists(DedicatedResponseTest d | d.isDedicatedFile(file))
        ) and
        (
          exists(Http::Server::HttpResponse response, DataFlow::Node body |
            body = response.getBody() and
            location = body.getLocation() and
            element = body.toString() and
            value = prettyNodeForInlineTest(body) and
            tag = "responseBody"
          )
          or
          exists(Http::Server::HttpResponse response |
            location = response.getLocation() and
            element = response.toString() and
            // Ensure that an expectation value such as "mimetype=text/html; charset=utf-8" is parsed as a
            // single expectation with tag mimetype, and not as two expectations with tags mimetype and
            // charset.
            (
              if exists(response.getMimetype().indexOf(" "))
              then value = "\"" + response.getMimetype() + "\""
              else value = response.getMimetype()
            ) and
            tag = "mimetype"
          )
        )
      )
    )
  }
}

module HttpResponseHeaderWriteTest implements TestSig {
  string getARelevantTag() {
    result =
      [
        "headerWriteNameUnsanitized", "headerWriteName", "headerWriteValueUnsanitized",
        "headerWriteValue", "headerWriteBulk", "headerWriteBulkUnsanitized"
      ]
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    (
      exists(Http::Server::ResponseHeaderWrite write, DataFlow::Node node |
        location = node.getLocation() and
        element = node.toString()
      |
        node = write.getNameArg() and
        (
          if write.nameAllowsNewline()
          then tag = "headerWriteNameUnsanitized"
          else tag = "headerWriteName"
        ) and
        value = prettyNodeForInlineTest(node)
        or
        node = write.getValueArg() and
        (
          if write.valueAllowsNewline()
          then tag = "headerWriteValueUnsanitized"
          else tag = "headerWriteValue"
        ) and
        value = prettyNodeForInlineTest(node)
      )
      or
      exists(Http::Server::ResponseHeaderBulkWrite write, DataFlow::Node node |
        node = write.getBulkArg() and
        location = node.getLocation() and
        element = node.toString() and
        (
          tag = "headerWriteBulk" and
          value = prettyNodeForInlineTest(node)
          or
          tag = "headerWriteBulkUnsanitized" and
          (
            write.nameAllowsNewline() and
            not write.valueAllowsNewline() and
            value = "name"
            or
            not write.nameAllowsNewline() and
            write.valueAllowsNewline() and
            value = "value"
            or
            write.nameAllowsNewline() and
            write.valueAllowsNewline() and
            value = "name,value"
          )
        )
      )
    )
  }
}

module HttpServerHttpRedirectResponseTest implements TestSig {
  string getARelevantTag() { result in ["HttpRedirectResponse", "redirectLocation"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    (
      exists(Http::Server::HttpRedirectResponse redirect |
        location = redirect.getLocation() and
        element = redirect.toString() and
        value = "" and
        tag = "HttpRedirectResponse"
      )
      or
      exists(Http::Server::HttpRedirectResponse redirect |
        location = redirect.getLocation() and
        element = redirect.toString() and
        value = prettyNodeForInlineTest(redirect.getRedirectLocation()) and
        tag = "redirectLocation"
      )
    )
  }
}

module HttpServerCookieWriteTest implements TestSig {
  string getARelevantTag() {
    result in [
        "CookieWrite", "CookieRawHeader", "CookieName", "CookieValue", "CookieSecure",
        "CookieHttpOnly", "CookieSameSite"
      ]
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(Http::Server::CookieWrite cookieWrite |
      location = cookieWrite.getLocation() and
      (
        element = cookieWrite.toString() and
        value = "" and
        tag = "CookieWrite"
        or
        element = cookieWrite.toString() and
        value = prettyNodeForInlineTest(cookieWrite.getHeaderArg()) and
        tag = "CookieRawHeader"
        or
        element = cookieWrite.toString() and
        value = prettyNodeForInlineTest(cookieWrite.getNameArg()) and
        tag = "CookieName"
        or
        element = cookieWrite.toString() and
        value = prettyNodeForInlineTest(cookieWrite.getValueArg()) and
        tag = "CookieValue"
        or
        element = cookieWrite.toString() and
        value = any(boolean b | cookieWrite.hasSecureFlag(b)).toString() and
        tag = "CookieSecure"
        or
        element = cookieWrite.toString() and
        value = any(boolean b | cookieWrite.hasHttpOnlyFlag(b)).toString() and
        tag = "CookieHttpOnly"
        or
        element = cookieWrite.toString() and
        value =
          any(Http::Server::CookieWrite::SameSiteValue v | cookieWrite.hasSameSiteAttribute(v))
              .toString() and
        tag = "CookieSameSite"
      )
    )
  }
}

module FileSystemAccessTest implements TestSig {
  string getARelevantTag() { result = "getAPathArgument" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(FileSystemAccess a, DataFlow::Node path |
      path = a.getAPathArgument() and
      location = a.getLocation() and
      element = path.toString() and
      value = prettyNodeForInlineTest(path) and
      tag = "getAPathArgument"
    )
  }
}

module FileSystemWriteAccessTest implements TestSig {
  string getARelevantTag() { result = "fileWriteData" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(FileSystemWriteAccess write, DataFlow::Node data |
      data = write.getADataNode() and
      location = data.getLocation() and
      element = data.toString() and
      value = prettyNodeForInlineTest(data) and
      tag = "fileWriteData"
    )
  }
}

module PathNormalizationTest implements TestSig {
  string getARelevantTag() { result = "pathNormalization" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(Path::PathNormalization n |
      location = n.getLocation() and
      element = n.toString() and
      value = "" and
      tag = "pathNormalization"
    )
  }
}

module SafeAccessCheckTest implements TestSig {
  string getARelevantTag() { result = "SafeAccessCheck" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(Path::SafeAccessCheck c |
      location = c.getLocation() and
      element = c.toString() and
      value = prettyNodeForInlineTest(c) and
      tag = "SafeAccessCheck"
    )
  }
}

module PublicKeyGenerationTest implements TestSig {
  string getARelevantTag() { result in ["PublicKeyGeneration", "keySize"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(Cryptography::PublicKey::KeyGeneration keyGen |
      location = keyGen.getLocation() and
      (
        element = keyGen.toString() and
        value = "" and
        tag = "PublicKeyGeneration"
        or
        element = keyGen.toString() and
        value = keyGen.getKeySizeWithOrigin(_).toString() and
        tag = "keySize"
      )
    )
  }
}

module CryptographicOperationTest implements TestSig {
  string getARelevantTag() {
    result in [
        "CryptographicOperation", "CryptographicOperationInput", "CryptographicOperationAlgorithm",
        "CryptographicOperationBlockMode"
      ]
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(Cryptography::CryptographicOperation cryptoOperation |
      location = cryptoOperation.getLocation() and
      (
        element = cryptoOperation.toString() and
        value = "" and
        tag = "CryptographicOperation"
        or
        element = cryptoOperation.toString() and
        value = prettyNodeForInlineTest(cryptoOperation.getAnInput()) and
        tag = "CryptographicOperationInput"
        or
        element = cryptoOperation.toString() and
        value = cryptoOperation.getAlgorithm().getName() and
        tag = "CryptographicOperationAlgorithm"
        or
        element = cryptoOperation.toString() and
        value = cryptoOperation.getBlockMode() and
        tag = "CryptographicOperationBlockMode"
      )
    )
  }
}

module HttpClientRequestTest implements TestSig {
  string getARelevantTag() {
    result in ["clientRequestUrlPart", "clientRequestCertValidationDisabled"]
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(Http::Client::Request req, DataFlow::Node url |
      url = req.getAUrlPart() and
      location = url.getLocation() and
      element = url.toString() and
      value = prettyNodeForInlineTest(url) and
      tag = "clientRequestUrlPart"
    )
    or
    exists(location.getFile().getRelativePath()) and
    exists(Http::Client::Request req |
      req.disablesCertificateValidation(_, _) and
      location = req.getLocation() and
      element = req.toString() and
      value = "" and
      tag = "clientRequestCertValidationDisabled"
    )
  }
}

module CsrfProtectionSettingTest implements TestSig {
  string getARelevantTag() { result = "CsrfProtectionSetting" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(Http::Server::CsrfProtectionSetting setting |
      location = setting.getLocation() and
      element = setting.toString() and
      value = setting.getVerificationSetting().toString() and
      tag = "CsrfProtectionSetting"
    )
  }
}

module CsrfLocalProtectionSettingTest implements TestSig {
  string getARelevantTag() { result = "CsrfLocalProtection" + ["Enabled", "Disabled"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(Http::Server::CsrfLocalProtectionSetting p |
      location = p.getLocation() and
      element = p.toString() and
      value = p.getRequestHandler().getName().toString() and
      if p.csrfEnabled()
      then tag = "CsrfLocalProtectionEnabled"
      else tag = "CsrfLocalProtectionDisabled"
    )
  }
}

module XmlParsingTest implements TestSig {
  string getARelevantTag() { result = "xmlVuln" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(XML::XmlParsing parsing, XML::XmlParsingVulnerabilityKind kind |
      parsing.vulnerableTo(kind) and
      location = parsing.getLocation() and
      element = parsing.toString() and
      value = "'" + kind + "'" and
      tag = "xmlVuln"
    )
  }
}

module ThreatModelSourceTest implements TestSig {
  string getARelevantTag() {
    exists(string kind | knownThreatModel(kind) | result = "threatModelSource" + "[" + kind + "]")
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(ThreatModelSource src | not src.getThreatModel() = "remote" |
      location = src.getLocation() and
      element = src.toString() and
      value = prettyNodeForInlineTest(src) and
      tag = "threatModelSource[" + src.getThreatModel() + "]"
    )
  }
}

module CorsMiddlewareTest implements TestSig {
  string getARelevantTag() { result = "CorsMiddleware" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(Http::Server::CorsMiddleware cm |
      location = cm.getLocation() and
      element = cm.toString() and
      value = cm.getMiddlewareName().toString() and
      tag = "CorsMiddleware"
    )
  }
}

module TemplateConstructionTest implements TestSig {
  string getARelevantTag() { result = "templateConstruction" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(TemplateConstruction tc |
      location = tc.getLocation() and
      element = tc.toString() and
      value = prettyNodeForInlineTest(tc.getSourceArg()) and
      tag = "templateConstruction"
    )
  }
}

import MakeTest<MergeTests5<MergeTests5<SystemCommandExecutionTest, DecodingTest, EncodingTest, LoggingTest,
    CodeExecutionTest>,
  MergeTests5<SqlConstructionTest, SqlExecutionTest, XPathConstructionTest, XPathExecutionTest,
    EscapingTest>,
  MergeTests5<HttpServerRouteSetupTest, HttpServerRequestHandlerTest, HttpServerHttpResponseTest,
    HttpServerHttpRedirectResponseTest,
    MergeTests3<HttpServerCookieWriteTest, HttpResponseHeaderWriteTest, CorsMiddlewareTest>>,
  MergeTests5<FileSystemAccessTest, FileSystemWriteAccessTest, PathNormalizationTest,
    SafeAccessCheckTest, PublicKeyGenerationTest>,
  MergeTests5<CryptographicOperationTest, HttpClientRequestTest, CsrfProtectionSettingTest,
    CsrfLocalProtectionSettingTest,
    MergeTests3<XmlParsingTest, ThreatModelSourceTest, TemplateConstructionTest>>>>
