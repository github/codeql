(function() {
    const policy1 = trustedTypes.createPolicy('x', { createHTML: x => x }); // NOT OK
    policy1.createHTML(window.name);

    const policy2 = trustedTypes.createPolicy('x', { createHTML: x => 'safe' }); // OK
    policy2.createHTML(window.name);

    const policy3 = trustedTypes.createPolicy('x', { createHTML: x => x }); // OK
    policy3.createHTML('safe');
})();
