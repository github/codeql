import go

from string path
where
  (
    path = "PackageName/v2/test" or // OK
    path = "PackageName/test" or // OK
    path = "PackageName//v//test" or // NOT OK
    path = "PackageName//v/test" or // NOT OK
    path = "PackageName/v//test" or // NOT OK
    path = "PackageName/v/asd/v2/test" or // NOT OK
    path = "PackageName/v/test" or // NOT OK
    path = "PackageName//v2//test" or // NOT OK
    path = "PackageName//v2/test" or // NOT OK
    path = "PackageName/v2//test" // NOT OK
  ) and
  path = package("PackageName", "test")
select path
