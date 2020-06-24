/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.commons.mail;

import java.io.UnsupportedEncodingException;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.mail.Authenticator;

/**
 * The base class for all email messages. This class sets the sender's email
 * &amp; name, receiver's email &amp; name, subject, and the sent date.
 * <p>
 * Subclasses are responsible for setting the message body.
 *
 * @since 1.0
 */
public abstract class Email {
    /**
     * Sets the userName and password if authentication is needed. If this method is
     * not used, no authentication will be performed.
     * <p>
     * This method will create a new instance of {@code DefaultAuthenticator} using
     * the supplied parameters.
     *
     * @param userName User name for the SMTP server
     * @param password password for the SMTP server
     * @see DefaultAuthenticator
     * @see #setAuthenticator
     * @since 1.0
     */
    public void setAuthentication(final String userName, final String password) {
    }

    /**
     * Sets the {@code Authenticator} to be used when authentication is requested
     * from the mail server.
     * <p>
     * This method should be used when your outgoing mail server requires
     * authentication. Your mail server must also support RFC2554.
     *
     * @param newAuthenticator the {@code Authenticator} object.
     * @see Authenticator
     * @since 1.0
     */
    public void setAuthenticator(final Authenticator newAuthenticator) {
    }

    /**
     * Set the hostname of the outgoing mail server.
     *
     * @param aHostName aHostName
     * @throws IllegalStateException if the mail session is already initialized
     * @since 1.0
     */
    public void setHostName(final String aHostName) {
    }

    /**
     * Set or disable the STARTTLS encryption. Please see EMAIL-105 for the reasons
     * of deprecation.
     *
     * @deprecated since 1.3, use setStartTLSEnabled() instead
     * @param withTLS true if STARTTLS requested, false otherwise
     * @since 1.1
     */
    @Deprecated
    public void setTLS(final boolean withTLS) {
    }

    /**
     * Set or disable the STARTTLS encryption.
     *
     * @param startTlsEnabled true if STARTTLS requested, false otherwise
     * @return An Email.
     * @throws IllegalStateException if the mail session is already initialized
     * @since 1.3
     */
    public Email setStartTLSEnabled(final boolean startTlsEnabled) {
        return null;
    }

    /**
     * Set or disable the required STARTTLS encryption.
     * <p>
     * Defaults to {@link #smtpPort}; can be overridden by using
     * {@link #setSmtpPort(int)}
     *
     * @param startTlsRequired true if STARTTLS requested, false otherwise
     * @return An Email.
     * @throws IllegalStateException if the mail session is already initialized
     * @since 1.3
     */
    public Email setStartTLSRequired(final boolean startTlsRequired) {
        return null;
    }

    /**
     * Set the non-SSL port number of the outgoing mail server.
     *
     * @param aPortNumber aPortNumber
     * @throws IllegalArgumentException if the port number is &lt; 1
     * @throws IllegalStateException    if the mail session is already initialized
     * @since 1.0
     * @see #setSslSmtpPort(String)
     */
    public void setSmtpPort(final int aPortNumber) {
    }

    /**
     * Set the FROM field of the email to use the specified address. The email
     * address will also be used as the personal name. The name will be encoded by
     * the charset of {@link #setCharset(java.lang.String) setCharset()}. If it is
     * not set, it will be encoded using the Java platform's default charset
     * (UTF-16) if it contains non-ASCII characters; otherwise, it is used as is.
     *
     * @param email A String.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address.
     * @since 1.0
     */
    public Email setFrom(final String email) throws EmailException {
        return null;
    }

    /**
     * Set the FROM field of the email to use the specified address and the
     * specified personal name. The name will be encoded by the charset of
     * {@link #setCharset(java.lang.String) setCharset()}. If it is not set, it will
     * be encoded using the Java platform's default charset (UTF-16) if it contains
     * non-ASCII characters; otherwise, it is used as is.
     *
     * @param email A String.
     * @param name  A String.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address.
     * @since 1.0
     */
    public Email setFrom(final String email, final String name) throws EmailException {
        return null;
    }

    /**
     * Set the FROM field of the email to use the specified address, personal name,
     * and charset encoding for the name.
     *
     * @param email   A String.
     * @param name    A String.
     * @param charset The charset to encode the name with.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address or charset.
     * @since 1.1
     */
    public Email setFrom(final String email, final String name, final String charset) throws EmailException {
        return null;
    }

