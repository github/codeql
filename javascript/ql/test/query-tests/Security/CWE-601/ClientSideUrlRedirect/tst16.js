import queryString from 'query-string';
import querystringify from 'querystringify';

function foo() {
    location.href = queryString.parse(location.search).data; // $ Alert
    location.href = queryString.extract(location.search); // $ Alert
    location.href = querystringify.parse(location.search).data; // $ Alert
}
