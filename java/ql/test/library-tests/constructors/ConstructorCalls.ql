/**
 * @name ConstructorCalls
 * @description Test the difference between ClassInstanceExpr and ConstructorCall
 */

import default

// There should be three constructor calls, including the class instance
// expression 'new A(...)'
from ConstructorCall call
select call
