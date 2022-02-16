import * as React from "react";
import { useParams } from "react-router-dom";
import request from 'request';

export function MyComponent() {
    const params = useParams();

    request('https://example.com/api/' + params.foo + '/id'); // OK - cannot manipulate path using `../`
    request(params.foo); // Possibly problematic, but not currently flagged.

    const query = window.location.search.substring(1);
    request('https://example.com/api/' + query + '/id'); // NOT OK
    request('https://example.com/api?q=' + query); // OK
    request('https://example.com/api/' + window.location.search); // likely OK - but currently flagged anyway

    const fragment = window.location.hash.substring(1);
    request('https://example.com/api/' + fragment + '/id'); // NOT OK
    request('https://example.com/api?q=' + fragment); // OK

    const name = window.name;
    request('https://example.com/api/' + name + '/id'); // NOT OK
    request('https://example.com/api?q=' + name); // OK

    request(window.location.href + '?q=123'); // OK
}
