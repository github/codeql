/**
 * @name Test for top JDK APIs
 * @description Provides a test case to check that a manual models exists for each each of the top JDK APIs.
 * @id java/top-jdk-apis-test
 */

import java
import semmle.code.java.dataflow.ExternalFlow
import TopJdkApis

from string apiName, TopJdkApi topApi
where
  // top jdk api names for which there is no callable
  topJdkApiName(apiName) and
  not hasCallable(apiName)
  or
  // top jdk api names for which there isn't a manual model
  not topApi.hasManualMadModel() and
  apiName =
    topApi.asCallable().getDeclaringType().getPackage() + "." +
      topApi.asCallable().getDeclaringType().getSourceDeclaration() + "#" +
      topApi.asCallable().getName() + paramsString(topApi.asCallable())
select apiName order by apiName
