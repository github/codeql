/**
 * @name Hardcoded Computer Name
 * @description Using externally controlled strings in a command line may allow a malicious
 *              user to change the meaning of the command.
 * @kind problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id powershell/microsoft/public/command-injection
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