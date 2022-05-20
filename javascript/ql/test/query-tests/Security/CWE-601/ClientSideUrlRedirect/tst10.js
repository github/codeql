// OK - cannot affect hostname
location.href = '/foo' + document.location.search;

// NOT OK
location.href = '/' + document.location.search;

// NOT OK
location.href = '//' + document.location.search;

// NOT OK
location.href = '//foo' + document.location.search;

// NOT OK
location.href = 'https://foo' + document.location.search;
