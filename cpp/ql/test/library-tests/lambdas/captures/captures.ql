import cpp

from LambdaCapture lc, string mode
where if lc.isImplicit() then mode = "implicit" else mode = "explicit"
select lc, mode
