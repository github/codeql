function f() {
    let url = window.name; // $ Source
    if (url.startsWith('https://example.com')) {
        window.location = url; // $ Alert - can be example.com.evil.com
    }
    if (url.startsWith('https://example.com/')) {
        window.location = url;
    }
    if (url.startsWith('https://example.com//')) {
        window.location = url;
    }
    if (url.startsWith('https://example.com/foo')) {
        window.location = url;
    }
    if (url.startsWith('https://')) {
        window.location = url; // $ Alert - does not restrict hostname
    }
    if (url.startsWith('https:/')) {
        window.location = url; // $ Alert - does not restrict hostname
    }
    if (url.startsWith('https:')) {
        window.location = url; // $ Alert - does not restrict hostname
    }
    if (url.startsWith('/')) {
        window.location = url; // $ Alert - can be //evil.com
    }
    if (url.startsWith('//')) {
        window.location = url; // $ Alert - can be //evil.com
    }
    if (url.startsWith('//example.com')) {
        window.location = url; // $ Alert - can be //example.com.evil.com
    }
    if (url.startsWith('//example.com/')) {
        window.location = url;
    }
    if (url.endsWith('https://example.com/')) {
        window.location = url; // $ Alert - could be evil.com?x=https://example.com/
    }
    let basedir = whatever() ? 'foo' : 'bar';
    if (url.startsWith('https://example.com/' + basedir)) {
        window.location = url; // OK - the whole prefix is not known, but enough to restrict hostname
    }
}
