/**
 * @name Test for top JDK APIs
 * @description Provides a test case to check that a manual models exists for each each of the top JDK APIs.
 * @id java/top-jdk-apis-test
 */

import java
import semmle.code.java.dataflow.ExternalFlow
import TopJdkApis

from TopJdkApi topApi, string apiName
where
  topApi.hasManualMadModel() and
  apiName =
    topApi.getDeclaringType().getPackage() + "." + topApi.getDeclaringType().getSourceDeclaration() +
      "#" + topApi.getName() + paramsString(topApi)
select apiName order by apiName
