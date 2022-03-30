import javascript
private import AngularJS

string describe(NgToken t) {
  exists(int start, string content |
    t.at(_, start) and
    t.is(content) and
    result = "(" + start + "-" + (start + content.length()) + ": " + t + ")"
  )
}

from NgSourceProvider provider, NgToken t, NgSource src, NgToken succ
where provider.providesSourceAt(src.getText(), _, _, _, _, _) and t.at(src, _) and succ = t.succ()
select provider, describe(t) + ".succ() = " + describe(succ)
