/a{1/; // OK

function f() {
  return a.replace(/<\!--(?!{cke_protected})[\s\S]+?--\>/g, "foo");
}

/\u{ff}/
