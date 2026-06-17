(function f() { // $ Alert
  console.log("I'm never called.");
})

// anonymous function in parens - valid code but useless
;(function() { // $ Alert
  console.log("Also never called.");
})