    /**
     * Add a recipient TO to the email. The email address will also be used as the
     * personal name. The name will be encoded by the charset of
     * {@link #setCharset(java.lang.String) setCharset()}. If it is not set, it will
     * be encoded using the Java platform's default charset (UTF-16) if it contains
     * non-ASCII characters; otherwise, it is used as is.
     *
     * @param email A String.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address.
     * @since 1.0
     */
    public Email addTo(final String email) throws EmailException {
        return null;
    }

    /**
     * Add a list of TO recipients to the email. The email addresses will also be
     * used as the personal names. The names will be encoded by the charset of
     * {@link #setCharset(java.lang.String) setCharset()}. If it is not set, it will
     * be encoded using the Java platform's default charset (UTF-16) if it contains
     * non-ASCII characters; otherwise, it is used as is.
     *
     * @param emails A String array.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address.
     * @since 1.3
     */
    public Email addTo(final String... emails) throws EmailException {
        return null;
    }

    /**
     * Add a recipient TO to the email using the specified address and the specified
     * personal name. The name will be encoded by the charset of
     * {@link #setCharset(java.lang.String) setCharset()}. If it is not set, it will
     * be encoded using the Java platform's default charset (UTF-16) if it contains
     * non-ASCII characters; otherwise, it is used as is.
     *
     * @param email A String.
     * @param name  A String.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address.
     * @since 1.0
     */
    public Email addTo(final String email, final String name) throws EmailException {
        return null;
    }

    /**
     * Add a recipient TO to the email using the specified address, personal name,
     * and charset encoding for the name.
     *
     * @param email   A String.
     * @param name    A String.
     * @param charset The charset to encode the name with.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address or charset.
     * @since 1.1
     */
    public Email addTo(final String email, final String name, final String charset) throws EmailException {
        return null;
    }

    /**
     * Add a recipient CC to the email. The email address will also be used as the
     * personal name. The name will be encoded by the charset of
     * {@link #setCharset(java.lang.String) setCharset()}. If it is not set, it will
     * be encoded using the Java platform's default charset (UTF-16) if it contains
     * non-ASCII characters; otherwise, it is used as is.
     *
     * @param email A String.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address.
     * @since 1.0
     */
    public Email addCc(final String email) throws EmailException {
        return null;
    }

    /**
     * Add an array of CC recipients to the email. The email addresses will also be
     * used as the personal name. The names will be encoded by the charset of
     * {@link #setCharset(java.lang.String) setCharset()}. If it is not set, it will
     * be encoded using the Java platform's default charset (UTF-16) if it contains
     * non-ASCII characters; otherwise, it is used as is.
     *
     * @param emails A String array.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address.
     * @since 1.3
     */
    public Email addCc(final String... emails) throws EmailException {
        return null;
    }

    /**
     * Add a recipient CC to the email using the specified address and the specified
     * personal name. The name will be encoded by the charset of
     * {@link #setCharset(java.lang.String) setCharset()}. If it is not set, it will
     * be encoded using the Java platform's default charset (UTF-16) if it contains
     * non-ASCII characters; otherwise, it is used as is.
     *
     * @param email A String.
     * @param name  A String.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address.
     * @since 1.0
     */
    public Email addCc(final String email, final String name) throws EmailException {
        return null;
    }

    /**
     * Add a recipient CC to the email using the specified address, personal name,
     * and charset encoding for the name.
     *
     * @param email   A String.
     * @param name    A String.
     * @param charset The charset to encode the name with.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address or charset.
     * @since 1.1
     */
    public Email addCc(final String email, final String name, final String charset) throws EmailException {
        return null;
    }

    /**
     * Add a blind BCC recipient to the email. The email address will also be used
     * as the personal name. The name will be encoded by the charset of
     * {@link #setCharset(java.lang.String) setCharset()}. If it is not set, it will
     * be encoded using the Java platform's default charset (UTF-16) if it contains
     * non-ASCII characters; otherwise, it is used as is.
     *
     * @param email A String.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address
     * @since 1.0
     */
    public Email addBcc(final String email) throws EmailException {
        return null;
    }

