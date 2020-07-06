import RecordedCalls

from RecordedCall rc
where not rc instanceof ValidRecordedCall
select "Could not uniquely identify this recorded call (either call or callable was not uniquely identified)",
    rc.call_filename(), rc.call_linenum(), rc.call_inst_index(), "-->", rc.callable_filename(),
    rc.callable_linenum(), rc.callable_funcname()
