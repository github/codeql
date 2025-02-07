// OK - we don't know whether the two elements are added to the same document
var div1 = <div id="theDiff"></div>;
var div2 = <div id="theDiff"></div>;

<a href="http://semmle.com" href="https://semmle.com">Semmle</a>; // $ Alert TODO-MISSING: Alert[js/duplicate-html-attribute] Alert[js/malformed-html-id] Alert[js/duplicate-html-id]

<a href="https://semmle.com" href="https://semmle.com">Semmle</a>; // $ Alert TODO-MISSING: Alert[js/malformed-html-id] Alert[js/duplicate-html-id] Alert[js/conflicting-html-attribute]

<div id=""></div>; // $ Alert TODO-MISSING: Alert[js/duplicate-html-attribute] Alert[js/duplicate-html-id] Alert[js/conflicting-html-attribute]
<div id="a b"></div>; // $ TODO-SPURIOUS: Alert[js/malformed-html-id]

<a href="http://semmle.com" href={someValue()}>Semmle</a>; // $ Alert TODO-MISSING: Alert[js/duplicate-html-attribute] Alert[js/malformed-html-id] Alert[js/duplicate-html-id]


<div id={someOtherValue()}></div>;

var div3 = <div><div id="theDiff"></div><div id="theDiff"></div></div>; // $ Alert TODO-MISSING: Alert[js/duplicate-html-attribute] Alert[js/malformed-html-id] Alert[js/conflicting-html-attribute]

var div4 = <div id="theDiff" id="theDiff"></div>; // $ Alert TODO-MISSING: Alert[js/malformed-html-id] Alert[js/duplicate-html-id] Alert[js/conflicting-html-attribute]
