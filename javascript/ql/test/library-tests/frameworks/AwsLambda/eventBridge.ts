import type { EventBridgeEvent, EventBridgeHandler } from "aws-lambda";

export async function eventBridge(event: EventBridgeEvent<"OrderCreated", { orderId: string }>) {
  const detail = event.detail;
  const id = event.id;
}

export const eventBridgeHandler: EventBridgeHandler<"OrderCreated", { orderId: string }, void> = async (event) => {
  const detail = event.detail;
  const id = event.id;
};

// Type alias of an event type.
type OrderCreatedEvent = EventBridgeEvent<"OrderCreated", { orderId: string }>;

export async function aliasedEvent(event: OrderCreatedEvent) {
  const detail = event.detail;
}

// Interface extending an event type.
interface OrderEvent extends EventBridgeEvent<"OrderCreated", { orderId: string }> {
  tenantId: string;
}

export async function interfaceEvent(event: OrderEvent) {
  const detail = event.detail;
  const tenantId = event.tenantId;
}

// Type alias of a handler type.
type OrderCreatedHandler = EventBridgeHandler<"OrderCreated", { orderId: string }, void>;

export const aliasedHandler: OrderCreatedHandler = async (event) => {
  const detail = event.detail;
};

// Lookalike: not derived from the AWS types, even though it has the same property name.
interface LookalikeEvent {
  detail: { orderId: string };
}

export async function lookalikeEvent(event: LookalikeEvent) {
  const detail = event.detail;
}
