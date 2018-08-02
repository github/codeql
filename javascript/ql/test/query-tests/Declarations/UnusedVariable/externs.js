/**
 * @externs
 */

// NOT OK
var iAmUnused;

// OK: used as a type
/**
 * @typedef string 
 */
var MyString;

/**
 * @type {MyString}
 */
var foo;

exports.foo = foo;