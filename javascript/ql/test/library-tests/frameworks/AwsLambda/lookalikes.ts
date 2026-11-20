import type {
  APIGatewayProxyEvent as ImportedEvent,
  APIGatewayProxyHandler as ImportedHandler,
} from "./lookalikeTypes";

// Types with the same names and shapes as the ones in `@types/aws-lambda`, but declared here
// instead of imported from "aws-lambda".
interface APIGatewayProxyEvent {
  body: string | null;
  headers: Record<string, string | undefined>;
  httpMethod: string;
  path: string;
}

interface APIGatewayProxyResult {
  statusCode: number;
  body: string;
}

type APIGatewayProxyHandler = (
  event: APIGatewayProxyEvent,
  context: object,
) => Promise<APIGatewayProxyResult>;

export async function handler(event: APIGatewayProxyEvent) {
  return { statusCode: 200, body: event.body ?? "" };
} // not a source

export const typedHandler: APIGatewayProxyHandler = async (event) => {
  return { statusCode: 200, body: event.body ?? "" };
}; // not a source

// The same names, imported from a module other than "aws-lambda".
export async function importedEvent(event: ImportedEvent) {} // not a source

export const importedHandler: ImportedHandler = async (event) => {}; // not a source
