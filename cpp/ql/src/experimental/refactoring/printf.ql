import cpp
import relevant

from Call call
where call.getTarget().getName().matches("%printf")
and is_relevant_result(call.getFile())
select call, "Call to a printf formatter", call.getFile().getRelativePath()
