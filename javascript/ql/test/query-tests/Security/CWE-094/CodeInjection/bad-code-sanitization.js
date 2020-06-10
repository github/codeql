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
    var foo = `(function(){${JSON.stringify(input)}))` // OK - for this query - we can type-track to a code-injection sink.
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