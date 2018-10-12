/**
 * @name Non-parameterized constructor invocation
 * @description Parameterizing a call to a constructor of a generic type increases type safety and
 *              code readability.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/raw-constructor-invocation
 * @tags maintainability
 */

import java

from ClassInstanceExpr cie
where cie.getConstructor().getDeclaringType() instanceof RawType
select cie, "This is a non-parameterized constructor invocation of a generic type."
