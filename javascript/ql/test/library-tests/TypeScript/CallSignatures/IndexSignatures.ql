import javascript

from IndexSignature sig, string abstractness
where if sig.isAbstract() then abstractness = "abstract" else abstractness = "not abstract"
select sig, sig.getDeclaringType().describe(), sig.getBody(), abstractness
