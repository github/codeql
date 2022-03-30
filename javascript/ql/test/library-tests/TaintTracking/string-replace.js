import 'dummy';

let taint = source();

taint.replace('foo', data => {
    sink(data); // OK - can only be the value 'foo'
});

taint.replace(/\d+/, data => {
    sink(data); // OK - can only be digits
});

taint.replace(/[^a-z]+/, data => {
    sink(data); // NOT OK
});

taint.replace(/&[^&]+;/, data => {
    sink(data); // NOT OK
});

sink(safe().replace('foo', data => taint)); // NOT OK
sink(safe().replace('foo', data => data + taint)); // NOT OK

sink(taint.replace('foo', data => data + '!')); // NOT OK -- propagates through replace call
