/**
 * @id js/examples/filename
 * @name File with given name
 * @description Finds files called `index.js`
 * @tags file
 */

import javascript

from File f
where f.getBaseName() = "index.js"
select f
