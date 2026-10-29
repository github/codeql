import semmle.code.cpp.padding.Padding

from Architecture a, PaddedType t
select a, t, t.typeBitSize(a), t.dataSize(a), t.paddedSize(a)
