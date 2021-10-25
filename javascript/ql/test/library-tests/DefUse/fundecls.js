function s() { // dead
  function f() {} // dead
  function f() {} // alive
  f();
}

s();

function s() { // alive
  f();
  function f() {} // dead
  function f() {} // alive
}

!function() {
  function f() {} // dead
  f();
  function f() {} // alive
}

!function() {{
  function f() {} // dead
  function f() {} // alive
  f();
}}

!function() {{
  f();
  function f() {} // dead
  function f() {} // dead
}}

!function() {{
  function f() {} // alive
  f();
  function f() {} // dead
}}

!function(x) {
  if (x) {
    function f() { return 23; } // alive
  } else {
    function f() { return 42; } // alive
  }
  f();
}

!function(x) {
  'use strict';
  if (x) {
    function f() { return 23; } // dead
  } else {
    function f() { return 42; } // dead
  }
  f(); // f isn't in scope here
}