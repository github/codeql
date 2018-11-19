/**
 * @name (Import additional libraries)
 * @description This query produces no results but imports some libraries we
 *              would like to make available in the LGTM query console even
 *              if they are not used by any queries.
 * @kind file-classifier
 * @id py/lgtm/import-additional-libraries
 */

private import external.CodeDuplication
private import external.Thrift
private import external.VCS

from File f, string tag
where none()
select f, tag
