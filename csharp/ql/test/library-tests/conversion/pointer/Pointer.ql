import csharp

from Assignment a
select a.getLocation(), a.getLeftOperand().getType().toString(),
  a.getRightOperand().getType().toString(), a.getRightOperand().toString()
