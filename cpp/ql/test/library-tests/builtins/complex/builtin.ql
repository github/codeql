import cpp

from BuiltInComplexOperation bico, Expr real, Expr imag
where
  real = bico.getRealOperand() and
  imag = bico.getImaginaryOperand()
select bico, bico.getType(), real, real.getType(), imag, imag.getType()
