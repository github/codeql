export async function POST(req: Request) {
  const { url } = await req.json(); // $ MISSING: Source[js/request-forgery]
  const res = await fetch(url); // $ MISSING: Alert[js/request-forgery] Sink[js/request-forgery]
  return new Response(res.body, { headers: res.headers });
}
