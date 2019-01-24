import javascript

string getBound(CallSignatureType sig, int n) {
  result = sig.getTypeParameterBound(n).toString()
  or
  not exists(sig.getTypeParameterBound(n)) and
  result = "no bound" and
  n = [0 .. sig.getNumTypeParameter() - 1]
}

from CallSignatureType sig, int n
select sig, sig.getNumTypeParameter(), n, sig.getTypeParameterName(n), getBound(sig, n)
