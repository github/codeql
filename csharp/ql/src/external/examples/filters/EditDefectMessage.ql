/**
 * @name Edit the message of a query
 * @description Change the string in the select to edit the message
 * @deprecated
 */

import csharp
import external.DefectFilter

from DefectResult res
select res, "Filtered query result: " + res.getMessage()
