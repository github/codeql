/a{1/;

function f() {
  return a.replace(/<\!--(?!{cke_protected})[\s\S]+?--\>/g, "foo"); // $ TODO-SPURIOUS: Alert
}

/\u{ff}/
