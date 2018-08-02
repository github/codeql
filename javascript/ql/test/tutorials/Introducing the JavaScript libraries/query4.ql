import javascript

from ShiftExpr shift, AddExpr add
where add = shift.getAnOperand()
select add, "This expression should be bracketed to clarify precedence rules."
