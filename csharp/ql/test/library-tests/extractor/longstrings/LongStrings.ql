import csharp

from StringLiteral ascii, StringLiteral utf8
where
  ascii.getValue().length() = 1048576 and
  // UTF8 encoding can vary a little from platform to platform
  utf8.getValue().length() > 440000 and
  utf8.getValue().length() < 450000
select "Test passed"
