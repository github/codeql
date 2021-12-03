/**
 * @id js/examples/importfrom
 * @name Imports from 'react'
 * @description Finds import statements that import from module 'react'
 * @tags module
 *       import
 *       ECMAScript 6
 *       ECMAScript 2015
 */

import javascript

from ImportDeclaration id
where id.getImportedPath().getValue() = "react"
select id
