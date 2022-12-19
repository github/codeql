import java
import TopJdkApis

from string apiName, string message
where
  // top jdk api names for which there is no callable
  topJdkApiName(apiName) and
  not exists(Callable c | hasApiName(c, apiName)) and
  message = "no callable"
  or
  // top jdk api names for which there isn't a manual model
  exists(TopJdkApi topApi |
    not topApi.hasManualMadModel() and
    hasApiName(topApi.asCallable(), apiName) and
    message = "no manual model"
  )
select apiName, message order by apiName
