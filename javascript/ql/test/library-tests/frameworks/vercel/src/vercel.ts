import type { VercelRequest, VercelResponse } from "@vercel/node";

// A private helper with the same signature. Must NOT be recognized as a
// route handler, since Vercel only invokes the default export.
function internalHelper(req: VercelRequest, res: VercelResponse) {
  res.send(req.query.name);
}

export default function handler(req: VercelRequest, res: VercelResponse) {
  // Request inputs
  const q = req.query;            // source: parameter
  const b = req.body;              // source: body
  const c = req.cookies;           // source: cookie
  const u = req.url;               // source: url (inherited from IncomingMessage)
  const host = req.headers.host;   // source: header (named)
  const ref = req.headers.referer; // source: header (named)

  // Response header definition
  res.setHeader("Content-Type", "text/html");

  // Response send (direct and chained)
  res.send(q);
  res.status(200).send(b);

  // JSON response (direct and chained)
  res.json(c);
  res.status(200).json(u);
  res.jsonp(host);

  // Redirect
  res.redirect(req.query.url as string);
}
