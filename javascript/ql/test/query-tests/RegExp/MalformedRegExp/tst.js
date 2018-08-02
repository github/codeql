/a{1/;

function f() {
  return a.replace(/<\!--(?!{cke_protected})[\s\S]+?--\>/g, "foo");
}

/\u{ff}/
