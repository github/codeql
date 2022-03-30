import python

from ClassObject cls, string kind
where
  cls.isDescriptorType() and
  /* Exclude bound-method as its name differs between 2 and 3 */
  not cls = theBoundMethodType() and
  (if cls.isOverridingDescriptorType() then kind = "overriding" else kind = "non-overriding")
select cls.toString(), kind
