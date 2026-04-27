/**
 * @name Use of deprecated domain
 * @description Referencing deprecated domains that are not owned by Microsoft can lead to security risks
 * @kind problem
 * @id powershell/domain-squatting-static
 * @problem.severity error
 * @precision high
 * @tags security
 */

import powershell

string obsoleteDomain(){
    result = [
        "%.outlook.us%",
        "%.office.us%", 
        "%goo.gl%",
        "%ajax.aspnetcdn.com%",
        "%ajax.microsoft.com%"
    ]
}

from StringLiteral s, string domain 
where 
domain = obsoleteDomain() and
s.getValue().matches(domain)
select s, "use of obsolete domain " + domain