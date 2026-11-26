import type { AppSyncResolverEvent, AppSyncResolverHandler } from "aws-lambda";

export async function appSync(event: AppSyncResolverEvent<{ orderId: string }>) {
  const args = event.arguments;
  const info = event.info;
}

export const appSyncHandler: AppSyncResolverHandler<{ orderId: string }, void> = async (event) => {
  const args = event.arguments;
  const info = event.info;
};
