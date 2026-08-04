import type { VercelRequest, VercelResponse } from "@vercel/node";

export default async function handler(req: VercelRequest, res: VercelResponse) {
  const url = req.query.url as string; // $ Source[js/request-forgery]
  const response = await fetch(url); // $ Alert[js/request-forgery]
  res.json(await response.json());
}
