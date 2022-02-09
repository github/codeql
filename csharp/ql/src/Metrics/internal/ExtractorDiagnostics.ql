/**
 * @name Extractor diagnostics
 * @description This query is for internal use only and may change without notice.
 * @kind table
 * @id csharp/extractor-diagnostics
 */

import csharp

bindingset[i]
private float getCompilationTimeSum(int i) {
  result = sum(float f | compilation_time(_, _, i, f) | f)
}

select getCompilationTimeSum(0) as sum_frontend_cpu_seconds,
  getCompilationTimeSum(1) as sum_frontend_elapsed_seconds,
  getCompilationTimeSum(4) as sum_frontend_user_seconds,
  getCompilationTimeSum(2) as sum_extractor_cpu_seconds,
  getCompilationTimeSum(3) as sum_extractor_elapsed_seconds,
  getCompilationTimeSum(5) as sum_extractor_user_seconds,
  sum(float f | compilation_finished(_, f, _) | f) as sum_total_cpu_seconds,
  sum(float f | compilation_finished(_, _, f) | f) as sum_total_elapsed_seconds,
  getCompilationTimeSum(6) as sum_peak_working_set_mb,
  max(float f | compilation_time(_, _, 6, f) | f) as max_peak_working_set_mb
