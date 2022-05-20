import cpp

// The main purpose of this test is to trigger a database consistency
// check on the test code, but we may as well keep an eye on its
// expressions seeing as we have to compile a query anyway.
from Expr e
select e.getLocation(), e
