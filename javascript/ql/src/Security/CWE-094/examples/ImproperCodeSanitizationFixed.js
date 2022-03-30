const charMap = {
    '<': '\\u003C',
    '>' : '\\u003E',
    '/': '\\u002F',
    '\\': '\\\\',
    '\b': '\\b',
    '\f': '\\f',
    '\n': '\\n',
    '\r': '\\r',
    '\t': '\\t',
    '\0': '\\0',
    '\u2028': '\\u2028',
    '\u2029': '\\u2029'
};

function escapeUnsafeChars(str) {
    return str.replace(/[<>\b\f\n\r\t\0\u2028\u2029]/g, x => charMap[x])
}

function createObjectWrite() {
    const assignment = `obj[${escapeUnsafeChars(JSON.stringify(key))}]=42`;
    return `(function(){${assignment}})` // OK
}