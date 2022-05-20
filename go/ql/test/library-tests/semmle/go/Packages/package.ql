import go

from string path
where
  (
    path = "github.com/nonexistent/v2/test" or // OK
    path = "github.com/nonexistent/test" or // OK
    path = "github.com/nonexistent//v//test" or // NOT OK
    path = "github.com/nonexistent//v/test" or // NOT OK
    path = "github.com/nonexistent/v//test" or // NOT OK
    path = "github.com/nonexistent/v/asd/v2/test" or // NOT OK
    path = "github.com/nonexistent/v/test" or // NOT OK
    path = "github.com/nonexistent//v2//test" or // NOT OK
    path = "github.com/nonexistent//v2/test" or // NOT OK
    path = "github.com/nonexistent/v2//test" // NOT OK
  ) and
  path = package("github.com/nonexistent", "test")
select path
