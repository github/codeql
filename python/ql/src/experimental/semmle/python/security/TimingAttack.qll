private import python
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.ApiGraphs
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.frameworks.Flask
private import semmle.python.frameworks.Django

/** A method call that produces cryptographic result. */
abstract class ProduceCryptoCall extends API::CallNode {
  /** Gets a type of cryptographic operation such as MAC, signature, Hash or ciphertext. */
  abstract string getResultType();
}

/** Gets a reference to the `cryptography.hazmat.primitives` module. */
API::Node cryptographylib() {
  result = API::moduleImport("cryptography").getMember("hazmat").getMember("primitives")
}

/** Gets a reference to the `Crypto` module. */
API::Node cryptodome() { result = API::moduleImport(["Crypto", "Cryptodome"]) }

/** A method call that produces a MAC. */
class ProduceMacCall extends ProduceCryptoCall {
  ProduceMacCall() {
    this = API::moduleImport("hmac").getMember("digest").getACall() or
    this =
      API::moduleImport("hmac")
          .getMember("new")
          .getReturn()
          .getMember(["digest", "hexdigest"])
          .getACall() or
    this =
      cryptodome()
          .getMember("Hash")
          .getMember("HMAC")
          .getMember(["new", "HMAC"])
          .getMember(["digest", "hexdigest"])
          .getACall() or
    this =
      cryptographylib()
          .getMember("hmac")
          .getMember("HMAC")
          .getReturn()
          .getMember("finalize")
          .getACall() or
    this =
      cryptographylib()
          .getMember("cmac")
          .getMember("CMAC")
          .getReturn()
          .getMember("finalize")
          .getACall() or
    this =
      cryptodome()
          .getMember("Hash")
          .getMember("CMAC")
          .getMember(["new", "CMAC"])
          .getMember(["digest", "hexdigest"])
          .getACall()
  }

  override string getResultType() { result = "MAC" }
}

/** A method call that produces a signature. */
private class ProduceSignatureCall extends ProduceCryptoCall {
  ProduceSignatureCall() {
    this =
      cryptodome()
          .getMember("Signature")
          .getMember(["DSS", "pkcs1_15", "pss", "eddsa"])
          .getMember("new")
          .getReturn()
          .getMember("sign")
          .getACall()
  }

  override string getResultType() { result = "signature" }
}

private string hashalgo() {
  result = ["sha1", "sha224", "sha256", "sha384", "sha512", "blake2b", "blake2s", "md5"]
}

/** A method call that produces a Hash. */
private class ProduceHashCall extends ProduceCryptoCall {
  ProduceHashCall() {
    this =
      cryptographylib()
          .getMember("hashes")
          .getMember("Hash")
          .getReturn()
          .getMember("finalize")
          .getACall() or
    this =
      API::moduleImport("hashlib")
          .getMember(["new", hashalgo()])
          .getReturn()
          .getMember(["digest", "hexdigest"])
          .getACall() or
    this =
      cryptodome()
          .getMember(hashalgo())
          .getMember("new")
          .getReturn()
          .getMember(["digest", "hexdigest"])
          .getACall()
  }

  override string getResultType() { result = "Hash" }
}

/** A method call that produces a ciphertext. */
private class ProduceCiphertextCall extends ProduceCryptoCall {
  ProduceCiphertextCall() {
    this =
      cryptodome()
          .getMember("Cipher")
          .getMember(["DES", "DES3", "ARC2", "ARC4", "Blowfish", "PKCS1_v1_5"])
          .getMember(["ARC4Cipher", "new", "PKCS115_Cipher"])
          .getMember("encrypt")
          .getACall() or
    this =
      cryptographylib()
          .getMember("ciphers")
          .getMember("Cipher")
          .getReturn()
          .getMember("finalize")
          .getACall()
  }

  override string getResultType() { result = "ciphertext" }
}

/** A data flow sink for comparison. */
private predicate existsFailFastCheck(Expr firstInput, Expr secondInput) {
  exists(Compare compare |
    (
      compare.getOp(0) instanceof Eq or
      compare.getOp(0) instanceof NotEq or
      compare.getOp(0) instanceof In or
      compare.getOp(0) instanceof NotIn
    ) and
    (
      compare.getLeft() = firstInput and
      compare.getComparator(0) = secondInput and
      not compare.getAComparator() instanceof None
      or
      compare.getLeft() = secondInput and
      compare.getComparator(0) = firstInput and
      not compare.getAComparator() instanceof None
    )
  )
}

/** A sink that compares input using fail fast check. */
class NonConstantTimeComparisonSink extends DataFlow::Node {
  Expr anotherParameter;

  NonConstantTimeComparisonSink() { existsFailFastCheck(this.asExpr(), anotherParameter) }

  /** Holds if remote user input was used in the comparison. */
  predicate includesUserInput() {
    UserInputInComparisonFlow::flowTo(DataFlow::exprNode(anotherParameter))
  }
}

/** A data flow source of the secret obtained. */
class SecretSource extends DataFlow::Node {
  CredentialExpr secret;

  SecretSource() { secret = this.asExpr() }

  /** Holds if the secret was deliverd by remote user. */
  predicate includesUserInput() { UserInputSecretFlow::flowTo(DataFlow::exprNode(secret)) }
}

/** A string for `match` that identifies strings that look like they represent secret data. */
private string suspicious() {
  result =
    [
      "%password%", "%passwd%", "%pwd%", "%refresh%token%", "%secret%token", "%secret%key",
      "%passcode%", "%passphrase%", "%token%", "%secret%", "%credential%", "%userpass%", "%digest%",
      "%signature%", "%mac%"
    ]
}

