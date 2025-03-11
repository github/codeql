import queryString from 'query-string';
import querystringify from 'querystringify';

function foo() {
    location.href = queryString.parse(location.search).data; // NOT OK
    location.href = queryString.extract(location.search); // NOT OK
    location.href = querystringify.parse(location.search).data; // NOT OK
}
