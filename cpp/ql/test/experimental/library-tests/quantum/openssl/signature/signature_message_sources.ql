import cpp
import experimental.quantum.Language

from Crypto::SignatureOperationNode n, Crypto::MessageArtifactNode m
where n.getAnInputArtifact() = m
select n, m, m.getSourceNode()
// TODO: we miss call to EVP_PKEY_sign, because getSourceNode does not find the `digest` we sign
// TODO: we miss message generated with `EVP_SignUpdate(md_ctx, message+1, message_len-1)`, because getSourceNode does not find it
