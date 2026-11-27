import type {
  APIGatewayProxyEvent,
  APIGatewayProxyEventV2,
  APIGatewayProxyEventV2WithJWTAuthorizer,
  APIGatewayProxyWithLambdaAuthorizerEvent,
  APIGatewayProxyWebsocketEventV2,
  APIGatewayTokenAuthorizerEvent,
  APIGatewayRequestAuthorizerEvent,
  Context,
} from "aws-lambda";

export async function proxyEvent(event: APIGatewayProxyEvent, context: Context) {} // source

export async function proxyEventV2(event: APIGatewayProxyEventV2) {} // source

export async function proxyEventV2WithJWTAuthorizer(event: APIGatewayProxyEventV2WithJWTAuthorizer) {} // source

export async function proxyWithLambdaAuthorizerEvent(event: APIGatewayProxyWithLambdaAuthorizerEvent<{}>) {} // source

export async function websocketEventV2(event: APIGatewayProxyWebsocketEventV2) {} // source

export async function tokenAuthorizerEvent(event: APIGatewayTokenAuthorizerEvent) {} // source

export async function requestAuthorizerEvent(event: APIGatewayRequestAuthorizerEvent) {} // source

interface CustomEvent extends APIGatewayProxyEvent {
  tenant: string;
}

export async function subtypedCustomEvent(event: CustomEvent) {} // source

// Not exported, so not invoked by Lambda.
async function privateHandler(event: APIGatewayProxyEvent) {} // not a source

export const mock: APIGatewayProxyEvent = {} as APIGatewayProxyEvent; // not a source
