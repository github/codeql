import * as React from "react";
import { useParams } from "react-router-dom";
import request from 'request';

export function MyComponent() {
    const params = useParams();

    request('https://example.com/api/' + params.foo + '/id'); // OK - cannot manipulate path using `../`
    request(params.foo); // Possibly problematic, but not currently flagged.

    const query = window.location.search.substring(1); // $ Source[js/client-side-request-forgery]
    request('https://example.com/api/' + query + '/id'); // $ Alert[js/client-side-request-forgery] Sink[js/client-side-request-forgery]
    request('https://example.com/api?q=' + query);
    request('https://example.com/api/' + window.location.search); // $ Alert[js/client-side-request-forgery] Sink[js/client-side-request-forgery] - likely OK - but currently flagged anyway

    const fragment = window.location.hash.substring(1); // $ Source[js/client-side-request-forgery]
    request('https://example.com/api/' + fragment + '/id'); // $ Alert[js/client-side-request-forgery] Sink[js/client-side-request-forgery]
    request('https://example.com/api?q=' + fragment);

    const name = window.name; // $ Source[js/client-side-request-forgery]
    request('https://example.com/api/' + name + '/id'); // $ Alert[js/client-side-request-forgery] Sink[js/client-side-request-forgery]
    request('https://example.com/api?q=' + name);

    request(window.location.href + '?q=123');
}
