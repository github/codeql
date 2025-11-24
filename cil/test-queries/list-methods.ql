/**
 * @name List all methods
 * @description Simple test query to list all methods in the database
 * @kind table
 * @id csharp-il/test-methods
 */

from @method id, string name, string signature, @type type_id
where methods(id, name, signature, type_id)
select name, signature
