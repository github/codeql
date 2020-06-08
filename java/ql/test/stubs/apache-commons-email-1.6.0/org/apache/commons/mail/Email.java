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
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Store;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimeUtility;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

import org.apache.commons.mail.util.IDNEmailAddressConverter;

/**
 * The base class for all email messages.  This class sets the
 * sender's email &amp; name, receiver's email &amp; name, subject, and the
 * sent date.
 * <p>
 * Subclasses are responsible for setting the message body.
 *
 * @since 1.0
 */
public abstract class Email
{
    /** @deprecated since 1.3, use {@link EmailConstants#SENDER_EMAIL} instead */
    @Deprecated
    public static final String SENDER_EMAIL = EmailConstants.SENDER_EMAIL;

    /** @deprecated since 1.3, use {@link EmailConstants#SENDER_NAME} instead */
    @Deprecated
    public static final String SENDER_NAME = EmailConstants.SENDER_NAME;

    /** @deprecated since 1.3, use {@link EmailConstants#RECEIVER_EMAIL} instead */
    @Deprecated
    public static final String RECEIVER_EMAIL = EmailConstants.RECEIVER_EMAIL;

    /** @deprecated since 1.3, use {@link EmailConstants#RECEIVER_NAME} instead */
    @Deprecated
    public static final String RECEIVER_NAME = EmailConstants.RECEIVER_NAME;

    /** @deprecated since 1.3, use {@link EmailConstants#EMAIL_SUBJECT} instead */
    @Deprecated
    public static final String EMAIL_SUBJECT = EmailConstants.EMAIL_SUBJECT;

    /** @deprecated since 1.3, use {@link EmailConstants#EMAIL_BODY} instead */
    @Deprecated
    public static final String EMAIL_BODY = EmailConstants.EMAIL_BODY;

    /** @deprecated since 1.3, use {@link EmailConstants#CONTENT_TYPE} instead */
    @Deprecated
    public static final String CONTENT_TYPE = EmailConstants.CONTENT_TYPE;

    /** @deprecated since 1.3, use {@link EmailConstants#ATTACHMENTS} instead */
    @Deprecated
    public static final String ATTACHMENTS = EmailConstants.ATTACHMENTS;

    /** @deprecated since 1.3, use {@link EmailConstants#FILE_SERVER} instead */
    @Deprecated
    public static final String FILE_SERVER = EmailConstants.FILE_SERVER;

    /** @deprecated since 1.3, use {@link EmailConstants#KOI8_R} instead */
    @Deprecated
    public static final String KOI8_R = EmailConstants.KOI8_R;

    /** @deprecated since 1.3, use {@link EmailConstants#ISO_8859_1} instead */
    @Deprecated
    public static final String ISO_8859_1 = EmailConstants.ISO_8859_1;

    /** @deprecated since 1.3, use {@link EmailConstants#US_ASCII} instead */
    @Deprecated
    public static final String US_ASCII = EmailConstants.US_ASCII;

    /** @deprecated since 1.3, use {@link EmailConstants#MAIL_DEBUG} instead */
    @Deprecated
    public static final String MAIL_DEBUG = EmailConstants.MAIL_DEBUG;

    /** @deprecated since 1.3, use {@link EmailConstants#MAIL_HOST} instead */
    @Deprecated
    public static final String MAIL_HOST = EmailConstants.MAIL_HOST;

    /** @deprecated since 1.3, use {@link EmailConstants#MAIL_PORT} instead */
    @Deprecated
    public static final String MAIL_PORT = EmailConstants.MAIL_PORT;

    /** @deprecated since 1.3, use {@link EmailConstants#MAIL_SMTP_FROM} instead */
    @Deprecated
    public static final String MAIL_SMTP_FROM = EmailConstants.MAIL_SMTP_FROM;

    /** @deprecated since 1.3, use {@link EmailConstants#MAIL_SMTP_AUTH} instead */
    @Deprecated
    public static final String MAIL_SMTP_AUTH = EmailConstants.MAIL_SMTP_AUTH;

    /** @deprecated since 1.3, use {@link EmailConstants#MAIL_SMTP_USER} instead */
    @Deprecated
    public static final String MAIL_SMTP_USER = EmailConstants.MAIL_SMTP_USER;

    /** @deprecated since 1.3, use {@link EmailConstants#MAIL_SMTP_PASSWORD} instead */
    @Deprecated
    public static final String MAIL_SMTP_PASSWORD = EmailConstants.MAIL_SMTP_PASSWORD;

    /** @deprecated since 1.3, use {@link EmailConstants#MAIL_TRANSPORT_PROTOCOL} instead */
    @Deprecated
    public static final String MAIL_TRANSPORT_PROTOCOL = EmailConstants.MAIL_TRANSPORT_PROTOCOL;

    /** @deprecated since 1.3, use {@link EmailConstants#SMTP} instead */
    @Deprecated
    public static final String SMTP = EmailConstants.SMTP;

    /** @deprecated since 1.3, use {@link EmailConstants#TEXT_HTML} instead */
    @Deprecated
    public static final String TEXT_HTML = EmailConstants.TEXT_HTML;

    /** @deprecated since 1.3, use {@link EmailConstants#TEXT_PLAIN} instead */
    @Deprecated
    public static final String TEXT_PLAIN = EmailConstants.TEXT_PLAIN;

    /** @deprecated since 1.3, use {@link EmailConstants#MAIL_TRANSPORT_TLS} instead */
    @Deprecated
    public static final String MAIL_TRANSPORT_TLS = EmailConstants.MAIL_TRANSPORT_TLS;

    /** @deprecated since 1.3, use {@link EmailConstants#MAIL_SMTP_SOCKET_FACTORY_FALLBACK} instead */
    @Deprecated
    public static final String MAIL_SMTP_SOCKET_FACTORY_FALLBACK = EmailConstants.MAIL_SMTP_SOCKET_FACTORY_FALLBACK;

    /** @deprecated since 1.3, use {@link EmailConstants#MAIL_SMTP_SOCKET_FACTORY_CLASS} instead */
    @Deprecated
    public static final String MAIL_SMTP_SOCKET_FACTORY_CLASS = EmailConstants.MAIL_SMTP_SOCKET_FACTORY_CLASS;

    /** @deprecated since 1.3, use {@link EmailConstants#MAIL_SMTP_SOCKET_FACTORY_PORT} instead */
    @Deprecated
    public static final String MAIL_SMTP_SOCKET_FACTORY_PORT = EmailConstants.MAIL_SMTP_SOCKET_FACTORY_PORT;

    /** @deprecated since 1.3, use {@link EmailConstants#MAIL_SMTP_CONNECTIONTIMEOUT} instead */
    @Deprecated
    public static final String MAIL_SMTP_CONNECTIONTIMEOUT = EmailConstants.MAIL_SMTP_CONNECTIONTIMEOUT;

