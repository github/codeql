// OK - we don't know whether the two elements are added to the same document
var div1 = <div id="theDiff"></div>;
var div2 = <div id="theDiff"></div>;

<a href="http://semmle.com" href="https://semmle.com">Semmle</a>; // $ Alert

<a href="https://semmle.com" href="https://semmle.com">Semmle</a>; // $ Alert

<div id=""></div>; // $ Alert
<div id="a b"></div>;

<a href="http://semmle.com" href={someValue()}>Semmle</a>; // $ Alert


<div id={someOtherValue()}></div>;

var div3 = <div><div id="theDiff"></div><div id="theDiff"></div></div>; // $ Alert

var div4 = <div id="theDiff" id="theDiff"></div>; // $ Alert
