import javascript


// 1. The sink is any argumnent[i], i > 2, to  _.merge(message, req.body.message,...)
from MethodCallExpr call
where
    // Identify the call
    call.getReceiver().toString() =  "_" and
    call.getMethodName() = "merge"
select call


// 2. The source 

// 3. Local flow between the source and sink

