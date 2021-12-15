import cpp

from EnumConstant ec, Access ac
where
  ec.getName().matches("sizeof\\_arr%") and
  ac = ec.getAnAccess()
select ac
