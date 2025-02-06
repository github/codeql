import Ajv from 'ajv';

let thing = {
    type: 'string',
    pattern: '(a?a?)*b' // $ Alert
}
new Ajv().addSchema(thing, 'thing');

export default {
    $schema: "http://json-schema.org/draft-07/schema#",
    type: "object",
    properties: {
        foo: {
            type: "string",
            pattern: "(a?a?)*b" // $ Alert
        },
        bar: {
            type: "object",
            patternProperties: {
                "(a?a?)*b": { // $ Alert
                    type: "number"
                }
            }
        }
    }
};
