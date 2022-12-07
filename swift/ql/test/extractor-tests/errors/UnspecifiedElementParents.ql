import swift

from UnspecifiedElement e, Locatable parent
where parent = e.getParent()
select parent, e
