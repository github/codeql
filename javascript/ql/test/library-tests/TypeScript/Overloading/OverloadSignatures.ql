import javascript

from MemberDeclaration m, string kind
where if m instanceof MemberSignature then kind = "Signature" else kind = "Definition"
select m, m.getDeclaringType().describe() + "." + m.getName() + ": " + kind
