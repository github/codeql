import type { EventBridgeEvent, ScheduledEvent, SQSEvent, Context } from "aws-lambda";

export async function queueEvent(event: SQSEvent) {} // source

export async function genericEvent(event: EventBridgeEvent<"OrderCreated", { orderId: string }>) {} // source

export async function awsGeneratedEvent(event: ScheduledEvent) {} // not a source

export async function untypedEvent(event, context: Context) {} // not a source
