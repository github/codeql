import type { NowRequest, NowResponse } from "@now/node";

// Legacy Zeit-era aliases. The model should treat these identically to
// the modern @vercel/node types (NowRequest -> VercelRequest, NowResponse -> VercelResponse).
export default function handler(req: NowRequest, res: NowResponse) {
  res.send(req.query.name);
}
