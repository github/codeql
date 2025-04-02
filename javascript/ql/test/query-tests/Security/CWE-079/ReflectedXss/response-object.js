const express = require('express');

// Note: We're using using express for the taint source in order to to test 'Response'
// in isolation from the more complicated http frameworks.

express().get('/foo', (req) => {
    const data = req.body; // $ Source

    new Response(data); // $ Alert
    new Response(data, {}); // $ Alert
    new Response(data, { headers: null }); // $ Alert

    new Response(data, { headers: { 'content-type': 'text/plain'}}); // $ SPURIOUS: Alert
    new Response(data, { headers: { 'content-type': 'text/html'}}); // $ Alert

    new Response(data, { headers: { 'Content-Type': 'text/plain'}}); // $ SPURIOUS: Alert
    new Response(data, { headers: { 'Content-Type': 'text/html'}}); // $ Alert

    const headers1 = new Headers({ 'content-type': 'text/plain'});
    new Response(data, { headers: headers1 }); // $ SPURIOUS: Alert

    const headers2 = new Headers({ 'content-type': 'text/html'});
    new Response(data, { headers: headers2 }); // $ Alert

    const headers3 = new Headers();
    new Response(data, { headers: headers3 }); // $ Alert

    const headers4 = new Headers();
    headers4.set('content-type', 'text/plain');
    new Response(data, { headers: headers4 }); // $ SPURIOUS: Alert

    const headers5 = new Headers();
    headers5.set('content-type', 'text/html');
    new Response(data, { headers: headers5 }); // $ Alert

    const headers6 = new Headers();
    headers6.set('unrelated-header', 'text/plain');
    new Response(data, { headers: headers6 }); // $ Alert
});
