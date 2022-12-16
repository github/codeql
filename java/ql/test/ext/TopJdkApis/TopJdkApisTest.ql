import java
import TopJdkApis

from string apiName, string message
where
  // top jdk api names for which there is no callable
  topJdkApiName(apiName) and
  not hasCallable(apiName) and
  message = "no callable"
  or
  // top jdk api names for which there isn't a manual model
  exists(TopJdkApi topApi |
    not topApi.hasManualMadModel() and
    apiName = getApiName(topApi.asCallable()) and
    message = "no manual model"
  )
select apiName, message order by apiName
