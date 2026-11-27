import type {
  CloudFrontRequestEvent,
  CloudFrontRequestHandler,
  CloudFrontResponseEvent,
} from "aws-lambda";

export async function requestEvent(event: CloudFrontRequestEvent) {} // source

export async function responseEvent(event: CloudFrontResponseEvent) {} // source

export const typedHandler: CloudFrontRequestHandler = async (event) => {}; // source
