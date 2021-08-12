/**
 * @name Name: Contextual language check.
 * @description Description: Find out the logs that not properly use contextual language.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cpp/contextual-lang
 * @tags testability
 *       readability
 *       maintainability
 */

import cpp
import semmle.code.cpp.commons.Printf
import semmle.code.cpp.models.interfaces.FormattingFunction

// Example:
// There are "Interface Ethernet1/1 is DOWN"-like logs. 
// The expected format is "Interface=Ethernet1/1 State=DOWN"

// Examples in xr:
// 1. 
// https://gh-xr.scm.engit.cisco.com/xr/iosxr/blob/main/infra/autonomic-networking/common/src/an_event_mgr.c#L270 
//     DEBUG_AN_LOG(AN_LOG_CD_EVENT, AN_DEBUG_INFO, NULL,
// "\n%sInterface %s is UP", an_cd_event, an_if_info->if_name); <------------------- 

// 2. 
// https://gh-xr.scm.engit.cisco.com/xr/iosxr/blob/main/ip/bfd/src/bfd_api_server.c#L11078
// BFD_DEBUG_TRACE("Filtering scn for session %s" 
// " Session state is Unknown, SCN state is DOWN"  <------------------- 
// " and session is not bundle member",
// bfd_session_key_str(&session->session_key));

from FunctionCall fc, int i
where
    fc.getArgument(i).toString().regexpMatch(".*Interface [a-zA-Z0-9/%]+ is (DOWN|UP)")
    // fc.getTarget().hasName("DEBUG_AN_LOG")
    // format.regexpMatch(".*Interface [a-zA-Z0-9/%]+ is (DOWN|UP)")
select fc, "test "
