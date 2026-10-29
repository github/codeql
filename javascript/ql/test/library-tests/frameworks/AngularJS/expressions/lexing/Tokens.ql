import javascript
private import AngularJS

string describe(NgToken t) {
  exists(int start, string content |
    t.at(_, start) and
    t.is(content) and
    result = "(" + start + "-" + (start + content.length()) + ": " + t + ")"
  )
}

from NgSourceProvider provider, NgToken t, NgSource src
where provider.providesSourceAt(src.getText(), _, _, _, _, _) and t.at(src, _)
select provider, describe(t)
