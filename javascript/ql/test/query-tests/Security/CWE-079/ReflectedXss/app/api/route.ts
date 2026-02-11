export async function POST(req: Request) {
    const body = await req.json(); // $ Source

    new Response(body, {headers: { 'Content-Type': 'application/json' }});
    new Response(body, {headers: { 'Content-Type': 'text/html' }});  // $ Alert
    
    const headers2 = new Headers(req.headers);
    headers2.append('Content-Type', 'application/json');
    new Response(body, { headers: headers2 });

    const headers3 = new Headers(req.headers);
    headers3.append('Content-Type', 'text/html');
    new Response(body, { headers: headers3 }); // $ Alert

    const headers4 = new Headers({
        ...Object.fromEntries(req.headers),
        'Content-Type': 'application/json'
    });
    new Response(body, { headers: headers4 });

    const headers5 = new Headers({
        ...Object.fromEntries(req.headers),
        'Content-Type': 'text/html'
    });
    new Response(body, { headers: headers5 }); // $ Alert

    const headers = new Headers(req.headers);
    headers.set('Content-Type', 'text/html');
    return new Response(body, { headers }); // $ Alert
}
