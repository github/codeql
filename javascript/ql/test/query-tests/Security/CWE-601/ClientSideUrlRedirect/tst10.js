// OK - cannot affect hostname
location.href = '/foo' + document.location.search.substring(1);

// NOT OK
location.href = '/' + document.location.search.substring(1);

// NOT OK
location.href = '//' + document.location.search.substring(1);

// NOT OK
location.href = '//foo' + document.location.search.substring(1);

// NOT OK
location.href = 'https://foo' + document.location.search.substring(1);