    /** @deprecated since 1.3, use {@link EmailConstants#MAIL_SMTP_TIMEOUT} instead */
    @Deprecated
    public static final String MAIL_SMTP_TIMEOUT = EmailConstants.MAIL_SMTP_TIMEOUT;

    /** The email message to send. */
    protected MimeMessage message;

    /** The charset to use for this message. */
    protected String charset;

    /** The Address of the sending party, mandatory. */
    protected InternetAddress fromAddress;

    /** The Subject. */
    protected String subject;

    /** An attachment. */
    protected MimeMultipart emailBody;

    /** The content. */
    protected Object content;

    /** The content type. */
    protected String contentType;

    /** Set session debugging on or off. */
    protected boolean debug;

    /** Sent date. */
    protected Date sentDate;

    /**
     * Instance of an {@code Authenticator} object that will be used
     * when authentication is requested from the mail server.
     */
    protected Authenticator authenticator;

    /**
     * The hostname of the mail server with which to connect. If null will try
     * to get property from system.properties. If still null, quit.
     */
    protected String hostName;

    /**
     * The port number of the mail server to connect to.
     * Defaults to the standard port ( 25 ).
     */
    protected String smtpPort = "25";

    /**
     * The port number of the SSL enabled SMTP server;
     * defaults to the standard port, 465.
     */
    protected String sslSmtpPort = "465";

    /** List of "to" email addresses. */
    protected List<InternetAddress> toList = new ArrayList<InternetAddress>();

    /** List of "cc" email addresses. */
    protected List<InternetAddress> ccList = new ArrayList<InternetAddress>();

    /** List of "bcc" email addresses. */
    protected List<InternetAddress> bccList = new ArrayList<InternetAddress>();

    /** List of "replyTo" email addresses. */
    protected List<InternetAddress> replyList = new ArrayList<InternetAddress>();

    /**
     * Address to which undeliverable mail should be sent.
     * Because this is handled by JavaMail as a String property
     * in the mail session, this property is of type {@code String}
     * rather than {@code InternetAddress}.
     */
    protected String bounceAddress;

    /**
     * Used to specify the mail headers.  Example:
     *
     * X-Mailer: Sendmail, X-Priority: 1( highest )
     * or  2( high ) 3( normal ) 4( low ) and 5( lowest )
     * Disposition-Notification-To: user@domain.net
     */
    protected Map<String, String> headers = new HashMap<String, String>();

    /**
     * Used to determine whether to use pop3 before smtp, and if so the settings.
     */
    protected boolean popBeforeSmtp;

    /** the host name of the pop3 server. */
    protected String popHost;

    /** the user name to log into the pop3 server. */
    protected String popUsername;

    /** the password to log into the pop3 server. */
    protected String popPassword;

    /**
     * Does server require TLS encryption for authentication?
     * @deprecated  since 1.3, use setStartTLSEnabled() instead
     */
    @Deprecated
    protected boolean tls;

    /**
     * Does the current transport use SSL/TLS encryption upon connection?
     * @deprecated since 1.3, use setSSLOnConnect() instead
     */
    @Deprecated
    protected boolean ssl;

    /** socket I/O timeout value in milliseconds. */
    protected int socketTimeout = EmailConstants.SOCKET_TIMEOUT_MS;

    /** socket connection timeout value in milliseconds. */
    protected int socketConnectionTimeout = EmailConstants.SOCKET_TIMEOUT_MS;

    /**
     * If true, enables the use of the STARTTLS command (if supported by
     * the server) to switch the connection to a TLS-protected connection
     * before issuing any login commands. Note that an appropriate trust
     * store must configured so that the client will trust the server's
     * certificate.
     * Defaults to false.
     */
    private boolean startTlsEnabled;

    /**
     * If true, requires the use of the STARTTLS command. If the server doesn't
     * support the STARTTLS command, or the command fails, the connect method
     * will fail.
     * Defaults to false.
     */
    private boolean startTlsRequired;

    /** does the current transport use SSL/TLS encryption upon connection? */
    private boolean sslOnConnect;

    /**
     * If set to true, check the server identity as specified by RFC 2595. These
     * additional checks based on the content of the server's certificate are
     * intended to prevent man-in-the-middle attacks.
     * Defaults to false.
     */
    private boolean sslCheckServerIdentity;

    /**
     * If set to true, and a message has some valid and some invalid addresses, send the message anyway,
     * reporting the partial failure with a SendFailedException.
     * If set to false (the default), the message is not sent to any of the recipients
     * if there is an invalid recipient address.
     * Defaults to false.
     */
    private boolean sendPartial;

    /** The Session to mail with. */
    private Session session;

    /**
     * Setting to true will enable the display of debug information.
     *
     * @param d A boolean.
     * @since 1.0
     */
    public void setDebug(final boolean d)
    {
        this.debug = d;
    }

    /**
     * Sets the userName and password if authentication is needed.  If this
     * method is not used, no authentication will be performed.
     * <p>
     * This method will create a new instance of
     * {@code DefaultAuthenticator} using the supplied parameters.
     *
     * @param userName User name for the SMTP server
     * @param password password for the SMTP server
     * @see DefaultAuthenticator
     * @see #setAuthenticator
     * @since 1.0
     */
    public void setAuthentication(final String userName, final String password)
    {
        this.setAuthenticator(new DefaultAuthenticator(userName, password));
    }

    /**
     * Sets the {@code Authenticator} to be used when authentication
     * is requested from the mail server.
     * <p>
     * This method should be used when your outgoing mail server requires
     * authentication.  Your mail server must also support RFC2554.
     *
     * @param newAuthenticator the {@code Authenticator} object.
     * @see Authenticator
     * @since 1.0
     */
    public void setAuthenticator(final Authenticator newAuthenticator)
    {
        this.authenticator = newAuthenticator;
    }

    /**
     * Set the charset of the message. Please note that you should set the charset before
     * adding the message content.
     *
     * @param newCharset A String.
     * @throws java.nio.charset.IllegalCharsetNameException if the charset name is invalid
     * @throws java.nio.charset.UnsupportedCharsetException if no support for the named charset
     * exists in the current JVM
     * @since 1.0
     */
    public void setCharset(final String newCharset)
    {
        final Charset set = Charset.forName(newCharset);
        this.charset = set.name();
    }

    /**
     * Set the emailBody to a MimeMultiPart
     *
     * @param aMimeMultipart aMimeMultipart
     * @since 1.0
     */
    public void setContent(final MimeMultipart aMimeMultipart)
    {
        this.emailBody = aMimeMultipart;
    }

    /**
     * Set the content and contentType.
     *
     * @param   aObject aObject
     * @param   aContentType aContentType
     * @since 1.0
     */
    public void setContent(final Object aObject, final String aContentType)
    {
        this.content = aObject;
        this.updateContentType(aContentType);
    }

