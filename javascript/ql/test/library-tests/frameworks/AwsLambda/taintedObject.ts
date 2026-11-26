import type { AppSyncResolverEvent, AppSyncResolverHandler, EventBridgeEvent, EventBridgeHandler } from "aws-lambda";

export async function eventBridge(event: EventBridgeEvent<"OrderCreated", { orderId: string }>) {
  const detail = event.detail; // $ taintedObjectSource
  const id = event.id;
}

export const eventBridgeHandler: EventBridgeHandler<"OrderCreated", { orderId: string }, void> = async (event) => {
  const detail = event.detail; // $ taintedObjectSource
  const id = event.id;
};

export async function appSync(event: AppSyncResolverEvent<{ orderId: string }>) {
  const args = event.arguments; // $ taintedObjectSource
  const info = event.info;
}

export const appSyncHandler: AppSyncResolverHandler<{ orderId: string }, void> = async (event) => {
  const args = event.arguments; // $ taintedObjectSource
  const info = event.info;
};

// Type alias of an event type.
type OrderCreatedEvent = EventBridgeEvent<"OrderCreated", { orderId: string }>;

export async function aliasedEvent(event: OrderCreatedEvent) {
  const detail = event.detail; // $ taintedObjectSource
}

// Interface extending an event type.
interface OrderEvent extends EventBridgeEvent<"OrderCreated", { orderId: string }> {
  tenantId: string;
}

export async function interfaceEvent(event: OrderEvent) {
  const detail = event.detail; // $ taintedObjectSource
  const tenantId = event.tenantId;
}

// Type alias of a handler type.
type OrderCreatedHandler = EventBridgeHandler<"OrderCreated", { orderId: string }, void>;

export const aliasedHandler: OrderCreatedHandler = async (event) => {
  const detail = event.detail; // $ taintedObjectSource
};

// Lookalike: not derived from the AWS types, even though it has the same property name.
interface LookalikeEvent {
  detail: { orderId: string };
}

export async function lookalikeEvent(event: LookalikeEvent) {
  const detail = event.detail;
}

// Non-exported helpers are not handlers, so their parameters are not sources.
async function privateEventBridgeHelper(event: EventBridgeEvent<"OrderCreated", { orderId: string }>) {
  const detail = event.detail;
}

async function privateAppSyncHelper(event: AppSyncResolverEvent<{ orderId: string }>) {
  const args = event.arguments;
}

const privateEventBridgeHandler: EventBridgeHandler<"OrderCreated", { orderId: string }, void> = async (event) => {
  const detail = event.detail;
};
