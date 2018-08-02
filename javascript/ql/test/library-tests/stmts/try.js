try { // semmle-extractor-options: --extract-program-text
    throw "!";
} catch(x) { ; }
try {} finally { ; }
try {} catch(x) {} finally {}