    /**
     * Update the contentType.
     *
     * @param   aContentType aContentType
     * @since 1.2
     */
    public void updateContentType(final String aContentType)
    {
        if (EmailUtils.isEmpty(aContentType))
        {
            this.contentType = null;
        }
        else
        {
            // set the content type
            this.contentType = aContentType;

            // set the charset if the input was properly formed
            final String strMarker = "; charset=";
            int charsetPos = aContentType.toLowerCase().indexOf(strMarker);

            if (charsetPos != -1)
            {
                // find the next space (after the marker)
                charsetPos += strMarker.length();
                final int intCharsetEnd =
                    aContentType.toLowerCase().indexOf(" ", charsetPos);

                if (intCharsetEnd != -1)
                {
                    this.charset =
                        aContentType.substring(charsetPos, intCharsetEnd);
                }
                else
                {
                    this.charset = aContentType.substring(charsetPos);
                }
            }
            else
            {
                // use the default charset, if one exists, for messages
                // whose content-type is some form of text.
                if (this.contentType.startsWith("text/") && EmailUtils.isNotEmpty(this.charset))
                {
                    final StringBuffer contentTypeBuf = new StringBuffer(this.contentType);
                    contentTypeBuf.append(strMarker);
                    contentTypeBuf.append(this.charset);
                    this.contentType = contentTypeBuf.toString();
                }
            }
        }
    }

    /**
     * Set the hostname of the outgoing mail server.
     *
     * @param   aHostName aHostName
     * @throws IllegalStateException if the mail session is already initialized
     * @since 1.0
     */
    public void setHostName(final String aHostName)
    {
        checkSessionAlreadyInitialized();
        this.hostName = aHostName;
    }

    /**
     * Set or disable the STARTTLS encryption. Please see EMAIL-105
     * for the reasons of deprecation.
     *
     * @deprecated since 1.3, use setStartTLSEnabled() instead
     * @param withTLS true if STARTTLS requested, false otherwise
     * @since 1.1
     */
    @Deprecated
    public void setTLS(final boolean withTLS)
    {
        setStartTLSEnabled(withTLS);
    }

    /**
     * Set or disable the STARTTLS encryption.
     *
     * @param startTlsEnabled true if STARTTLS requested, false otherwise
     * @return An Email.
     * @throws IllegalStateException if the mail session is already initialized
     * @since 1.3
     */
    public Email setStartTLSEnabled(final boolean startTlsEnabled)
    {
        checkSessionAlreadyInitialized();
        this.startTlsEnabled = startTlsEnabled;
        this.tls = startTlsEnabled;
        return this;
    }

    /**
     * Set or disable the required STARTTLS encryption.
     * <p>
     * Defaults to {@link #smtpPort}; can be overridden by using {@link #setSmtpPort(int)}
     *
     * @param startTlsRequired true if STARTTLS requested, false otherwise
     * @return An Email.
     * @throws IllegalStateException if the mail session is already initialized
     * @since 1.3
     */
    public Email setStartTLSRequired(final boolean startTlsRequired)
    {
        checkSessionAlreadyInitialized();
        this.startTlsRequired = startTlsRequired;
        return this;
    }

    /**
     * Set the non-SSL port number of the outgoing mail server.
     *
     * @param  aPortNumber aPortNumber
     * @throws IllegalArgumentException if the port number is &lt; 1
     * @throws IllegalStateException if the mail session is already initialized
     * @since 1.0
     * @see #setSslSmtpPort(String)
     */
    public void setSmtpPort(final int aPortNumber)
    {
        checkSessionAlreadyInitialized();

        if (aPortNumber < 1)
        {
            throw new IllegalArgumentException(
                "Cannot connect to a port number that is less than 1 ( "
                    + aPortNumber
                    + " )");
        }

        this.smtpPort = Integer.toString(aPortNumber);
    }

    /**
     * Supply a mail Session object to use. Please note that passing
     * a user name and password (in the case of mail authentication) will
     * create a new mail session with a DefaultAuthenticator. This is a
     * convenience but might come unexpected.
     *
     * If mail authentication is used but NO username and password
     * is supplied the implementation assumes that you have set a
     * authenticator and will use the existing mail session (as expected).
     *
     * @param aSession mail session to be used
     * @throws IllegalArgumentException if the session is {@code null}
     * @since 1.0
     */
    public void setMailSession(final Session aSession)
    {
        EmailUtils.notNull(aSession, "no mail session supplied");

        final Properties sessionProperties = aSession.getProperties();
        final String auth = sessionProperties.getProperty(EmailConstants.MAIL_SMTP_AUTH);

        if ("true".equalsIgnoreCase(auth))
        {
            final String userName = sessionProperties.getProperty(EmailConstants.MAIL_SMTP_USER);
            final String password = sessionProperties.getProperty(EmailConstants.MAIL_SMTP_PASSWORD);

            if (EmailUtils.isNotEmpty(userName) && EmailUtils.isNotEmpty(password))
            {
                // only create a new mail session with an authenticator if
                // authentication is required and no user name is given
                this.authenticator = new DefaultAuthenticator(userName, password);
                this.session = Session.getInstance(sessionProperties, this.authenticator);
            }
            else
            {
                // assume that the given mail session contains a working authenticator
                this.session = aSession;
            }
        }
        else
        {
            this.session = aSession;
        }
    }

    /**
     * Supply a mail Session object from a JNDI directory.
     *
     * @param jndiName name of JNDI resource (javax.mail.Session type), resource
     * if searched in java:comp/env if name does not start with "java:"
     * @throws IllegalArgumentException if the JNDI name is null or empty
     * @throws NamingException if the resource cannot be retrieved from JNDI directory
     * @since 1.1
     */
    public void setMailSessionFromJNDI(final String jndiName) throws NamingException
    {
        if (EmailUtils.isEmpty(jndiName))
        {
            throw new IllegalArgumentException("JNDI name missing");
        }
        Context ctx = null;
        if (jndiName.startsWith("java:"))
        {
            ctx = new InitialContext();
        }
        else
        {
            ctx = (Context) new InitialContext().lookup("java:comp/env");

        }
        this.setMailSession((Session) ctx.lookup(jndiName));
    }

