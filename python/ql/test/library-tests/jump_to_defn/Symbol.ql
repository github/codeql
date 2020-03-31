import python
import analysis.CrossProjectDefinitions

from Symbol symbol
select symbol.toString(), symbol.find().getLocation().toString()
