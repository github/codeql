---
category: feature
---
* Added support for [`@vercel/node`](https://www.npmjs.com/package/@vercel/node) Vercel serverless functions. Handlers are recognized via the `VercelRequest`/`VercelResponse` TypeScript parameter types, and standard security queries (`js/reflected-xss`, `js/request-forgery`, `js/sql-injection`, `js/command-line-injection`, etc.) now detect vulnerabilities in Vercel API route files.
