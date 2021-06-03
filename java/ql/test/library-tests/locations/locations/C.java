package locations;

import java.util.List;

public class C {
	List<?> stuff; // $wildcardTypeAccess=
	List<? extends Number> numbers; // $wildcardTypeAccess=u:Number
	List<? super Double> more_numbers; // $wildcardTypeAccess=l:Double
	List<? extends Number[]> numbersArr; // $wildcardTypeAccess=u:...[]
	List<? super Double[]> more_numbersArr; // $wildcardTypeAccess=l:...[]
}
