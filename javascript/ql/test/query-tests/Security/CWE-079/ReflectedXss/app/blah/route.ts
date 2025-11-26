export async function GET(req: Request) {
    const url = req.url; // $ MISSING: Source
    return new Response(url, { headers: { "Content-Type": "text/html" } }); // $ MISSING: Alert
}
