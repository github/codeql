// OK: we don't know whether the two elements are added to the same document
var div1 = <div id="theDiff"></div>;
var div2 = <div id="theDiff"></div>;

// not OK
<a href="http://semmle.com" href="https://semmle.com">Semmle</a>;

// not OK
<a href="https://semmle.com" href="https://semmle.com">Semmle</a>;

// not OK
<div id=""></div>;
<div id="a b"></div>;

// not OK
<a href="http://semmle.com" href={someValue()}>Semmle</a>;

// OK
<div id={someOtherValue()}></div>;

// not OK
var div3 = <div><div id="theDiff"></div><div id="theDiff"></div></div>;

// not OK
var div4 = <div id="theDiff" id="theDiff"></div>;
