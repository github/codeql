(function() {
  let otherAttrs = { target: "_blank" };
  let rel = "noopener";
  let a = <a href="https://semmle.com" rel={rel} {...otherAttrs}>Semmle</a>;
  a.rel = "noreferrer noopener";
})();