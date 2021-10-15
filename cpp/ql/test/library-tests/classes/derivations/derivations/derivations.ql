import cpp

from ClassDerivation cd
select cd, cd.getLocation().getStartLine(), cd.getDerivedClass(), cd.getASpecifier(),
  cd.getBaseClass()
