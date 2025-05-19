// OK - we don't know whether the two elements are added to the same document
var div1 = <div id="theDiff"></div>;
var div2 = <div id="theDiff"></div>;

<a href="http://semmle.com" href="https://semmle.com">Semmle</a>; // $ Alert[js/conflicting-html-attribute]

<a href="https://semmle.com" href="https://semmle.com">Semmle</a>; // $ Alert[js/duplicate-html-attribute]

<div id=""></div>; // $ Alert[js/malformed-html-id]
<div id="a b"></div>; // $ Alert[js/malformed-html-id]

<a href="http://semmle.com" href={someValue()}>Semmle</a>; // $ Alert[js/conflicting-html-attribute]

<div id={someOtherValue()}></div>;

var div3 = <div><div id="theDiff"></div><div id="theDiff"></div></div>; // $ Alert[js/duplicate-html-id]

var div4 = <div id="theDiff" id="theDiff"></div>; // $ Alert[js/duplicate-html-attribute]
