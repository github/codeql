import python
import semmle.python.ApiGraphs
import experimental.cryptography.CryptoArtifact
import experimental.cryptography.CryptoAlgorithmNames
import experimental.cryptography.utils.CallCfgNodeWithTarget
private import experimental.cryptography.utils.Utils as Utils

/**
 * Provides models for the `argon2-cffi` PyPI package.
 * See https://argon2-cffi.readthedocs.io/en/stable/.
 */
private module Argon2Cffi {
    API::CallNode getAPasswordHasher() {
        result = API::moduleImport("argon2")
            .getMember("PasswordHasher")
            .getACall()
    }

    DataFlow::LocalSourceNode getAnArgonType(string fullName, string member) {
        result = API::moduleImport("argon2")
            .getMember("low_level")
            .getMember("Type")
            .getMember(member)
            .asSource()
        and (
            (fullName = "ARGON2D" and member = "D")
            or
            (fullName = "ARGON2I" and member = "I")
            or
            (fullName = "ARGON2ID" and member = "ID")
        )
    }

    class ArgonType extends DataFlow::LocalSourceNode {
        ArgonType() { this = getAnArgonType(_, _) }
        string getName() { this = getAnArgonType(result, _) }
    }

    // note: password hashers instantiated using `from_parameters` are not modelled (yet)
    class PasswordHasher extends KeyDerivationAlgorithm {
        PasswordHasher() { this = getAPasswordHasher() }

        API::Node getTypeParameter() {
            result = this.(API::CallNode).getParameter(6, "type")
        }

        override string getName() {
            if exists(this.getTypeParameter()) then exists(
                ArgonType type | type.flowsTo(this.getTypeParameter().asSink()) | result = type.getName()
            )
            else result = "ARGON2ID"
        }
    }

    abstract class PasswordHasherOperation extends KeyDerivationOperation {
        PasswordHasher instance;

        PasswordHasherOperation() { 
            this = instance.(API::CallNode).getAMethodCall(["hash", "verify"])
        }

        override PasswordHasher getAlgorithm() { result = instance }

        override DataFlow::Node getInitialisation() { result = instance }

        override predicate requiresHash() { none() }

        override predicate requiresMode() { none() }

        // although Argon is salted, the salt parameter is optional as the library generates one for you
        override predicate requiresSalt() { none() }

        override predicate requiresIteration() { none() }

        override predicate requiresLanes() { none() }

        override predicate requiresMemoryCost() { none() }

        override DataFlow::Node getSaltConfigSink() {
            result = this.getSaltConfigSink(_)
        }

        private DataFlow::Node getSaltConfigSink(API::Node apiNode) {
            result = apiNode.asSink() and 
            apiNode = this.(API::CallNode).getKeywordParameter("salt")
        }

        override DataFlow::Node getSaltConfigSrc() {
            result = this.getSaltConfigSrc(_)
        }

        private DataFlow::Node getSaltConfigSrc(API::Node apiNode) {
            exists(this.getSaltConfigSink(apiNode)) and
            result = Utils::getUltimateSrcFromApiNode(apiNode)
        }

        override DataFlow::Node getHashConfigSrc() { none() }

        override DataFlow::Node getIterationSizeSrc() {
            result = Utils::getUltimateSrcFromApiNode(instance.(API::CallNode).getParameter(0, "time_cost"))
        }

        override DataFlow::Node getMemoryCostConfigSrc() {
            result = Utils::getUltimateSrcFromApiNode(instance.(API::CallNode).getParameter(1, "memory_cost"))
        }

        override DataFlow::Node getLanesConfigSrc() {
            result = Utils::getUltimateSrcFromApiNode(instance.(API::CallNode).getParameter(2, "parallelism"))
        }

        override DataFlow::Node getDerivedKeySizeSrc() {
            result = Utils::getUltimateSrcFromApiNode(instance.(API::CallNode).getParameter(3, "hash_len"))
        }

        override DataFlow::Node getModeSrc() { none() }
    }

    class HashOperation extends PasswordHasherOperation {
        HashOperation() { 
            this = instance.(API::CallNode).getAMethodCall("hash")
        }

        override DataFlow::Node getAnInput() {
            result = this.(API::CallNode).getArg(0) or result = this.(API::CallNode).getArgByName("password")
        }
    }

    class VerifyOperation extends PasswordHasherOperation {
        VerifyOperation() { 
            this = instance.(API::CallNode).getAMethodCall("verify")
        }

        override DataFlow::Node getAnInput() {
            result = this.(API::CallNode).getArg(1) or result = this.(API::CallNode).getArgByName("password")
        }
    }
}