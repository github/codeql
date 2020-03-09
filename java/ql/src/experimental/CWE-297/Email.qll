/* Definitions related to the Apache Commons Email library. */
import semmle.code.java.Type

class Email extends Class {
  Email() {
    exists(Class email |
      email.getQualifiedName() = "org.apache.commons.mail.Email" and
      this.extendsOrImplements(email)
    )
    or
    this.hasQualifiedName("org.apache.commons.mail", "Email")
  }
}

class EmailMethod extends Method {
  EmailMethod() { getDeclaringType() instanceof Email }
}

class MethodEmailIsStartTLSRequired extends EmailMethod {
  MethodEmailIsStartTLSRequired() { hasName("isStartTLSRequired") }
}

class MethodEmailSetTo extends EmailMethod {
  MethodEmailSetTo() { hasName("setTo") }
}

class MethodEmailSetCharset extends EmailMethod {
  MethodEmailSetCharset() { hasName("setCharset") }
}

class MethodEmailSetFrom extends EmailMethod {
  MethodEmailSetFrom() { hasName("setFrom") }
}

class MethodEmailSetAuthentication extends EmailMethod {
  MethodEmailSetAuthentication() { hasName("setAuthentication") }
}

class MethodEmailGetHeaders extends EmailMethod {
  MethodEmailGetHeaders() { hasName("getHeaders") }
}

class MethodEmailUpdateContentType extends EmailMethod {
  MethodEmailUpdateContentType() { hasName("updateContentType") }
}

class MethodEmailSend extends EmailMethod {
  MethodEmailSend() { hasName("send") }
}

class MethodEmailGetSubject extends EmailMethod {
  MethodEmailGetSubject() { hasName("getSubject") }
}

class MethodEmailGetCcAddresses extends EmailMethod {
  MethodEmailGetCcAddresses() { hasName("getCcAddresses") }
}

class MethodEmailGetSentDate extends EmailMethod {
  MethodEmailGetSentDate() { hasName("getSentDate") }
}

class MethodEmailSetSmtpPort extends EmailMethod {
  MethodEmailSetSmtpPort() { hasName("setSmtpPort") }
}

class MethodEmailGetToAddresses extends EmailMethod {
  MethodEmailGetToAddresses() { hasName("getToAddresses") }
}

class MethodEmailSetContent extends EmailMethod {
  MethodEmailSetContent() { hasName("setContent") }
}

class MethodEmailIsSSL extends EmailMethod {
  MethodEmailIsSSL() { hasName("isSSL") }
}

class MethodEmailGetMailSession extends EmailMethod {
  MethodEmailGetMailSession() { hasName("getMailSession") }
}

class MethodEmailSetSocketConnectionTimeout extends EmailMethod {
  MethodEmailSetSocketConnectionTimeout() { hasName("setSocketConnectionTimeout") }
}

class MethodEmailSetStartTLSRequired extends EmailMethod {
  MethodEmailSetStartTLSRequired() { hasName("setStartTLSRequired") }
}

class MethodEmailGetHostName extends EmailMethod {
  MethodEmailGetHostName() { hasName("getHostName") }
}

class MethodEmailIsSSLOnConnect extends EmailMethod {
  MethodEmailIsSSLOnConnect() { hasName("isSSLOnConnect") }
}

class MethodEmailSetHostName extends EmailMethod {
  MethodEmailSetHostName() { hasName("setHostName") }
}

class MethodEmailSetSocketTimeout extends EmailMethod {
  MethodEmailSetSocketTimeout() { hasName("setSocketTimeout") }
}

class MethodEmailSetAuthenticator extends EmailMethod {
  MethodEmailSetAuthenticator() { hasName("setAuthenticator") }
}

class MethodEmailIsTLS extends EmailMethod {
  MethodEmailIsTLS() { hasName("isTLS") }
}

class MethodEmailAddHeader extends EmailMethod {
  MethodEmailAddHeader() { hasName("addHeader") }
}

class MethodEmailSetStartTLSEnabled extends EmailMethod {
  MethodEmailSetStartTLSEnabled() { hasName("setStartTLSEnabled") }
}

class MethodEmailGetBccAddresses extends EmailMethod {
  MethodEmailGetBccAddresses() { hasName("getBccAddresses") }
}

class MethodEmailGetReplyToAddresses extends EmailMethod {
  MethodEmailGetReplyToAddresses() { hasName("getReplyToAddresses") }
}

class MethodEmailAddTo extends EmailMethod {
  MethodEmailAddTo() { hasName("addTo") }
}

class MethodEmailGetSocketTimeout extends EmailMethod {
  MethodEmailGetSocketTimeout() { hasName("getSocketTimeout") }
}

class MethodEmailSetSSLOnConnect extends EmailMethod {
  MethodEmailSetSSLOnConnect() { hasName("setSSLOnConnect") }
}

