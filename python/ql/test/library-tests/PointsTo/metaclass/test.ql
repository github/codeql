
import python

from ClassObject cls
where cls.getPyClass().getEnclosingModule().getName() = "test"
select cls.toString(), cls.getMetaClass().toString()
