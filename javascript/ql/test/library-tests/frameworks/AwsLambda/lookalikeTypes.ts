export interface APIGatewayProxyEvent { body: string }
export type APIGatewayProxyHandler = (event: any) => Promise<void>;
