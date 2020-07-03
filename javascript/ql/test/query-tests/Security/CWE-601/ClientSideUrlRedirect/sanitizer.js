function f() {
    let url = window.name;
    if (url.startsWith('https://example.com')) {
        window.location = url; // NOT OK - can be example.com.evil.com
    }
    if (url.startsWith('https://example.com/')) {
        window.location = url; // OK - but flagged anyway
    }
    if (url.startsWith('https://example.com//')) {
        window.location = url; // OK - but flagged anyway
    }
    if (url.startsWith('https://example.com/foo')) {
        window.location = url; // OK - but flagged anyway 
    }
    if (url.startsWith('https://')) {
        window.location = url; // NOT OK - does not restrict hostname
    }
    if (url.startsWith('https:/')) {
        window.location = url; // NOT OK - does not restrict hostname
    }
    if (url.startsWith('https:')) {
        window.location = url; // NOT OK - does not restrict hostname
    }
    if (url.startsWith('/')) {
        window.location = url; // NOT OK - can be //evil.com
    }
    if (url.startsWith('//')) {
        window.location = url; // NOT OK - can be //evil.com
    }
    if (url.startsWith('//example.com')) {
        window.location = url; // NOT OK - can be //example.com.evil.com
    }
    if (url.startsWith('//example.com/')) {
        window.location = url; // OK - but flagged anyway
    }
    if (url.endsWith('https://example.com/')) {
        window.location = url; // NOT OK - could be evil.com?x=https://example.com/
    }
}
