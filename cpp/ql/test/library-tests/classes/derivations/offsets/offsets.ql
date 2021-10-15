import cpp

from ClassDerivation cd
select cd.getLocation().getStartLine(), cd.getDerivedClass().toString(),
  cd.getBaseClass().toString(), cd.getByteOffset()
