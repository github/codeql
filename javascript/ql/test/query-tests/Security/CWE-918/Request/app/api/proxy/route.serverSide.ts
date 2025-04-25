export async function POST(req: Request) {
  const { url } = await req.json(); // $ Source[js/request-forgery]
  const res = await fetch(url); // $ Alert[js/request-forgery]
  return new Response(res.body, { headers: res.headers });
}
