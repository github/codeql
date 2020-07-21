import RecordedCalls

from UnidentifiedRecordedCall rc, XMLCall xml_call
select "Could not uniquely identify this recorded call (either call or callee was not uniquely identified)",
  rc, rc.getXMLCall().get_filename_data(), rc.getXMLCall().get_linenum_data(), rc.getXMLCall().get_inst_index_data()
