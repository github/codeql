// OK - cannot affect hostname
location.href = '/foo' + document.location.search.substring(1);

location.href = '/' + document.location.search.substring(1); // $ Alert

location.href = '//' + document.location.search.substring(1); // $ Alert

location.href = '//foo' + document.location.search.substring(1); // $ Alert

location.href = 'https://foo' + document.location.search.substring(1); // $ Alert
