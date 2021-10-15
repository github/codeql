import * as React from "react";
import { useParams } from "react-router-dom";
import request from 'request';

export function MyComponent() {
    const params = useParams();

    request('https://example.com/api/' + params.foo + '/id'); // OK - cannot manipulate path using `../`
    request(params.foo); // Possibly problematic, but not currently flagged.
}
