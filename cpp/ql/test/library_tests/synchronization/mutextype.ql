import cpp
import testoptions

from MutexType mt, string s, Element e
where
  s = "is MutexType" and
  e = mt
  or
  s = "getLockAccess()" and
  e = mt.getLockAccess()
  or
  s = "getMustlockAccess()" and
  e = mt.getMustlockAccess()
  or
  s = "getTrylockAccess()" and
  e = mt.getTrylockAccess()
  or
  s = "getUnlockAccess()" and
  e = mt.getUnlockAccess()
select mt, s, e
