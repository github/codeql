overlay[local?]
module;

import ql

pragma[inline]
predicate foo(int x) { x = 42 }

overlay[caller]
pragma[inline]
predicate bar(int x) { x = 43 }

pragma[inline]
private predicate baz(int x) { x = 44 }

overlay[caller?]
pragma[inline]
predicate baw(int x) { x = 45 }
