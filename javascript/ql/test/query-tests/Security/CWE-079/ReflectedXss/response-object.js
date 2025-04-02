const express = require('express');

// Note: We're using using express for the taint source in order to to test 'Response'
// in isolation from the more complicated http frameworks.

express().get('/foo', (req) => {
    const data = req.body; // $ MISSING: Source

    new Response(data); // $ MISSING: Alert
    new Response(data, {}); // $ MISSING: Alert
    new Response(data, { headers: null }); // $ MISSING: Alert

    new Response(data, { headers: { 'content-type': 'text/plain'}});
    new Response(data, { headers: { 'content-type': 'text/html'}}); // $ MISSING: Alert

    new Response(data, { headers: { 'Content-Type': 'text/plain'}});
    new Response(data, { headers: { 'Content-Type': 'text/html'}}); // $ MISSING: Alert

    const headers1 = new Headers({ 'content-type': 'text/plain'});
    new Response(data, { headers: headers1 });

    const headers2 = new Headers({ 'content-type': 'text/html'});
    new Response(data, { headers: headers2 }); // $ MISSING: Alert

    const headers3 = new Headers();
    new Response(data, { headers: headers3 }); // $ MISSING: Alert

    const headers4 = new Headers();
    headers4.set('content-type', 'text/plain');
    new Response(data, { headers: headers4 });

    const headers5 = new Headers();
    headers5.set('content-type', 'text/html');
    new Response(data, { headers: headers5 }); // $ MISSING: Alert

    const headers6 = new Headers();
    headers6.set('unrelated-header', 'text/plain');
    new Response(data, { headers: headers6 }); // $ MISSING: Alert
});
