/**
 * @name InsecureRmiJmxAuthenticationEnvironment
 * @description This query detects if a JMX/RMI server is created with a potentially dangerous environment, which could lead to code execution through insecure deserialization.
 * @kind problem
 * @problem.severity error
 * @tags security
 *       experimental
 *       external/cwe/cwe-665
 * @precision high
 * @id java/insecure-rmi-jmx-server-initialization
 */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.Maps

/** Holds if `constructor` instantiates an RMI or JMX server. */
predicate isRmiOrJmxServerCreateConstructor(Constructor constructor) {
  constructor
      .getDeclaringType()
      .hasQualifiedName("javax.management.remote.rmi", "RMIConnectorServer")
}

/** Holds if `method` creates an RMI or JMX server. */
predicate isRmiOrJmxServerCreateMethod(Method method) {
  method.getName() = "newJMXConnectorServer" and
  method.getDeclaringType().hasQualifiedName("javax.management.remote", "JMXConnectorServerFactory")
}

/**
 * Models flow from the qualifier of a
 * `map.put("jmx.remote.rmi.server.credential.types", value)` call
 * to an RMI or JMX initialisation call.
 */
module SafeFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { putsCredentialtypesKey(source.asExpr()) }

  predicate isSink(DataFlow::Node sink) {
    exists(Call c |
      isRmiOrJmxServerCreateConstructor(c.getCallee()) or
      isRmiOrJmxServerCreateMethod(c.getCallee())
    |
      sink.asExpr() = c.getArgument(1)
    )
  }

  /**
   * Holds if a `put` call on `qualifier` puts a key match
   * into the map.
   */
  private predicate putsCredentialtypesKey(Expr qualifier) {
    exists(MapPutCall put |
      put.getKey().(CompileTimeConstantExpr).getStringValue() =
        [
          "jmx.remote.rmi.server.credential.types",
          "jmx.remote.rmi.server.credentials.filter.pattern"
        ]
      or
      put.getKey()
          .(FieldAccess)
          .getField()
          .hasQualifiedName("javax.management.remote.rmi", "RMIConnectorServer",
            ["CREDENTIAL_TYPES", "CREDENTIALS_FILTER_PATTERN"])
    |
      put.getQualifier() = qualifier and
      put.getMethod().(MapMethod).getReceiverKeyType() instanceof TypeString and
      put.getMethod().(MapMethod).getReceiverValueType() instanceof TypeObject
    )
  }
}

module SafeFlow = DataFlow::Global<SafeFlowConfig>;

/** Gets a string describing why the application is vulnerable, depending on if the vulnerability is present due to a) a null environment b) an insecurely set environment map */
string getRmiResult(Expr e) {
  // We got a Map so we have a source and a sink node
  if e instanceof NullLiteral
  then
    result =
      "RMI/JMX server initialized with a null environment. Missing type restriction in RMI authentication method exposes the application to deserialization attacks."
  else
    result =
      "RMI/JMX server initialized with insecure environment $@, which never restricts accepted client objects to 'java.lang.String'. This exposes to deserialization attacks against the RMI authentication method."
}

deprecated query predicate problems(Call c, string message1, Expr envArg, string message2) {
  (isRmiOrJmxServerCreateConstructor(c.getCallee()) or isRmiOrJmxServerCreateMethod(c.getCallee())) and
  envArg = c.getArgument(1) and
  not SafeFlow::flowToExpr(envArg) and
  message1 = getRmiResult(envArg) and
  message2 = envArg.toString()
}
