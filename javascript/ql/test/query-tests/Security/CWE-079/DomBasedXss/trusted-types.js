import * as lib from './trusted-types-lib';

const policy1 = trustedTypes.createPolicy('x', { createHTML: x => x }); // $ Alert
policy1.createHTML(window.name); // $ Source

const policy2 = trustedTypes.createPolicy('x', { createHTML: x => 'safe' });
policy2.createHTML(window.name);

const policy3 = trustedTypes.createPolicy('x', { createHTML: x => x });
policy3.createHTML('safe');

const policy4 = trustedTypes.createPolicy('x', { createHTML: lib.createHtml });
policy4.createHTML(window.name); // $ Source
