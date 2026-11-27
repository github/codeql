import type {
  APIGatewayProxyEvent,
  APIGatewayProxyHandler,
  APIGatewayProxyHandlerV2,
  Handler,
  SQSEvent,
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

// Base `Handler` type does not have a specific event type.
export const genericHandler: Handler = async (event) => {}; // not a source

// An untyped handler function assigned to a variable is considered an AWS Lambda handler
// when exported with a type.
const untypedHandler = async (event) => {}; // source
export const exportedAliasedHandler: APIGatewayProxyHandler = untypedHandler;

// Passing a typed event to a function does not make the function an AWS Lambda handler.
function typedPrivateCaller(e: SQSEvent) {
  exportedGenericFunction(e);
}

export function exportedGenericFunction(e: any) {} // not a source

// A handler assigned to a typed variable after its declaration.
let lateAssignedHandler: SQSHandler;
lateAssignedHandler = async (event) => {}; // source
export { lateAssignedHandler };

// A handler expression with a `satisfies` or `as` handler type.
export const satisfiedHandler = (async (event) => {}) satisfies APIGatewayProxyHandler; // source
export const castHandler = (async (event) => {}) as APIGatewayProxyHandler; // source