    /**
     * Determines the mail session used when sending this Email, creating
     * the Session if necessary. When a mail session is already
     * initialized setting the session related properties will cause
     * an IllegalStateException.
     *
     * @return A Session.
     * @throws EmailException if the host name was not set
     * @since 1.0
     */
    public Session getMailSession() throws EmailException
    {
        if (this.session == null)
        {
            final Properties properties = new Properties(System.getProperties());
            properties.setProperty(EmailConstants.MAIL_TRANSPORT_PROTOCOL, EmailConstants.SMTP);

            if (EmailUtils.isEmpty(this.hostName))
            {
                this.hostName = properties.getProperty(EmailConstants.MAIL_HOST);
            }

            if (EmailUtils.isEmpty(this.hostName))
            {
                throw new EmailException("Cannot find valid hostname for mail session");
            }

            properties.setProperty(EmailConstants.MAIL_PORT, this.smtpPort);
            properties.setProperty(EmailConstants.MAIL_HOST, this.hostName);
            properties.setProperty(EmailConstants.MAIL_DEBUG, String.valueOf(this.debug));

            properties.setProperty(EmailConstants.MAIL_TRANSPORT_STARTTLS_ENABLE,
                    isStartTLSEnabled() ? "true" : "false");
            properties.setProperty(EmailConstants.MAIL_TRANSPORT_STARTTLS_REQUIRED,
                    isStartTLSRequired() ? "true" : "false");

            properties.setProperty(EmailConstants.MAIL_SMTP_SEND_PARTIAL,
                    isSendPartial() ? "true" : "false");
            properties.setProperty(EmailConstants.MAIL_SMTPS_SEND_PARTIAL,
                    isSendPartial() ? "true" : "false");

            if (this.authenticator != null)
            {
                properties.setProperty(EmailConstants.MAIL_SMTP_AUTH, "true");
            }

            if (isSSLOnConnect())
            {
                properties.setProperty(EmailConstants.MAIL_PORT, this.sslSmtpPort);
                properties.setProperty(EmailConstants.MAIL_SMTP_SOCKET_FACTORY_PORT, this.sslSmtpPort);
                properties.setProperty(EmailConstants.MAIL_SMTP_SOCKET_FACTORY_CLASS, "javax.net.ssl.SSLSocketFactory");
                properties.setProperty(EmailConstants.MAIL_SMTP_SOCKET_FACTORY_FALLBACK, "false");
            }

            if ((isSSLOnConnect() || isStartTLSEnabled()) && isSSLCheckServerIdentity())
            {
                properties.setProperty(EmailConstants.MAIL_SMTP_SSL_CHECKSERVERIDENTITY, "true");
            }

            if (this.bounceAddress != null)
            {
                properties.setProperty(EmailConstants.MAIL_SMTP_FROM, this.bounceAddress);
            }

            if (this.socketTimeout > 0)
            {
                properties.setProperty(EmailConstants.MAIL_SMTP_TIMEOUT, Integer.toString(this.socketTimeout));
            }

            if (this.socketConnectionTimeout > 0)
            {
                properties.setProperty(EmailConstants.MAIL_SMTP_CONNECTIONTIMEOUT, Integer.toString(this.socketConnectionTimeout));
            }

            // changed this (back) to getInstance due to security exceptions
            // caused when testing using maven
            this.session = Session.getInstance(properties, this.authenticator);
        }
        return this.session;
    }

    /**
     * Set the FROM field of the email to use the specified address. The email
     * address will also be used as the personal name.
     * The name will be encoded by the charset of {@link #setCharset(java.lang.String) setCharset()}.
     * If it is not set, it will be encoded using
     * the Java platform's default charset (UTF-16) if it contains
     * non-ASCII characters; otherwise, it is used as is.
     *
     * @param email A String.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address.
     * @since 1.0
     */
    public Email setFrom(final String email)
        throws EmailException
    {
        return setFrom(email, null);
    }

    /**
     * Set the FROM field of the email to use the specified address and the
     * specified personal name.
     * The name will be encoded by the charset of {@link #setCharset(java.lang.String) setCharset()}.
     * If it is not set, it will be encoded using
     * the Java platform's default charset (UTF-16) if it contains
     * non-ASCII characters; otherwise, it is used as is.
     *
     * @param email A String.
     * @param name A String.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address.
     * @since 1.0
     */
    public Email setFrom(final String email, final String name)
        throws EmailException
    {
        return setFrom(email, name, this.charset);
    }

    /**
     * Set the FROM field of the email to use the specified address, personal
     * name, and charset encoding for the name.
     *
     * @param email A String.
     * @param name A String.
     * @param charset The charset to encode the name with.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address or charset.
     * @since 1.1
     */
    public Email setFrom(final String email, final String name, final String charset)
        throws EmailException
    {
        this.fromAddress = createInternetAddress(email, name, charset);
        return this;
    }

    /**
     * Add a recipient TO to the email. The email
     * address will also be used as the personal name.
     * The name will be encoded by the charset of
     * {@link #setCharset(java.lang.String) setCharset()}.
     * If it is not set, it will be encoded using
     * the Java platform's default charset (UTF-16) if it contains
     * non-ASCII characters; otherwise, it is used as is.
     *
     * @param email A String.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address.
     * @since 1.0
     */
    public Email addTo(final String email)
        throws EmailException
    {
        return addTo(email, null);
    }

    /**
     * Add a list of TO recipients to the email. The email
     * addresses will also be used as the personal names.
     * The names will be encoded by the charset of
     * {@link #setCharset(java.lang.String) setCharset()}.
     * If it is not set, it will be encoded using
     * the Java platform's default charset (UTF-16) if it contains
     * non-ASCII characters; otherwise, it is used as is.
     *
     * @param emails A String array.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address.
     * @since 1.3
     */
    public Email addTo(final String... emails)
        throws EmailException
    {
        if (emails == null || emails.length == 0)
        {
            throw new EmailException("Address List provided was invalid");
        }

        for (final String email : emails)
        {
            addTo(email, null);
        }

        return this;
    }

    /**
     * Add a recipient TO to the email using the specified address and the
     * specified personal name.
     * The name will be encoded by the charset of
     * {@link #setCharset(java.lang.String) setCharset()}.
     * If it is not set, it will be encoded using
     * the Java platform's default charset (UTF-16) if it contains
     * non-ASCII characters; otherwise, it is used as is.
     *
     * @param email A String.
     * @param name A String.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address.
     * @since 1.0
     */
    public Email addTo(final String email, final String name)
        throws EmailException
    {
        return addTo(email, name, this.charset);
    }

    /**
     * Add a recipient TO to the email using the specified address, personal
     * name, and charset encoding for the name.
     *
     * @param email A String.
     * @param name A String.
     * @param charset The charset to encode the name with.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address or charset.
     * @since 1.1
     */
    public Email addTo(final String email, final String name, final String charset)
        throws EmailException
    {
        this.toList.add(createInternetAddress(email, name, charset));
        return this;
    }

    /**
     * Set a list of "TO" addresses. All elements in the specified
     * {@code Collection} are expected to be of type
     * {@code java.mail.internet.InternetAddress}.
     *
     * @param  aCollection collection of {@code InternetAddress} objects.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address.
     * @see javax.mail.internet.InternetAddress
     * @since 1.0
     */
    public Email setTo(final Collection<InternetAddress> aCollection) throws EmailException
    {
        if (aCollection == null || aCollection.isEmpty())
        {
            throw new EmailException("Address List provided was invalid");
        }

        this.toList = new ArrayList<InternetAddress>(aCollection);
        return this;
    }

    /**
     * Add a recipient CC to the email. The email
     * address will also be used as the personal name.
     * The name will be encoded by the charset of {@link #setCharset(java.lang.String) setCharset()}.
     * If it is not set, it will be encoded using
     * the Java platform's default charset (UTF-16) if it contains
     * non-ASCII characters; otherwise, it is used as is.
     *
     * @param email A String.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address.
     * @since 1.0
     */
    public Email addCc(final String email)
        throws EmailException
    {
        return this.addCc(email, null);
    }

