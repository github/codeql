---
category: minorAnalysis
---
* Added request forgery sink models for the Azure SDK.
* Made it so that models-as-data sinks with the kind `request-forgery` contribute to the class `Http::Client::Request` which represents HTTP client requests.