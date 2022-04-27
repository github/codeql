/**
 * @name Improper Verification of Intent by Broadcast Reciever
 * @description The Android application uses a Broadcast Receiver that receives an Intent but does not properly verify that the Intent came from an authorized source.
 * @kind problem
 * @problem.severity warning
 * @security-severity 8.2
 * @precision high
 * @id java/improper-intent-verification
 * @tags security
 *       external/cwe/cwe-925
 */

import java
import semmle.code.java.security.ImproperIntentVerificationQuery

from Top reg, Method orm, SystemActionName sa
where unverifiedSystemReceiver(reg, orm, sa)
select orm, "This reciever doesn't verify intents it recieves, and is registered $@ to recieve $@.",
  reg, "here", sa, "the system action " + sa.getName()
