/*
 * Note this is similar to src/experimental/Security/CWE/CWE-555/CredentialsInPropertiesFile.ql
 * except we do not filter out test files.
 */

import java
import experimental.semmle.code.java.frameworks.CredentialsInPropertiesFile

from CredentialsConfig cc
select cc, cc.getConfigDesc()
