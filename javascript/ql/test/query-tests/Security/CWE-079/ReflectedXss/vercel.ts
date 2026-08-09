import type { VercelRequest, VercelResponse } from "@vercel/node";

export default function handler(req: VercelRequest, res: VercelResponse) {
  res.setHeader("Content-Type", "text/html");
  res.status(200).send(`<h1>${req.query.name}</h1>`); // $ Alert
}
