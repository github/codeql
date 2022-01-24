/**
 * @name Sum of frontend and extractor time
 * @description The sum of elapsed frontend time, and the sum of elapsed extractor time.
 *              This query is for internal use only and may change without notice.
 * @kind table
 * @id cpp/frontend-and-extractor-time
 */

import cpp

select sum(Compilation c, float seconds | compilation_time(c, _, 2, seconds) | seconds) as sum_frontend_elapsed_seconds,
  sum(Compilation c, float seconds | compilation_time(c, _, 4, seconds) | seconds) as sum_extractor_elapsed_seconds
