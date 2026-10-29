import semmle.code.cpp.commons.Environment

from EnvironmentRead read
select read, read.getEnvironmentVariable(), read.getSourceDescription()
