import python
import semmle.python.Comparisons

from Comparison a, Comparison that, boolean thisIsTrue, boolean thatIsTrue
where a.impliesThat(thisIsTrue, that, thatIsTrue)
select a.getLocation().getStartLine(), thisIsTrue, that.getLocation().getStartLine(), thatIsTrue