    /**
     * Add an array of CC recipients to the email. The email
     * addresses will also be used as the personal name.
     * The names will be encoded by the charset of
     * {@link #setCharset(java.lang.String) setCharset()}.
     * If it is not set, it will be encoded using
     * the Java platform's default charset (UTF-16) if it contains
     * non-ASCII characters; otherwise, it is used as is.
     *
     * @param emails A String array.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address.
     * @since 1.3
     */
    public Email addCc(final String... emails)
        throws EmailException
    {
        if (emails == null || emails.length == 0)
        {
            throw new EmailException("Address List provided was invalid");
        }

        for (final String email : emails)
        {
            addCc(email, null);
        }

        return this;
    }

    /**
     * Add a recipient CC to the email using the specified address and the
     * specified personal name.
     * The name will be encoded by the charset of {@link #setCharset(java.lang.String) setCharset()}.
     * If it is not set, it will be encoded using
     * the Java platform's default charset (UTF-16) if it contains
     * non-ASCII characters; otherwise, it is used as is.
     *
     * @param email A String.
     * @param name A String.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address.
     * @since 1.0
     */
    public Email addCc(final String email, final String name)
        throws EmailException
    {
        return addCc(email, name, this.charset);
    }

    /**
     * Add a recipient CC to the email using the specified address, personal
     * name, and charset encoding for the name.
     *
     * @param email A String.
     * @param name A String.
     * @param charset The charset to encode the name with.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address or charset.
     * @since 1.1
     */
    public Email addCc(final String email, final String name, final String charset)
        throws EmailException
    {
        this.ccList.add(createInternetAddress(email, name, charset));
        return this;
    }

    /**
     * Set a list of "CC" addresses. All elements in the specified
     * {@code Collection} are expected to be of type
     * {@code java.mail.internet.InternetAddress}.
     *
     * @param aCollection collection of {@code InternetAddress} objects.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address.
     * @see javax.mail.internet.InternetAddress
     * @since 1.0
     */
    public Email setCc(final Collection<InternetAddress> aCollection) throws EmailException
    {
        if (aCollection == null || aCollection.isEmpty())
        {
            throw new EmailException("Address List provided was invalid");
        }

        this.ccList = new ArrayList<InternetAddress>(aCollection);
        return this;
    }

    /**
     * Add a blind BCC recipient to the email. The email
     * address will also be used as the personal name.
     * The name will be encoded by the charset of {@link #setCharset(java.lang.String) setCharset()}.
     * If it is not set, it will be encoded using
     * the Java platform's default charset (UTF-16) if it contains
     * non-ASCII characters; otherwise, it is used as is.
     *
     * @param email A String.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address
     * @since 1.0
     */
    public Email addBcc(final String email)
        throws EmailException
    {
        return this.addBcc(email, null);
    }

    /**
     * Add an array of blind BCC recipients to the email. The email
     * addresses will also be used as the personal name.
     * The names will be encoded by the charset of
     * {@link #setCharset(java.lang.String) setCharset()}.
     * If it is not set, it will be encoded using
     * the Java platform's default charset (UTF-16) if it contains
     * non-ASCII characters; otherwise, it is used as is.
     *
     * @param emails A String array.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address
     * @since 1.3
     */
    public Email addBcc(final String... emails)
        throws EmailException
    {
        if (emails == null || emails.length == 0)
        {
            throw new EmailException("Address List provided was invalid");
        }

        for (final String email : emails)
        {
            addBcc(email, null);
        }

        return this;
    }

    /**
     * Add a blind BCC recipient to the email using the specified address and
     * the specified personal name.
     * The name will be encoded by the charset of {@link #setCharset(java.lang.String) setCharset()}.
     * If it is not set, it will be encoded using
     * the Java platform's default charset (UTF-16) if it contains
     * non-ASCII characters; otherwise, it is used as is.
     *
     * @param email A String.
     * @param name A String.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address
     * @since 1.0
     */
    public Email addBcc(final String email, final String name)
        throws EmailException
    {
        return addBcc(email, name, this.charset);
    }

    /**
     * Add a blind BCC recipient to the email using the specified address,
     * personal name, and charset encoding for the name.
     *
     * @param email A String.
     * @param name A String.
     * @param charset The charset to encode the name with.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address
     * @since 1.1
     */
    public Email addBcc(final String email, final String name, final String charset)
        throws EmailException
    {
        this.bccList.add(createInternetAddress(email, name, charset));
        return this;
    }

    /**
     * Set a list of "BCC" addresses. All elements in the specified
     * {@code Collection} are expected to be of type
     * {@code java.mail.internet.InternetAddress}.
     *
     * @param  aCollection collection of {@code InternetAddress} objects
     * @return An Email.
     * @throws EmailException Indicates an invalid email address
     * @see javax.mail.internet.InternetAddress
     * @since 1.0
     */
    public Email setBcc(final Collection<InternetAddress> aCollection) throws EmailException
    {
        if (aCollection == null || aCollection.isEmpty())
        {
            throw new EmailException("Address List provided was invalid");
        }

        this.bccList = new ArrayList<InternetAddress>(aCollection);
        return this;
    }

    /**
     * Add a reply to address to the email. The email
     * address will also be used as the personal name.
     * The name will be encoded by the charset of {@link #setCharset(java.lang.String) setCharset()}.
     * If it is not set, it will be encoded using
     * the Java platform's default charset (UTF-16) if it contains
     * non-ASCII characters; otherwise, it is used as is.
     *
     * @param email A String.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address
     * @since 1.0
     */
    public Email addReplyTo(final String email)
        throws EmailException
    {
        return this.addReplyTo(email, null);
    }

    /**
     * Add a reply to address to the email using the specified address and
     * the specified personal name.
     * The name will be encoded by the charset of {@link #setCharset(java.lang.String) setCharset()}.
     * If it is not set, it will be encoded using
     * the Java platform's default charset (UTF-16) if it contains
     * non-ASCII characters; otherwise, it is used as is.
     *
     * @param email A String.
     * @param name A String.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address
     * @since 1.0
     */
    public Email addReplyTo(final String email, final String name)
        throws EmailException
    {
        return addReplyTo(email, name, this.charset);
    }

    /**
     * Add a reply to address to the email using the specified address,
     * personal name, and charset encoding for the name.
     *
     * @param email A String.
     * @param name A String.
     * @param charset The charset to encode the name with.
     * @return An Email.
     * @throws EmailException Indicates an invalid email address or charset.
     * @since 1.1
     */
    public Email addReplyTo(final String email, final String name, final String charset)
        throws EmailException
    {
        this.replyList.add(createInternetAddress(email, name, charset));
        return this;
    }