    /**
     * Add an array of blind BCC recipients to the email. The email addresses will
     * also be used as the personal name. The names will be encoded by the charset
     * of {@link #setCharset(java.lang.String) setCharset()}. If it is not set, it
     * will be encoded using the Java platform's default charset (UTF-16) if it
     * contains non-ASCII characters; otherwise, it is used as is.
     *
     * @param emails A String array.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address
     * @since 1.3
     */
    public Email addBcc(final String... emails) throws EmailException {
        return null;
    }

    /**
     * Add a blind BCC recipient to the email using the specified address and the
     * specified personal name. The name will be encoded by the charset of
     * {@link #setCharset(java.lang.String) setCharset()}. If it is not set, it will
     * be encoded using the Java platform's default charset (UTF-16) if it contains
     * non-ASCII characters; otherwise, it is used as is.
     *
     * @param email A String.
     * @param name  A String.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address
     * @since 1.0
     */
    public Email addBcc(final String email, final String name) throws EmailException {
        return null;
    }

    /**
     * Add a blind BCC recipient to the email using the specified address, personal
     * name, and charset encoding for the name.
     *
     * @param email   A String.
     * @param name    A String.
     * @param charset The charset to encode the name with.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address
     * @since 1.1
     */
    public Email addBcc(final String email, final String name, final String charset) throws EmailException {
        return null;
    }

    /**
     * Add a reply to address to the email. The email address will also be used as
     * the personal name. The name will be encoded by the charset of
     * {@link #setCharset(java.lang.String) setCharset()}. If it is not set, it will
     * be encoded using the Java platform's default charset (UTF-16) if it contains
     * non-ASCII characters; otherwise, it is used as is.
     *
     * @param email A String.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address
     * @since 1.0
     */
    public Email addReplyTo(final String email) throws EmailException {
        return null;
    }

    /**
     * Add a reply to address to the email using the specified address and the
     * specified personal name. The name will be encoded by the charset of
     * {@link #setCharset(java.lang.String) setCharset()}. If it is not set, it will
     * be encoded using the Java platform's default charset (UTF-16) if it contains
     * non-ASCII characters; otherwise, it is used as is.
     *
     * @param email A String.
     * @param name  A String.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address
     * @since 1.0
     */
    public Email addReplyTo(final String email, final String name) throws EmailException {
        return null;
    }

    /**
     * Add a reply to address to the email using the specified address, personal
     * name, and charset encoding for the name.
     *
     * @param email   A String.
     * @param name    A String.
     * @param charset The charset to encode the name with.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address or charset.
     * @since 1.1
     */
    public Email addReplyTo(final String email, final String name, final String charset) throws EmailException {
        return null;
    }

    /**
     * Used to specify the mail headers. Example:
     *
     * X-Mailer: Sendmail, X-Priority: 1( highest ) or 2( high ) 3( normal ) 4( low
     * ) and 5( lowest ) Disposition-Notification-To: user@domain.net
     *
     * @param map A Map.
     * @throws IllegalArgumentException if either of the provided header / value is
     *                                  null or empty
     * @since 1.0
     */
    public void setHeaders(final Map<String, String> map) {
    }

    /**
     * Adds a header ( name, value ) to the headers Map.
     *
     * @param name  A String with the name.
     * @param value A String with the value.
     * @since 1.0
     * @throws IllegalArgumentException if either {@code name} or {@code value} is
     *                                  null or empty
     */
    public void addHeader(final String name, final String value) {
    }

    /**
     * Gets the specified header.
     *
     * @param header A string with the header.
     * @return The value of the header, or null if no such header.
     * @since 1.5
     */
    public String getHeader(final String header) {
        return null;
    }

    /**
     * Gets all headers on an Email.
     *
     * @return a Map of all headers.
     * @since 1.5
     */
    public Map<String, String> getHeaders() {
        return null;
    }

    /**
     * Sets the email subject. Replaces end-of-line characters with spaces.
     *
     * @param aSubject A String.
     * @return An Email.
     * @since 1.0
     */
    public Email setSubject(final String aSubject) {
        return null;
    }

    /**
     * Gets the "bounce address" of this email.
     *
     * @return the bounce address as string
     * @since 1.4
     */
    public String getBounceAddress() {
        return null;
    }

