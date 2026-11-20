import type {
  APIGatewayProxyEvent,
  APIGatewayProxyHandler,
  APIGatewayProxyHandlerV2,
  Handler,
  SQSHandler,
} from "aws-lambda";

export const handlerWithUnannotatedEvent: APIGatewayProxyHandler = async (event) => {
  return { statusCode: 200, body: event.body ?? "" };
}; // source

export const handlerWithAnnotatedEvent: APIGatewayProxyHandler = async (event: APIGatewayProxyEvent) => {
  return { statusCode: 200, body: event.body ?? "" };
}; // source

export const handlerWithUnannotatedEventAndContext: APIGatewayProxyHandlerV2 = async (event, context) => {}; // source

export const nonHttpHandler: SQSHandler = async (event) => {}; // source

// Not exported, so not invoked by Lambda.
const privateHandler: APIGatewayProxyHandler = async (event) => {}; // not a source

// `Handler` does not say what the event is.
export const genericHandler: Handler = async (event) => {}; // not a source
