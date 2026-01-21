/**
 * @name Use of a weak cipher mode
 * @description Using weak cipher modes such as ECB or OFB can compromise the security of encrypted data.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id powershell/weak-cipher-mode
 * @tags security
 *       external/cwe/cwe-327
 */

import powershell
import semmle.code.powershell.ApiGraphs
import semmle.code.powershell.dataflow.TaintTracking
import semmle.code.powershell.dataflow.DataFlow

class WeakCipherMode extends API::Node {
    WeakCipherMode() {
            this = API::getTopLevelMember("system").getMember("security").getMember("cryptography").getMember("ciphermode").getMember("cbc")
    }
}

module WeakCipherModeConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { 
    exists(WeakCipherMode wcm | source = wcm.asSource())
}

  predicate isSink(DataFlow::Node sink) { any() }

}

module CommandInjectionFlow = TaintTracking::Global<WeakCipherModeConfig>;



//dataflow from WeakCipherMode to Mode property of System.Security.Cryptography.Aes object!  

from DataFlow::Node mode 
where mode = API::getTopLevelMember("system")
            .getMember("security")
            .getMember("cryptography")
            .getMember("aes")
            .getMember("mode")
            .asSink()
// select mode, "mode member of aes"

from API::Node item 
select item, "node"


// from API::Node sink
// where sink = API::getTopLevelMember("system").getMember("security").getMember("cryptography").getMember("ciphermode").getMember("cbc")
// select sink, sink.asSource()

// from InvokeEncryptModeArgument a 
// select a, "Use of weak cipher mode in encryption."
