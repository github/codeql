/**
 * Provides a taint-tracking configuration for reasoning about hard coded credentials.
 */

import csharp
private import semmle.code.csharp.commons.ComparisonTest
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.frameworks.Moq
private import semmle.code.csharp.frameworks.system.web.Security
private import semmle.code.csharp.frameworks.system.security.cryptography.X509Certificates
private import semmle.code.csharp.frameworks.Test

/**
 * A data flow source for hard coded credentials.
 */
abstract class Source extends DataFlow::ExprNode { }

/**
 * A data flow sink for hard coded credentials.
 */
abstract class Sink extends DataFlow::ExprNode {
  /**
   * Gets a description of this sink, including a placeholder for the sink and a placeholder for
   * the supplementary element.
   */
  abstract string getSinkDescription();

  /** Gets an element that is used as supplementary data in the description. */
  abstract Element getSupplementaryElement();

  /** Gets the sink name to use when displaying the sink. */
  abstract string getSinkName();
}

/**
 * A sanitizer for hard coded credentials.
 */
abstract class Sanitizer extends DataFlow::ExprNode { }

/**
 * A taint-tracking configuration for hard coded credentials.
 */
class TaintTrackingConfiguration extends TaintTracking::Configuration {
  TaintTrackingConfiguration() { this = "HardcodedCredentials" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) {
    sink instanceof Sink and
    // Ignore values that are ultimately returned by mocks, as they don't represent "real"
    // credentials.
    not any(ReturnedByMockObject mock).getAMemberInitializationValue() = sink.asExpr() and
    not any(ReturnedByMockObject mock).getAnArgument() = sink.asExpr()
  }

  override predicate hasFlowPath(DataFlow::PathNode source, DataFlow::PathNode sink) {
    super.hasFlowPath(source, sink) and
    // Exclude hard-coded credentials in tests if they only flow to calls to methods with a name
    // like "Add*" "Create*" or "Update*". The rationale is that hard-coded credentials within
    // tests that are only used for creating or setting values within tests are unlikely to
    // represent credentials to some accessible system.
    not (
      source.getNode().asExpr().getFile() instanceof TestFile and
      exists(MethodCall createOrAddCall, string createOrAddMethodName |
        createOrAddMethodName.matches("Update%") or
        createOrAddMethodName.matches("Create%") or
        createOrAddMethodName.matches("Add%")
      |
        createOrAddCall.getTarget().hasName(createOrAddMethodName) and
        createOrAddCall.getAnArgument() = sink.getNode().asExpr()
      )
    )
  }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
}

/**
 * A string literal that is not empty.
 */
class NonEmptyStringLiteral extends Source {
  NonEmptyStringLiteral() { this.getExpr().(StringLiteral).getValue().length() > 1 }
}

/**
 * The creation of a literal byte array.
 */
class ByteArrayLiteral extends Source {
  ByteArrayLiteral() {
    this.getExpr() =
      any(ArrayCreation ac |
        ac.getArrayType().getElementType() instanceof ByteType and
        ac.hasInitializer()
      )
  }
}

/**
 * The creation of a literal char array.
 */
class CharArrayLiteral extends Source {
  CharArrayLiteral() {
    this.getExpr() =
      any(ArrayCreation ac |
        ac.getArrayType().getElementType() instanceof CharType and
        ac.hasInitializer()
      )
  }
}

/**
 * An assignable whose name indicates that the value being held is a credential.
 */
private class CredentialVar extends Assignable {
  pragma[noinline]
  CredentialVar() {
    exists(string name | name = this.getName() |
      name.regexpMatch("(?i).*pass(wd|word|code|phrase)(?!.*question).*")
      or
      name.regexpMatch("(?i).*(puid|username|userid).*")
      or
      name.regexpMatch("(?i).*(cert)(?!.*(format|name)).*")
    )
  }
}

private class CredentialVariableAccess extends VariableAccess {
  pragma[noinline]
  CredentialVariableAccess() { this.getTarget() instanceof CredentialVar }
}

/**
 * Gets a credential sink, a display name, the operation it exists in, and a description of the sink.
 */
