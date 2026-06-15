async function t1() {
    const e = await import('./dynamicImportLib');
    e.getRequest(); // $ hasUnderlyingType='express'.Request
}
