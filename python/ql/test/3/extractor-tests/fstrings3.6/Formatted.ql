import python

from FormattedValue val, string format, string typeconv
where
  (
    typeconv = val.getConversion()
    or
    not exists(val.getConversion()) and typeconv = " "
  ) and
  (
    format = val.getFormatSpec().getValue(0).(StringLiteral).getText()
    or
    not exists(val.getFormatSpec()) and format = ""
  )
select val.getLocation().getStartLine(), val, format, val.getValue(), typeconv
