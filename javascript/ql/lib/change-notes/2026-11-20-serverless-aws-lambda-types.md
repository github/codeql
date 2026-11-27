---
category: minorAnalysis
---
* The event parameter of AWS Lambda handlers that use the types from `@types/aws-lambda` is now treated as a remote flow source. This applies to exported functions whose event is annotated with an event type such as `APIGatewayProxyEvent`, and to exported functions assigned to a variable annotated with a handler type such as `APIGatewayProxyHandler`. Support for additional events can be extended using the new Models as Data (MaD) `aws-lambda.Event` and `aws-lambda.EventFunctionHandler` type models.
