import RecordedCalls

from RecordedCall rc
where not rc instanceof ValidRecordedCall
select "Could not uniquely identify this recorded call (either call or callee was not uniquely identified)",
  rc, rc.call_filename(), rc.call_linenum(), rc.call_inst_index()
