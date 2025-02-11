import Ajv from 'ajv';

let thing = {
    type: 'string',
    pattern: '(a?a?)*b' // $ Alert TODO-MISSING: Alert[js/polynomial-redos]
}
new Ajv().addSchema(thing, 'thing');

export default {
    $schema: "http://json-schema.org/draft-07/schema#",
    type: "object",
    properties: {
        foo: {
            type: "string",
            pattern: "(a?a?)*b" // $ Alert TODO-MISSING: Alert[js/polynomial-redos]
        },
        bar: {
            type: "object",
            patternProperties: {
                "(a?a?)*b": { // $ Alert TODO-MISSING: Alert[js/polynomial-redos]
                    type: "number"
                }
            }
        }
    }
};
