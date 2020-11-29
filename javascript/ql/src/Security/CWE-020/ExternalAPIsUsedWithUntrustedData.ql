/**
 * @name Frequency counts for external APIs that are used with untrusted data
 * @description This reports the external APIs that are used with untrusted data, along with how
 *              frequently the API is called, and how many unique sources of untrusted data flow
 *              to it.
 * @id js/count-untrusted-data-external-api
 * @kind table
 * @tags security external/cwe/cwe-20
 */

import javascript
import semmle.javascript.security.dataflow.ExternalAPIUsedWithUntrustedData::ExternalAPIUsedWithUntrustedData

from ExternalAPIUsedWithUntrustedData externalAPI
select externalAPI, count(externalAPI.getUntrustedDataNode()) as numberOfUses,
  externalAPI.getNumberOfUntrustedSources() as numberOfUntrustedSources order by
    numberOfUntrustedSources desc
