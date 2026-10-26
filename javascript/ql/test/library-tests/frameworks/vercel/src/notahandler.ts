import type { VercelRequest, VercelResponse } from "@vercel/node";

// A default-exported function that has VercelRequest/VercelResponse at
// positions 1 and 2, not 0 and 1. Vercel does not invoke it this way,
// so it must NOT be recognized as a route handler.
export default function notAHandler(ctx: unknown, req: VercelRequest, res: VercelResponse) {
  res.send(req.query.name);
}
