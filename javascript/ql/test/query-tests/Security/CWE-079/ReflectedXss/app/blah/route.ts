export async function GET(req: Request) {
    const url = req.url; // $ Source
    return new Response(url, { headers: { "Content-Type": "text/html" } }); // $ Alert
}
