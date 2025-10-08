import csharp
import DataFlow

private module TokenValidationParametersFlowsToAadTokenValidationParametersExtensionCallConfiguration
  implements DataFlow::ConfigSig
{
  predicate isSource(DataFlow::Node source) {
    exists(TokenValidationParametersObjectCreation oc | source.asExpr() = oc)
  }

  predicate isSink(DataFlow::Node sink) {
    isExprEnableAadSigningKeyIssuerValidationMethodCall(sink.asExpr())
  }

  /***
   * Additional steps needed because the setter i not `fromSource`
   * 
   * We should eventually add this type of additional steps to the general `DataFlow` library we use
   */
  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(AssignExpr ae, Expr oc
    |
      node1.asExpr() = oc and
      node2.asExpr() = ae.getLValue()
    |
      ae = oc.getParent()
    ) 
    or 
    exists(PropertyAccess e2, PropertyWrite e1
    |
      node1.asExpr() = e1 and
      node2.asExpr() = e2
    |
      e1.getAControlFlowNode().dominates(e2.getAControlFlowNode()) and
      e2.getTarget().getSetter().getACall() = e1
    ) 
  }

  
  additional predicate isExprEnableAadSigningKeyIssuerValidationMethodCall(Expr e) {
    exists(EnableAadSigningKeyIssuerValidationMethodCall c, PropertyAccess pa | e = pa |
      c.getAChild() = pa
    )
    or
    exists(EnableAadSigningKeyIssuerValidationMethodCall c, VariableAccess va | e = va |
      c.getAChild() = va
    )
  }
}

private module TokenValidationParametersFlowsToAadTokenValidationParametersExtensionCallTT =
  TaintTracking::Global<TokenValidationParametersFlowsToAadTokenValidationParametersExtensionCallConfiguration>;

class TokenValidationParametersObjectCreation extends ObjectCreation {
  TokenValidationParametersObjectCreation() {
    this.getObjectType()
        .hasFullyQualifiedName("Microsoft.IdentityModel.Tokens", "TokenValidationParameters")
  }
}

class EnableAadSigningKeyIssuerValidationMethodCall extends MethodCall {
  EnableAadSigningKeyIssuerValidationMethodCall() {
    this.getTarget()
        .hasFullyQualifiedName("Microsoft.IdentityModel.Validators.AadTokenValidationParametersExtension",
          "EnableAadSigningKeyIssuerValidation")
  }
}

predicate isTokenValidationParametersCallingEnableAadSigningKeyIssuerValidation(
  TokenValidationParametersObjectCreation oc
) {
  exists(DataFlow::Node source, DataFlow::Node sink | oc = source.asExpr() |
    TokenValidationParametersFlowsToAadTokenValidationParametersExtensionCallTT::flow(source, sink)
  )
}
