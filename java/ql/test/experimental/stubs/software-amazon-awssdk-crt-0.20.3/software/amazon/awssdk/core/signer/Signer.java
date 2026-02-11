// Generated automatically from software.amazon.awssdk.core.signer.Signer for testing purposes

package software.amazon.awssdk.core.signer;

import software.amazon.awssdk.core.CredentialType;
import software.amazon.awssdk.core.interceptor.ExecutionAttributes;
import software.amazon.awssdk.http.SdkHttpFullRequest;

public interface Signer
{
    SdkHttpFullRequest sign(SdkHttpFullRequest p0, ExecutionAttributes p1);
    default CredentialType credentialType(){ return null; }
}
