import javascript

from CallSignature call, string abstractness
where if call.isAbstract() then abstractness = "abstract" else abstractness = "not abstract"
select call, call.getDeclaringType().describe(), call.getBody(), abstractness
