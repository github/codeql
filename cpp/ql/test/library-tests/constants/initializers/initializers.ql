import cpp
import Best_Practices.Magic_Constants.MagicConstants

from Literal l, Variable v
where literalIsConstantInitializer(l, v)
select l, v
