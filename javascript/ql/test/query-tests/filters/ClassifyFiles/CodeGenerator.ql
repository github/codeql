import semmle.javascript.GeneratedCode

from CodeGeneratorMarkerComment cgmc
select cgmc, cgmc.getGeneratorName()
