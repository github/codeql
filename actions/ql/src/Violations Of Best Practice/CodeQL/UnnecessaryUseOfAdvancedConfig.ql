/**
 * @name Workflow Should Use Default Setup
 * @description Workflows should use CodeQL Action with default setup instead of advanced configuration if there are no customizations
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id actions/unnecessary-use-of-advanced-config
 * @tags actions
 *       maintainability
 */

import codeql.actions.Violations_Of_Best_Practices.DefaultableCodeQLInitiatlizeActionQuery

from DefaultableCodeQLInitiatlizeActionQuery action
select action, "CodeQL Action could use default setup instead of advanced configuration."
