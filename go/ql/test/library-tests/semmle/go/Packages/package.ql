import go

from string path
where
  path =
    [
      "github.com/nonexistent/v2/test", // OK
      "github.com/nonexistent/test", // OK
      "github.com/nonexistent//v//test", // NOT OK
      "github.com/nonexistent//v/test", // NOT OK
      "github.com/nonexistent/v//test", // NOT OK
      "github.com/nonexistent/v/asd/v2/test", // NOT OK
      "github.com/nonexistent/v/test", // NOT OK
      "github.com/nonexistent//v2//test", // NOT OK
      "github.com/nonexistent//v2/test", // NOT OK
      "github.com/nonexistent/v2//test" // NOT OK
    ] and
  path = package("github.com/nonexistent", "test")
select path
