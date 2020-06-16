function safeProp(key) {
    return /^[_$a-zA-Z][_$a-zA-Z0-9]*$/.test(key) ? `.${key}` : `[${JSON.stringify(key)}]`;
}

function test1() {
    const statements = [];
    statements.push(`${name}${safeProp(key)}=${stringify(thing[key])}`);
    return `(function(){${statements.join(';')}})` // NOT OK
}

import htmlescape from 'htmlescape'

function test2(props) {
    const pathname = props.data.pathname;
    return `function(){return new Error('${htmlescape(pathname)}')}`; // NOT OK
}

function test3(input) {
    return `(function(){${JSON.stringify(input)}))` // NOT OK
}

function evenSaferProp(key) {
    return /^[_$a-zA-Z][_$a-zA-Z0-9]*$/.test(key) ? `.${key}` : `[${JSON.stringify(key)}]`.replace(/[<>\b\f\n\r\t\0\u2028\u2029]/g, '');
}

function test4(input) {
    return `(function(){${evenSaferProp(input)}))` // OK
}

function test4(input) {
    var foo = `(function(){${JSON.stringify(input)}))` // NOT OK - we can type-track to a code-injection sink, the source is not remote flow.
    setTimeout(foo);
}

function test5(input) {
    console.log('methodName() => ' + JSON.stringify(input)); // OK
}

function test6(input) {
    return `(() => {${JSON.stringify(input)})` // NOT OK
}

function test7(input) {
    return `() => {${JSON.stringify(input)}` // NOT OK
}

var express = require('express');

var app = express();

app.get('/some/path', function(req, res) {
  var foo = `(function(){${JSON.stringify(req.param("wobble"))}))` // NOT - the source is remote-flow, but we know of no sink.

  setTimeout(`(function(){${JSON.stringify(req.param("wobble"))}))`); // OK - the source is remote-flow, and the sink is code-injection.

  var taint = [req.body.name, "foo"].join("\n");
   
  setTimeout(`(function(){${JSON.stringify(taint)}))`); // OK - the source is remote-flow, and the sink is code-injection.
});

// Bad documentation example: 
function createObjectWrite() {
    const assignment = `obj[${JSON.stringify(key)}]=42`;
    return `(function(){${assignment}})` // NOT OK
}

// Good documentation example: 
function good() {
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
}