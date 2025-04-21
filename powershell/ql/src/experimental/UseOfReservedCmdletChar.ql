/**
 * @name Reserved Characters in Function Name
 * @description Do not use reserved characters in function names
 * @kind problem
 * @problem.severity error
 * @security-severity 7.0
 * @precision high
 * @id powershell/microsoft/public/reserved-characters-in-function-name
 * @tags correctness
 *       security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

 import powershell

class ReservedCharacter extends string {
    ReservedCharacter() { 
        this = [
        "!", "@", "#", "$",
        "&", "*", "(", ")", 
        "+", "=", "{", "^", 
        "}", "[", "]", "|", 
        ";", ":", "'", "\"", 
        "<", ">", ",", "?", 
        "/", "~"]
    }
}

from Function f, ReservedCharacter r
where f.getName().matches("%"+ r + "%")
select f, "Function name contains a reserved character: " + r