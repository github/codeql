import cpp

from TemplateClass tc, Declaration f
where f = tc.getAFriendDecl().getFriend()
select tc, f
