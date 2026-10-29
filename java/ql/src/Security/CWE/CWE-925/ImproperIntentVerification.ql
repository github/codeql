/**
 * @name Improper verification of intent by broadcast receiver
 * @description A broadcast receiver that does not verify intents it receives may be susceptible to unintended behavior by third party applications sending it explicit intents.
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

from AndroidReceiverXmlElement reg, Method orm, SystemActionName sa
where unverifiedSystemReceiver(reg, orm, sa)
select orm, "This reciever doesn't verify intents it receives, and $@ to receive $@.", reg,
  "it is registered", sa, "the system action " + sa.getName()