    /**
     * Set a list of reply to addresses. All elements in the specified
     * {@code Collection} are expected to be of type
     * {@code java.mail.internet.InternetAddress}.
     *
     * @param   aCollection collection of {@code InternetAddress} objects
     * @return  An Email.
     * @throws EmailException Indicates an invalid email address
     * @see javax.mail.internet.InternetAddress
     * @since 1.1
     */
    public Email setReplyTo(final Collection<InternetAddress> aCollection) throws EmailException
    {
        if (aCollection == null || aCollection.isEmpty())
        {
            throw new EmailException("Address List provided was invalid");
        }

        this.replyList = new ArrayList<InternetAddress>(aCollection);
        return this;
    }

    /**
     * Used to specify the mail headers.  Example:
     *
     * X-Mailer: Sendmail, X-Priority: 1( highest )
     * or  2( high ) 3( normal ) 4( low ) and 5( lowest )
     * Disposition-Notification-To: user@domain.net
     *
     * @param map A Map.
     * @throws IllegalArgumentException if either of the provided header / value is null or empty
     * @since 1.0
     */
    public void setHeaders(final Map<String, String> map)
    {
        this.headers.clear();

        for (final Map.Entry<String, String> entry : map.entrySet())
        {
            addHeader(entry.getKey(), entry.getValue());
        }
    }

    /**
     * Adds a header ( name, value ) to the headers Map.
     *
     * @param name A String with the name.
     * @param value A String with the value.
     * @since 1.0
     * @throws IllegalArgumentException if either {@code name} or {@code value} is null or empty
     */
    public void addHeader(final String name, final String value)
    {
        if (EmailUtils.isEmpty(name))
        {
            throw new IllegalArgumentException("name can not be null or empty");
        }
        if (EmailUtils.isEmpty(value))
        {
            throw new IllegalArgumentException("value can not be null or empty");
        }

        this.headers.put(name, value);
    }

    /**
     * Gets the specified header.
     *
     * @param header A string with the header.
     * @return The value of the header, or null if no such header.
     * @since 1.5
     */
    public String getHeader(final String header)
    {
        return this.headers.get(header);
    }

    /**
     * Gets all headers on an Email.
     *
     * @return a Map of all headers.
     * @since 1.5
     */
    public Map<String, String> getHeaders()
    {
        return this.headers;
    }

    /**
     * Sets the email subject. Replaces end-of-line characters with spaces.
     *
     * @param aSubject A String.
     * @return An Email.
     * @since 1.0
     */
    public Email setSubject(final String aSubject)
    {
        this.subject = EmailUtils.replaceEndOfLineCharactersWithSpaces(aSubject);
        return this;
    }

    /**
     * Gets the "bounce address" of this email.
     *
     * @return the bounce address as string
     * @since 1.4
     */
    public String getBounceAddress()
    {
        return this.bounceAddress;
    }

    /**
     * Set the "bounce address" - the address to which undeliverable messages
     * will be returned.  If this value is never set, then the message will be
     * sent to the address specified with the System property "mail.smtp.from",
     * or if that value is not set, then to the "from" address.
     *
     * @param email A String.
     * @return An Email.
     * @throws IllegalStateException if the mail session is already initialized
     * @since 1.0
     */
    public Email setBounceAddress(final String email)
    {
        checkSessionAlreadyInitialized();

        if (email != null && !email.isEmpty())
        {
            try
            {
                this.bounceAddress = createInternetAddress(email, null, this.charset).getAddress();
            }
            catch (final EmailException e)
            {
                // Can't throw 'EmailException' to keep backward-compatibility
                throw new IllegalArgumentException("Failed to set the bounce address : " + email, e);
            }
        }
        else
        {
            this.bounceAddress = email;
        }

        return this;
    }

    /**
     * Define the content of the mail. It should be overridden by the
     * subclasses.
     *
     * @param msg A String.
     * @return An Email.
     * @throws EmailException generic exception.
     * @since 1.0
     */
    public abstract Email setMsg(String msg) throws EmailException;

    /**
     * Does the work of actually building the MimeMessage. Please note that
     * a user rarely calls this method directly and only if he/she is
     * interested in the sending the underlying MimeMessage without
     * commons-email.
     *
     * @throws IllegalStateException if the MimeMessage was already built
     * @throws EmailException if there was an error.
     * @since 1.0
     */
    public void buildMimeMessage() throws EmailException
    {
        if (this.message != null)
        {
            // [EMAIL-95] we assume that an email is not reused therefore invoking
            // buildMimeMessage() more than once is illegal.
            throw new IllegalStateException("The MimeMessage is already built.");
        }

        try
        {
            this.message = this.createMimeMessage(this.getMailSession());

            if (EmailUtils.isNotEmpty(this.subject))
            {
                if (EmailUtils.isNotEmpty(this.charset))
                {
                    this.message.setSubject(this.subject, this.charset);
                }
                else
                {
                    this.message.setSubject(this.subject);
                }
            }

            // update content type (and encoding)
            this.updateContentType(this.contentType);

            if (this.content != null)
            {
                if (EmailConstants.TEXT_PLAIN.equalsIgnoreCase(this.contentType)
                        && this.content instanceof String)
                {
                    // EMAIL-104: call explicitly setText to use default mime charset
                    //            (property "mail.mime.charset") in case none has been set
                    this.message.setText(this.content.toString(), this.charset);
                }
                else
                {
                    this.message.setContent(this.content, this.contentType);
                }
            }
            else if (this.emailBody != null)
            {
                if (this.contentType == null)
                {
                    this.message.setContent(this.emailBody);
                }
                else
                {
                    this.message.setContent(this.emailBody, this.contentType);
                }
            }
            else
            {
                this.message.setText("");
            }

            if (this.fromAddress != null)
            {
                this.message.setFrom(this.fromAddress);
            }
            else
            {
                if (session.getProperty(EmailConstants.MAIL_SMTP_FROM) == null
                        && session.getProperty(EmailConstants.MAIL_FROM) == null)
                {
                    throw new EmailException("From address required");
                }
            }

            if (this.toList.size() + this.ccList.size() + this.bccList.size() == 0)
            {
                throw new EmailException("At least one receiver address required");
            }

            if (this.toList.size() > 0)
            {
                this.message.setRecipients(
                    Message.RecipientType.TO,
                    this.toInternetAddressArray(this.toList));
            }

            if (this.ccList.size() > 0)
            {
                this.message.setRecipients(
                    Message.RecipientType.CC,
                    this.toInternetAddressArray(this.ccList));
            }

            if (this.bccList.size() > 0)
            {
                this.message.setRecipients(
                    Message.RecipientType.BCC,
                    this.toInternetAddressArray(this.bccList));
            }

            if (this.replyList.size() > 0)
            {
                this.message.setReplyTo(
                    this.toInternetAddressArray(this.replyList));
            }


            if (this.headers.size() > 0)
            {
                for (final Map.Entry<String, String> entry : this.headers.entrySet())
                {
                    final String foldedValue = createFoldedHeaderValue(entry.getKey(), entry.getValue());
                    this.message.addHeader(entry.getKey(), foldedValue);
                }
            }

            if (this.message.getSentDate() == null)
            {
                this.message.setSentDate(getSentDate());
            }

            if (this.popBeforeSmtp)
            {
                final Store store = session.getStore("pop3");
                store.connect(this.popHost, this.popUsername, this.popPassword);
            }
        }
        catch (final MessagingException me)
        {
            throw new EmailException(me);
        }
    }