    /**
     * Set the "bounce address" - the address to which undeliverable messages will
     * be returned. If this value is never set, then the message will be sent to the
     * address specified with the System property "mail.smtp.from", or if that value
     * is not set, then to the "from" address.
     *
     * @param email A String.
     * @return An Email.
     * @throws IllegalStateException if the mail session is already initialized
     * @since 1.0
     */
    public Email setBounceAddress(final String email) {
        return null;
    }

    /**
     * Define the content of the mail. It should be overridden by the subclasses.
     *
     * @param msg A String.
     * @return An Email.
     * @throws EmailException generic exception.
     * @since 1.0
     */
    public abstract Email setMsg(String msg) throws EmailException;

    /**
     * Does the work of actually building the MimeMessage. Please note that a user
     * rarely calls this method directly and only if he/she is interested in the
     * sending the underlying MimeMessage without commons-email.
     *
     * @throws IllegalStateException if the MimeMessage was already built
     * @throws EmailException        if there was an error.
     * @since 1.0
     */
    public void buildMimeMessage() throws EmailException {
    }

    /**
     * Sends the previously created MimeMessage to the SMTP server.
     *
     * @return the message id of the underlying MimeMessage
     * @throws IllegalArgumentException if the MimeMessage has not been created
     * @throws EmailException           the sending failed
     */
    public String sendMimeMessage() throws EmailException {
        return null;
    }

    /**
     * Sends the email. Internally we build a MimeMessage which is afterwards sent
     * to the SMTP server.
     *
     * @return the message id of the underlying MimeMessage
     * @throws IllegalStateException if the MimeMessage was already built, ie
     *                               {@link #buildMimeMessage()} was already called
     * @throws EmailException        the sending failed
     */
    public String send() throws EmailException {
        return null;
    }

    /**
     * Sets the sent date for the email. The sent date will default to the current
     * date if not explicitly set.
     *
     * @param date Date to use as the sent date on the email
     * @since 1.0
     */
    public void setSentDate(final Date date) {
    }

    /**
     * Gets the sent date for the email.
     *
     * @return date to be used as the sent date for the email
     * @since 1.0
     */
    public Date getSentDate() {
        return null;
    }

    /**
     * Gets the subject of the email.
     *
     * @return email subject
     */
    public String getSubject() {
        return null;
    }

    /**
     * Gets the host name of the SMTP server,
     *
     * @return host name
     */
    public String getHostName() {
        return null;
    }

    /**
     * Gets the listening port of the SMTP server.
     *
     * @return smtp port
     */
    public String getSmtpPort() {
        return null;
    }

    /**
     * Gets whether the client is configured to require STARTTLS.
     *
     * @return true if using STARTTLS for authentication, false otherwise
     * @since 1.3
     */
    public boolean isStartTLSRequired() {
        return false;
    }

    /**
     * Gets whether the client is configured to try to enable STARTTLS.
     *
     * @return true if using STARTTLS for authentication, false otherwise
     * @since 1.3
     */
    public boolean isStartTLSEnabled() {
        return false;
    }

    /**
     * Gets whether the client is configured to try to enable STARTTLS. See
     * EMAIL-105 for reason of deprecation.
     *
     * @deprecated since 1.3, use isStartTLSEnabled() instead
     * @return true if using STARTTLS for authentication, false otherwise
     * @since 1.1
     */
    @Deprecated
    public boolean isTLS() {
        return false;
    }

    /**
     * Set details regarding "pop3 before smtp" authentication.
     *
     * @param newPopBeforeSmtp Whether or not to log into pop3 server before sending
     *                         mail.
     * @param newPopHost       The pop3 host to use.
     * @param newPopUsername   The pop3 username.
     * @param newPopPassword   The pop3 password.
     * @since 1.0
     */
    public void setPopBeforeSmtp(final boolean newPopBeforeSmtp, final String newPopHost, final String newPopUsername,
            final String newPopPassword) {
    }

    /**
     * Returns whether SSL/TLS encryption for the transport is currently enabled
     * (SMTPS/POPS). See EMAIL-105 for reason of deprecation.
     *
     * @deprecated since 1.3, use isSSLOnConnect() instead
     * @return true if SSL enabled for the transport
     */
    @Deprecated
    public boolean isSSL() {
        return false;
    }

