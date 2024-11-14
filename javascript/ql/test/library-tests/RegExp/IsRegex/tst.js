new RegExp('^http://test\.example.com'); // NOT OK

function detectRegexViaSplice(string) {
    let found = getMyThing().search('regex'); // NOT OK
    arr.splice(found, 1);
};
