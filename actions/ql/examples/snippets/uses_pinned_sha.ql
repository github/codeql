/**
 * @name Uses step with pinned SHA
 * @description Finds 'uses' steps where the version is a pinned SHA.
 * @id actions/examples/uses-pinned-sha
 * @tags example
 */

import actions

from UsesStep uses
where uses.getVersion().regexpMatch("^[A-Fa-f0-9]{40}$")
select uses, "This 'uses' step has a pinned SHA version."
