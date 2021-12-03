import python

from File f, string encoding
where
  encoding = f.getSpecifiedEncoding()
  or
  not exists(f.getSpecifiedEncoding()) and encoding = "none"
select f.getAbsolutePath(), encoding
