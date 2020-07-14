import RecordedCalls

from RecordedCall rc
where not rc instanceof ValidRecordedCall
select "Could not uniquely identify this recorded call (either call or callee was not uniquely identified)",
  rc.call_filename(), rc.call_linenum(), rc.call_inst_index(), "-->", rc.callee_filename(),
  rc.callee_linenum(), rc.callee_funcname()
