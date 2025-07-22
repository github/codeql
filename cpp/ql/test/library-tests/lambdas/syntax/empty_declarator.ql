import cpp

from LambdaExpression e, string parameterList
where if e.hasParameterList() then parameterList = "with list" else parameterList = "without list"
select e, parameterList, e.getLambdaFunction().getNumberOfParameters()