class MethodEmailSetSendPartial extends EmailMethod {
  MethodEmailSetSendPartial() { hasName("setSendPartial") }
}

class MethodEmailSetTLS extends EmailMethod {
  MethodEmailSetTLS() { hasName("setTLS") }
}

class MethodEmailSetSSLCheckServerIdentity extends EmailMethod {
  MethodEmailSetSSLCheckServerIdentity() { hasName("setSSLCheckServerIdentity") }
}

class MethodEmailSetBcc extends EmailMethod {
  MethodEmailSetBcc() { hasName("setBcc") }
}

class MethodEmailSetMailSessionFromJNDI extends EmailMethod {
  MethodEmailSetMailSessionFromJNDI() { hasName("setMailSessionFromJNDI") }
}

class MethodEmailBuildMimeMessage extends EmailMethod {
  MethodEmailBuildMimeMessage() { hasName("buildMimeMessage") }
}

class MethodEmailIsSendPartial extends EmailMethod {
  MethodEmailIsSendPartial() { hasName("isSendPartial") }
}

class MethodEmailGetFromAddress extends EmailMethod {
  MethodEmailGetFromAddress() { hasName("getFromAddress") }
}

class MethodEmailAddBcc extends EmailMethod {
  MethodEmailAddBcc() { hasName("addBcc") }
}

class MethodEmailAddCc extends EmailMethod {
  MethodEmailAddCc() { hasName("addCc") }
}

class MethodEmailSetBounceAddress extends EmailMethod {
  MethodEmailSetBounceAddress() { hasName("setBounceAddress") }
}

class MethodEmailToInternetAddressArray extends EmailMethod {
  MethodEmailToInternetAddressArray() { hasName("toInternetAddressArray") }
}

class MethodEmailSetHeaders extends EmailMethod {
  MethodEmailSetHeaders() { hasName("setHeaders") }
}

class MethodEmailGetSocketConnectionTimeout extends EmailMethod {
  MethodEmailGetSocketConnectionTimeout() { hasName("getSocketConnectionTimeout") }
}

class MethodEmailSetReplyTo extends EmailMethod {
  MethodEmailSetReplyTo() { hasName("setReplyTo") }
}

class MethodEmailSetSslSmtpPort extends EmailMethod {
  MethodEmailSetSslSmtpPort() { hasName("setSslSmtpPort") }
}

class MethodEmailIsStartTLSEnabled extends EmailMethod {
  MethodEmailIsStartTLSEnabled() { hasName("isStartTLSEnabled") }
}

class MethodEmailSetMailSession extends EmailMethod {
  MethodEmailSetMailSession() { hasName("setMailSession") }
}

class MethodEmailAddReplyTo extends EmailMethod {
  MethodEmailAddReplyTo() { hasName("addReplyTo") }
}

class MethodEmailSendMimeMessage extends EmailMethod {
  MethodEmailSendMimeMessage() { hasName("sendMimeMessage") }
}

class MethodEmailGetHeader extends EmailMethod {
  MethodEmailGetHeader() { hasName("getHeader") }
}

class MethodEmailGetBounceAddress extends EmailMethod {
  MethodEmailGetBounceAddress() { hasName("getBounceAddress") }
}

class MethodEmailGetSslSmtpPort extends EmailMethod {
  MethodEmailGetSslSmtpPort() { hasName("getSslSmtpPort") }
}

class MethodEmailGetSmtpPort extends EmailMethod {
  MethodEmailGetSmtpPort() { hasName("getSmtpPort") }
}

class MethodEmailSetCc extends EmailMethod {
  MethodEmailSetCc() { hasName("setCc") }
}

class MethodEmailSetPopBeforeSmtp extends EmailMethod {
  MethodEmailSetPopBeforeSmtp() { hasName("setPopBeforeSmtp") }
}

class MethodEmailSetSubject extends EmailMethod {
  MethodEmailSetSubject() { hasName("setSubject") }
}

class MethodEmailSetSSL extends EmailMethod {
  MethodEmailSetSSL() { hasName("setSSL") }
}

class MethodEmailIsSSLCheckServerIdentity extends EmailMethod {
  MethodEmailIsSSLCheckServerIdentity() { hasName("isSSLCheckServerIdentity") }
}

class MethodEmailSetDebug extends EmailMethod {
  MethodEmailSetDebug() { hasName("setDebug") }
}

class MethodEmailCreateMimeMessage extends EmailMethod {
  MethodEmailCreateMimeMessage() { hasName("createMimeMessage") }
}

class MethodEmailSetSentDate extends EmailMethod {
  MethodEmailSetSentDate() { hasName("setSentDate") }
}

class MethodEmailGetMimeMessage extends EmailMethod {
  MethodEmailGetMimeMessage() { hasName("getMimeMessage") }
}
