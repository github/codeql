import cpp

string describe(VirtualFunction f) {
  f instanceof PureVirtualFunction and
  result = "PureVirtualFunction"
}

from VirtualFunction f
select f, f.getDeclaringType(),
  concat(f.getAnOverridingFunction().getDeclaringType().toString(), ", "),
  concat(f.getAnOverriddenFunction().getDeclaringType().toString(), ", "), concat(describe(f), ", ")