    /**
     * Sends the previously created MimeMessage to the SMTP server.
     *
     * @return the message id of the underlying MimeMessage
     * @throws IllegalArgumentException if the MimeMessage has not been created
     * @throws EmailException the sending failed
     */
    public String sendMimeMessage()
       throws EmailException
    {
        EmailUtils.notNull(this.message, "MimeMessage has not been created yet");

        try
        {
            Transport.send(this.message);
            return this.message.getMessageID();
        }
        catch (final Throwable t)
        {
            final String msg = "Sending the email to the following server failed : "
                + this.getHostName()
                + ":"
                + this.getSmtpPort();

            throw new EmailException(msg, t);
        }
    }

    /**
     * Returns the internal MimeMessage. Please note that the
     * MimeMessage is built by the buildMimeMessage() method.
     *
     * @return the MimeMessage
     */
    public MimeMessage getMimeMessage()
    {
        return this.message;
    }

    /**
     * Sends the email. Internally we build a MimeMessage
     * which is afterwards sent to the SMTP server.
     *
     * @return the message id of the underlying MimeMessage
     * @throws IllegalStateException if the MimeMessage was already built, ie {@link #buildMimeMessage()}
     *   was already called
     * @throws EmailException the sending failed
     */
    public String send() throws EmailException
    {
        this.buildMimeMessage();
        return this.sendMimeMessage();
    }

    /**
     * Sets the sent date for the email.  The sent date will default to the
     * current date if not explicitly set.
     *
     * @param date Date to use as the sent date on the email
     * @since 1.0
     */
    public void setSentDate(final Date date)
    {
        if (date != null)
        {
            // create a separate instance to keep findbugs happy
            this.sentDate = new Date(date.getTime());
        }
    }

    /**
     * Gets the sent date for the email.
     *
     * @return date to be used as the sent date for the email
     * @since 1.0
     */
    public Date getSentDate()
    {
        if (this.sentDate == null)
        {
            return new Date();
        }
        return new Date(this.sentDate.getTime());
    }

    /**
     * Gets the subject of the email.
     *
     * @return email subject
     */
    public String getSubject()
    {
        return this.subject;
    }

    /**
     * Gets the sender of the email.
     *
     * @return from address
     */
    public InternetAddress getFromAddress()
    {
        return this.fromAddress;
    }

    /**
     * Gets the host name of the SMTP server,
     *
     * @return host name
     */
    public String getHostName()
    {
        if (this.session != null)
        {
            return this.session.getProperty(EmailConstants.MAIL_HOST);
        }
        else if (EmailUtils.isNotEmpty(this.hostName))
        {
            return this.hostName;
        }
        return null;
    }

    /**
     * Gets the listening port of the SMTP server.
     *
     * @return smtp port
     */
    public String getSmtpPort()
    {
        if (this.session != null)
        {
            return this.session.getProperty(EmailConstants.MAIL_PORT);
        }
        else if (EmailUtils.isNotEmpty(this.smtpPort))
        {
            return this.smtpPort;
        }
        return null;
    }

    /**
     * Gets whether the client is configured to require STARTTLS.
     *
     * @return true if using STARTTLS for authentication, false otherwise
     * @since 1.3
     */
    public boolean isStartTLSRequired()
    {
        return this.startTlsRequired;
    }

    /**
     * Gets whether the client is configured to try to enable STARTTLS.
     *
     * @return true if using STARTTLS for authentication, false otherwise
     * @since 1.3
     */
    public boolean isStartTLSEnabled()
    {
        return this.startTlsEnabled || tls;
    }

    /**
     * Gets whether the client is configured to try to enable STARTTLS.
     * See EMAIL-105 for reason of deprecation.
     *
     * @deprecated since 1.3, use isStartTLSEnabled() instead
     * @return true if using STARTTLS for authentication, false otherwise
     * @since 1.1
     */
    @Deprecated
    public boolean isTLS()
    {
        return isStartTLSEnabled();
    }

    /**
     * Utility to copy List of known InternetAddress objects into an
     * array.
     *
     * @param list A List.
     * @return An InternetAddress[].
     * @since 1.0
     */
    protected InternetAddress[] toInternetAddressArray(final List<InternetAddress> list)
    {
        return list.toArray(new InternetAddress[list.size()]);
    }

    /**
     * Set details regarding "pop3 before smtp" authentication.
     *
     * @param newPopBeforeSmtp Whether or not to log into pop3 server before sending mail.
     * @param newPopHost The pop3 host to use.
     * @param newPopUsername The pop3 username.
     * @param newPopPassword The pop3 password.
     * @since 1.0
     */
    public void setPopBeforeSmtp(
        final boolean newPopBeforeSmtp,
        final String newPopHost,
        final String newPopUsername,
        final String newPopPassword)
    {
        this.popBeforeSmtp = newPopBeforeSmtp;
        this.popHost = newPopHost;
        this.popUsername = newPopUsername;
        this.popPassword = newPopPassword;
    }

    /**
     * Returns whether SSL/TLS encryption for the transport is currently enabled (SMTPS/POPS).
     * See EMAIL-105 for reason of deprecation.
     *
     * @deprecated since 1.3, use isSSLOnConnect() instead
     * @return true if SSL enabled for the transport
     */
    @Deprecated
    public boolean isSSL()
    {
        return isSSLOnConnect();
    }

    /**
     * Returns whether SSL/TLS encryption for the transport is currently enabled (SMTPS/POPS).
     *
     * @return true if SSL enabled for the transport
     * @since 1.3
     */
    public boolean isSSLOnConnect()
    {
        return sslOnConnect || ssl;
    }

    /**
     * Sets whether SSL/TLS encryption should be enabled for the SMTP transport upon connection (SMTPS/POPS).
     * See EMAIL-105 for reason of deprecation.
     *
     * @deprecated since 1.3, use setSSLOnConnect() instead
     * @param ssl whether to enable the SSL transport
     */
    @Deprecated
    public void setSSL(final boolean ssl)
    {
        setSSLOnConnect(ssl);
    }

    /**
     * Sets whether SSL/TLS encryption should be enabled for the SMTP transport upon connection (SMTPS/POPS).
     * Takes precedence over {@link #setStartTLSRequired(boolean)}
     * <p>
     * Defaults to {@link #sslSmtpPort}; can be overridden by using {@link #setSslSmtpPort(String)}
     *
     * @param ssl whether to enable the SSL transport
     * @return An Email.
     * @throws IllegalStateException if the mail session is already initialized
     * @since 1.3
     */
    public Email setSSLOnConnect(final boolean ssl)
    {
        checkSessionAlreadyInitialized();
        this.sslOnConnect = ssl;
        this.ssl = ssl;
        return this;
    }

