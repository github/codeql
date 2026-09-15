/**
 * @name Do not disable certificate validation
 * @description Do not force ServerCertificateValidationCallback to always return 'true'.
 * @kind problem
 * @id cs/do-not-disable-cert-validation
 * @problem.severity error
 * @precision high
 * @tags security
 *       external/cwe/cwe-295
 */
import csharp
/*
 * Lambda examples:
 *  ServicePointManager.ServerCertificateValidationCallback += (a, b, c, d) => { return true; };
 *  ServicePointManager.ServerCertificateValidationCallback += (a, b, c, d) => true;
 * Anonymous method example:
 *  ServicePointManager.ServerCertificateValidationCallback += delegate { return true; };
 * Delegate creation example:
 *  ServicePointManager.ServerCertificateValidationCallback = new RemoteCertificateValidationCallback(AcceptAllCertifications);
 */
from Assignment a, PropertyWrite leftExpr, Callable targetCallable, Property p
where leftExpr = a.getLValue()  // Hook up the basic fields
    and leftExpr.getTarget() = p
    and p.getDeclaringType().hasQualifiedName("System.Net", "ServicePointManager")
    and p.getName() = "ServerCertificateValidationCallback"
    // Find the target callable being assigned to the ServerCertificateValidationCallback
    and exists(Expr assignedValue |
        assignedValue = a.getRValue() |
        // Either the assigned value is an AnonymousFunctionExpr, such as a lambda or anonymous method expr
        targetCallable = assignedValue or
        // Or the assigned value is a DelegateCreation
        exists(Expr delegateCreationArg |
            delegateCreationArg = assignedValue.(DelegateCreation).getArgument() |
            // And the argument is an AnonymousFunctionExpr
            targetCallable = delegateCreationArg or
            // Or the argument is an access to a callable
            targetCallable = delegateCreationArg.(CallableAccess).getTarget()
        )
    )
    // If the target callable returns true, validation is disabled
    and(
        exists(ReturnStmt rs, BlockStmt bs |
            bs = targetCallable.getBody() and
            bs.getNumberOfChildren() = 1 and
            bs.getChild(0) = rs and
            rs.getExpr().(BoolLiteral).getBoolValue() = true
        ) or
        targetCallable.getBody().(BoolLiteral).getBoolValue() = true
    )
select a, "Certificate validation disabled."