private predicate getCredentialSink(
  Expr sink, string sinkName, Element supplementaryElement, string description
) {
  // An argument to a library call that looks like a credential
  // "...flows to the [Username] parameter in [call to method CreateUser]"
  exists(Call call, CredentialVar param |
    supplementaryElement = call and
    description = "the $@ parameter in $@" and
    sink = call.getArgumentForParameter(param) and
    sinkName = param.getName() and
    call.getTarget().fromLibrary()
  )
  or
  // An argument to a library setter call for a property that looks like a credential
  // "...flows to the [setter call argument] for the property [UserName]"
  exists(Property p, Call call |
    call = p.getSetter().getACall() and
    supplementaryElement = p and
    description = "the $@ in $@" and
    sink = call.getArgument(0) and
    sinkName = "setter call argument" and
    p instanceof CredentialVar and
    p.fromLibrary()
  )
  or
  // Sink compared to password variable
  // "...flows to [] which is compared against [access of UserName]"
  exists(ComparisonTest ct, CredentialVariableAccess credentialAccess |
    sinkName = sink.toString() and
    supplementaryElement = credentialAccess and
    description = "$@ which is compared against $@" and
    ct.getAnArgument() = credentialAccess and
    ct.getAnArgument() = sink and
    ct.getComparisonKind().isEquality() and
    not sink = credentialAccess
  )
}

/**
 * An expression that is a sink for a specific type of credential.
 */
class HardcodedCredentialsSinkExpr extends Sink {
  private string description;
  private Element supplementaryElement;
  private string sinkName;

  HardcodedCredentialsSinkExpr() {
    getCredentialSink(this.getExpr(), sinkName, supplementaryElement, description)
  }

  override string getSinkDescription() { result = description }

  override Element getSupplementaryElement() { result = supplementaryElement }

  override string getSinkName() { result = sinkName }
}

/**
 * A "name" argument to a construction of "MembershipUser" or a subtype.
 */
class MembershipUserUserNameSink extends Sink {
  private Call call;

  MembershipUserUserNameSink() {
    call.getTarget().getDeclaringType().getABaseType*() instanceof
      SystemWebSecurityMembershipUserClass and
    this.getExpr() = call.getArgumentForName("name")
  }

  override string getSinkDescription() { result = "the $@ parameter in $@" }

  override Element getSupplementaryElement() { result = call }

  override string getSinkName() { result = "name" }
}

/**
 * A "rawData" argument to a construction of "X509Certificate" or a subtype.
 */
class X509CertificateDataSink extends Sink {
  private ObjectCreation x509Creation;

  X509CertificateDataSink() {
    x509Creation.getTarget().getDeclaringType() instanceof
      SystemSecurityCryptographyX509CertificatesX509CertificateClass and
    this.getExpr() = x509Creation.getArgumentForName("rawData")
  }

  override string getSinkDescription() { result = "the $@ parameter in $@" }

  override Element getSupplementaryElement() { result = x509Creation }

  override string getSinkName() { result = "rawData" }
}

/**
 * A format argument to `Format`, that is considered not to be a source of hardcoded secret data.
 */
class StringFormatSanitizer extends Sanitizer {
  StringFormatSanitizer() {
    this.getExpr() =
      any(SystemStringClass s).getFormatMethod().getACall().getArgumentForName("format")
  }
}

/**
 * A replacement argument to `Replace`, that is considered not to be a source of hardcoded secret
 * data.
 */
class StringReplaceSanitizer extends Sanitizer {
  StringReplaceSanitizer() {
    exists(SystemStringClass s, Call c | c = s.getReplaceMethod().getACall() |
      this.getExpr() = c.getArgumentForName("newValue") or
      this.getExpr() = c.getArgumentForName("newChar")
    )
  }
}

/**
 * A call to a `ToString()` method, which is considered not to return hard-coded constants.
 */
class ToStringSanitizer extends Sanitizer {
  ToStringSanitizer() { this.getExpr() = any(Call c | c.getTarget().hasName("ToString")) }
}