/** A variable that may hold sensitive information, judging by its name. * */
class CredentialExpr extends Expr {
  CredentialExpr() {
    exists(Variable v | this = v.getAnAccess() | v.getId().toLowerCase().matches(suspicious()))
  }
}

/**
 * A data flow source of the client Secret obtained according to the remote endpoint identifier specified
 * (`X-auth-token`, `proxy-authorization`, `X-Csrf-Header`, etc.) in the header.
 *
 * For example: `request.headers.get("X-Auth-Token")`.
 */
abstract class ClientSuppliedSecret extends DataFlow::CallCfgNode { }

private class FlaskClientSuppliedSecret extends ClientSuppliedSecret {
  FlaskClientSuppliedSecret() {
    this = Flask::request().getMember("headers").getMember(["get", "get_all", "getlist"]).getACall() and
    [this.getArg(0), this.getArgByName(["key", "name"])]
        .asExpr()
        .(StringLiteral)
        .getText()
        .toLowerCase() = sensitiveheaders()
  }
}

private class DjangoClientSuppliedSecret extends ClientSuppliedSecret {
  DjangoClientSuppliedSecret() {
    this =
      PrivateDjango::DjangoImpl::DjangoHttp::Request::HttpRequest::classRef()
          .getMember(["headers", "META"])
          .getMember("get")
          .getACall() and
    [this.getArg(0), this.getArgByName("key")].asExpr().(StringLiteral).getText().toLowerCase() =
      sensitiveheaders()
  }
}

/** Gets a reference to the `tornado.web.RequestHandler` module. */
API::Node requesthandler() {
  result = API::moduleImport("tornado").getMember("web").getMember("RequestHandler")
}

private class TornadoClientSuppliedSecret extends ClientSuppliedSecret {
  TornadoClientSuppliedSecret() {
    this = requesthandler().getMember(["headers", "META"]).getMember("get").getACall() and
    [this.getArg(0), this.getArgByName("key")].asExpr().(StringLiteral).getText().toLowerCase() =
      sensitiveheaders()
  }
}

/** Gets a reference to the `werkzeug.datastructures.Headers` module. */
API::Node headers() {
  result = API::moduleImport("werkzeug").getMember("datastructures").getMember("Headers")
}

private class WerkzeugClientSuppliedSecret extends ClientSuppliedSecret {
  WerkzeugClientSuppliedSecret() {
    this =
      headers().getMember(["headers", "META"]).getMember(["get", "get_all", "getlist"]).getACall() and
    [this.getArg(0), this.getArgByName(["key", "name"])]
        .asExpr()
        .(StringLiteral)
        .getText()
        .toLowerCase() = sensitiveheaders()
  }
}

/** A string for `match` that identifies strings that look like they represent Sensitive Headers. */
private string sensitiveheaders() {
  result =
    [
      "x-auth-token", "x-csrf-token", "http_x_csrf_token", "x-csrf-param", "x-csrf-header",
      "http_x_csrf_token", "x-api-key", "authorization", "proxy-authorization", "x-gitlab-token",
      "www-authenticate"
    ]
}

/**
 * A config that tracks data flow from remote user input to Variable that hold sensitive info
 */
module UserInputSecretConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink.asExpr() instanceof CredentialExpr }
}

module UserInputSecretFlow = TaintTracking::Global<UserInputSecretConfig>;

/**
 * A config that tracks data flow from remote user input to Equality test
 */
module UserInputInComparisonConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) {
    exists(Compare cmp, Expr left, Expr right, Cmpop cmpop |
      cmpop.getSymbol() = ["==", "in", "is not", "!="] and
      cmp.compares(left, cmpop, right) and
      sink.asExpr() = [left, right]
    )
  }
}

module UserInputInComparisonFlow = TaintTracking::Global<UserInputInComparisonConfig>;

/**
 * A configuration tracing flow from  a client Secret obtained by an HTTP header to a len() function.
 */
private module ExcludeLenFuncConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ClientSuppliedSecret }

  predicate isSink(DataFlow::Node sink) {
    exists(Call call |
      call.getFunc().(Name).getId() = "len" and
      sink.asExpr() = call.getArg(0)
    )
  }
}

module ExcludeLenFuncFlow = TaintTracking::Global<ExcludeLenFuncConfig>;

/**
 * Holds if there is a fast-fail check.
 */
class CompareSink extends DataFlow::Node {
  CompareSink() {
    exists(Compare compare |
      (
        compare.getOp(0) instanceof Eq or
        compare.getOp(0) instanceof NotEq
      ) and
      (
        compare.getLeft() = this.asExpr() and
        not compare.getComparator(0).(StringLiteral).getText() = "bearer"
        or
        compare.getComparator(0) = this.asExpr() and
        not compare.getLeft().(StringLiteral).getText() = "bearer"
      )
    )
    or
    exists(Compare compare |
      compare.getOp(0) instanceof IsNot and
      (
        compare.getLeft() = this.asExpr() and
        not compare.getComparator(0) instanceof None
        or
        compare.getComparator(0) = this.asExpr() and
        not compare.getLeft() instanceof None
      )
    )
  }

  /**
   * Holds if there is a flow to len().
   */
  predicate flowtolen() {
    // TODO: Fly by comment: I don't understand this code at all, seems very strange.
    ExcludeLenFuncFlow::flowPath(_, _)
  }
}