    /**
     * Returns whether SSL/TLS encryption for the transport is currently enabled
     * (SMTPS/POPS).
     *
     * @return true if SSL enabled for the transport
     * @since 1.3
     */
    public boolean isSSLOnConnect() {
        return false;
    }

    /**
     * Sets whether SSL/TLS encryption should be enabled for the SMTP transport upon
     * connection (SMTPS/POPS). See EMAIL-105 for reason of deprecation.
     *
     * @deprecated since 1.3, use setSSLOnConnect() instead
     * @param ssl whether to enable the SSL transport
     */
    @Deprecated
    public void setSSL(final boolean ssl) {
    }

    /**
     * Sets whether SSL/TLS encryption should be enabled for the SMTP transport upon
     * connection (SMTPS/POPS). Takes precedence over
     * {@link #setStartTLSRequired(boolean)}
     * <p>
     * Defaults to {@link #sslSmtpPort}; can be overridden by using
     * {@link #setSslSmtpPort(String)}
     *
     * @param ssl whether to enable the SSL transport
     * @return An Email.
     * @throws IllegalStateException if the mail session is already initialized
     * @since 1.3
     */
    public Email setSSLOnConnect(final boolean ssl) {
        return null;
    }

    /**
     * Is the server identity checked as specified by RFC 2595
     *
     * @return true if the server identity is checked
     * @since 1.3
     */
    public boolean isSSLCheckServerIdentity() {
        return false;
    }

    /**
     * Sets whether the server identity is checked as specified by RFC 2595
     *
     * @param sslCheckServerIdentity whether to enable server identity check
     * @return An Email.
     * @throws IllegalStateException if the mail session is already initialized
     * @since 1.3
     */
    public Email setSSLCheckServerIdentity(final boolean sslCheckServerIdentity) {
        return null;
    }

    /**
     * Returns the current SSL port used by the SMTP transport.
     *
     * @return the current SSL port used by the SMTP transport
     */
    public String getSslSmtpPort() {
        return null;
    }

    /**
     * Sets the SSL port to use for the SMTP transport. Defaults to the standard
     * port, 465.
     *
     * @param sslSmtpPort the SSL port to use for the SMTP transport
     * @throws IllegalStateException if the mail session is already initialized
     * @see #setSmtpPort(int)
     */
    public void setSslSmtpPort(final String sslSmtpPort) {
    }

    /**
     * If partial sending of email enabled.
     *
     * @return true if sending partial email is enabled
     * @since 1.3.2
     */
    public boolean isSendPartial() {
        return false;
    }

    /**
     * Sets whether the email is partially send in case of invalid addresses.
     * <p>
     * In case the mail server rejects an address as invalid, the call to
     * {@link #send()} may throw a {@link javax.mail.SendFailedException}, even if
     * partial send mode is enabled (emails to valid addresses will be transmitted).
     * In case the email server does not reject invalid addresses immediately, but
     * return a bounce message, no exception will be thrown by the {@link #send()}
     * method.
     *
     * @param sendPartial whether to enable partial send mode
     * @return An Email.
     * @throws IllegalStateException if the mail session is already initialized
     * @since 1.3.2
     */
    public Email setSendPartial(final boolean sendPartial) {
        return null;
    }

    /**
     * Get the socket connection timeout value in milliseconds.
     *
     * @return the timeout in milliseconds.
     * @since 1.2
     */
    public int getSocketConnectionTimeout() {
        return -1;
    }

    /**
     * Set the socket connection timeout value in milliseconds. Default is a 60
     * second timeout.
     *
     * @param socketConnectionTimeout the connection timeout
     * @throws IllegalStateException if the mail session is already initialized
     * @since 1.2
     */
    public void setSocketConnectionTimeout(final int socketConnectionTimeout) {
    }

    /**
     * Get the socket I/O timeout value in milliseconds.
     *
     * @return the socket I/O timeout
     * @since 1.2
     */
    public int getSocketTimeout() {
        return -1;
    }

    /**
     * Set the socket I/O timeout value in milliseconds. Default is 60 second
     * timeout.
     *
     * @param socketTimeout the socket I/O timeout
     * @throws IllegalStateException if the mail session is already initialized
     * @since 1.2
     */
    public void setSocketTimeout(final int socketTimeout) {
    }
}
