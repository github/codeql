import csharp

from Operation e
where e.getAnOperand().getType() instanceof PointerType
select e.getLocation().getStartLine(), e
