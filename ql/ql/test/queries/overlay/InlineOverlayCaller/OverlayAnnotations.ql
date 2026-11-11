import ql

from Annotation a
where
  a instanceof OverlayCaller or
  a instanceof OverlayCallerQ or
  a instanceof OverlayLocal or
  a instanceof OverlayLocalQ
select a, a.toString()