    /**
    * Is the server identity checked as specified by RFC 2595
    *
    * @return true if the server identity is checked
    * @since 1.3
    */
    public boolean isSSLCheckServerIdentity()
    {
        return sslCheckServerIdentity;
    }

    /**
     * Sets whether the server identity is checked as specified by RFC 2595
     *
     * @param sslCheckServerIdentity whether to enable server identity check
     * @return An Email.
     * @throws IllegalStateException if the mail session is already initialized
     * @since 1.3
     */
    public Email setSSLCheckServerIdentity(final boolean sslCheckServerIdentity)
    {
        checkSessionAlreadyInitialized();
        this.sslCheckServerIdentity = sslCheckServerIdentity;
        return this;
    }

    /**
     * Returns the current SSL port used by the SMTP transport.
     *
     * @return the current SSL port used by the SMTP transport
     */
    public String getSslSmtpPort()
    {
        if (this.session != null)
        {
            return this.session.getProperty(EmailConstants.MAIL_SMTP_SOCKET_FACTORY_PORT);
        }
        else if (EmailUtils.isNotEmpty(this.sslSmtpPort))
        {
            return this.sslSmtpPort;
        }
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
    public void setSslSmtpPort(final String sslSmtpPort)
    {
        checkSessionAlreadyInitialized();
        this.sslSmtpPort = sslSmtpPort;
    }

    /**
    * If partial sending of email enabled.
    *
    * @return true if sending partial email is enabled
    * @since 1.3.2
    */
    public boolean isSendPartial()
    {
        return sendPartial;
    }

    /**
     * Sets whether the email is partially send in case of invalid addresses.
     * <p>
     * In case the mail server rejects an address as invalid, the call to {@link #send()}
     * may throw a {@link javax.mail.SendFailedException}, even if partial send mode is enabled (emails
     * to valid addresses will be transmitted). In case the email server does not reject
     * invalid addresses immediately, but return a bounce message, no exception will be thrown
     * by the {@link #send()} method.
     *
     * @param sendPartial whether to enable partial send mode
     * @return An Email.
     * @throws IllegalStateException if the mail session is already initialized
     * @since 1.3.2
     */
    public Email setSendPartial(final boolean sendPartial)
    {
        checkSessionAlreadyInitialized();
        this.sendPartial = sendPartial;
        return this;
    }

    /**
     * Get the list of "To" addresses.
     *
     * @return List addresses
     */
    public List<InternetAddress> getToAddresses()
    {
        return this.toList;
    }

    /**
     * Get the list of "CC" addresses.
     *
     * @return List addresses
     */
    public List<InternetAddress> getCcAddresses()
    {
        return this.ccList;
    }

    /**
     * Get the list of "Bcc" addresses.
     *
     * @return List addresses
     */
    public List<InternetAddress> getBccAddresses()
    {
        return this.bccList;
    }

    /**
     * Get the list of "Reply-To" addresses.
     *
     * @return List addresses
     */
    public List<InternetAddress> getReplyToAddresses()
    {
        return this.replyList;
    }

    /**
     * Get the socket connection timeout value in milliseconds.
     *
     * @return the timeout in milliseconds.
     * @since 1.2
     */
    public int getSocketConnectionTimeout()
    {
        return this.socketConnectionTimeout;
    }

    /**
     * Set the socket connection timeout value in milliseconds.
     * Default is a 60 second timeout.
     *
     * @param socketConnectionTimeout the connection timeout
     * @throws IllegalStateException if the mail session is already initialized
     * @since 1.2
     */
    public void setSocketConnectionTimeout(final int socketConnectionTimeout)
    {
        checkSessionAlreadyInitialized();
        this.socketConnectionTimeout = socketConnectionTimeout;
    }

    /**
     * Get the socket I/O timeout value in milliseconds.
     *
     * @return the socket I/O timeout
     * @since 1.2
     */
    public int getSocketTimeout()
    {
        return this.socketTimeout;
    }

    /**
     * Set the socket I/O timeout value in milliseconds.
     * Default is 60 second timeout.
     *
     * @param socketTimeout the socket I/O timeout
     * @throws IllegalStateException if the mail session is already initialized
     * @since 1.2
     */
    public void setSocketTimeout(final int socketTimeout)
    {
        checkSessionAlreadyInitialized();
        this.socketTimeout = socketTimeout;
    }

    /**
     * Factory method to create a customized MimeMessage which can be
     * implemented by a derived class, e.g. to set the message id.
     *
     * @param aSession mail session to be used
     * @return the newly created message
     */
    protected MimeMessage createMimeMessage(final Session aSession)
    {
        return new MimeMessage(aSession);
    }

    /**
     * Create a folded header value containing 76 character chunks.
     *
     * @param name the name of the header
     * @param value the value of the header
     * @return the folded header value
     * @throws IllegalArgumentException if either the name or value is null or empty
     */
    private String createFoldedHeaderValue(final String name, final String value)
    {
        if (EmailUtils.isEmpty(name))
        {
            throw new IllegalArgumentException("name can not be null or empty");
        }
        if (value == null || EmailUtils.isEmpty(value))
        {
            throw new IllegalArgumentException("value can not be null or empty");
        }

        try
        {
            return MimeUtility.fold(name.length() + 2, MimeUtility.encodeText(value, this.charset, null));
        }
        catch (final UnsupportedEncodingException e)
        {
            return value;
        }
    }

    /**
     * Creates a InternetAddress.
     *
     * @param email An email address.
     * @param name A name.
     * @param charsetName The name of the charset to encode the name with.
     * @return An internet address.
     * @throws EmailException Thrown when the supplied address, name or charset were invalid.
     */
    private InternetAddress createInternetAddress(final String email, final String name, final String charsetName)
        throws EmailException
    {
        InternetAddress address;

        try
        {
            address = new InternetAddress(new IDNEmailAddressConverter().toASCII(email));

            // check name input
            if (EmailUtils.isNotEmpty(name))
            {
                // check charset input.
                if (EmailUtils.isEmpty(charsetName))
                {
                    address.setPersonal(name);
                }
                else
                {
                    // canonicalize the charset name and make sure
                    // the current platform supports it.
                    final Charset set = Charset.forName(charsetName);
                    address.setPersonal(name, set.name());
                }
            }

            // run sanity check on new InternetAddress object; if this fails
            // it will throw AddressException.
            address.validate();
        }
        catch (final AddressException e)
        {
            throw new EmailException(e);
        }
        catch (final UnsupportedEncodingException e)
        {
            throw new EmailException(e);
        }
        return address;
    }

    /**
     * When a mail session is already initialized setting the
     * session properties has no effect. In order to flag the
     * problem throw an IllegalStateException.
     *
     * @throws IllegalStateException when the mail session is already initialized
     */
    private void checkSessionAlreadyInitialized()
    {
        if (this.session != null)
        {
            throw new IllegalStateException("The mail session is already initialized");
        }
    }
}
