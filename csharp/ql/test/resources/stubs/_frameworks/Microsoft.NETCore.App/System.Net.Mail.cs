// This file contains auto-generated code.
// Generated from `System.Net.Mail, Version=8.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`.
namespace System
{
    namespace Net
    {
        namespace Mail
        {
            public class AlternateView : System.Net.Mail.AttachmentBase
            {
                public System.Uri BaseUri { get => throw null; set { } }
                public static System.Net.Mail.AlternateView CreateAlternateViewFromString(string content) => throw null;
                public static System.Net.Mail.AlternateView CreateAlternateViewFromString(string content, System.Net.Mime.ContentType contentType) => throw null;
                public static System.Net.Mail.AlternateView CreateAlternateViewFromString(string content, System.Text.Encoding contentEncoding, string mediaType) => throw null;
                public AlternateView(System.IO.Stream contentStream) : base(default(System.IO.Stream)) => throw null;
                public AlternateView(System.IO.Stream contentStream, System.Net.Mime.ContentType contentType) : base(default(System.IO.Stream)) => throw null;
                public AlternateView(System.IO.Stream contentStream, string mediaType) : base(default(System.IO.Stream)) => throw null;
                public AlternateView(string fileName) : base(default(System.IO.Stream)) => throw null;
                public AlternateView(string fileName, System.Net.Mime.ContentType contentType) : base(default(System.IO.Stream)) => throw null;
                public AlternateView(string fileName, string mediaType) : base(default(System.IO.Stream)) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public System.Net.Mail.LinkedResourceCollection LinkedResources { get => throw null; }
            }
            public sealed class AlternateViewCollection : System.Collections.ObjectModel.Collection<System.Net.Mail.AlternateView>, System.IDisposable
            {
                protected override void ClearItems() => throw null;
                public void Dispose() => throw null;
                protected override void InsertItem(int index, System.Net.Mail.AlternateView item) => throw null;
                protected override void RemoveItem(int index) => throw null;
                protected override void SetItem(int index, System.Net.Mail.AlternateView item) => throw null;
            }
            public class Attachment : System.Net.Mail.AttachmentBase
            {
                public System.Net.Mime.ContentDisposition ContentDisposition { get => throw null; }
                public static System.Net.Mail.Attachment CreateAttachmentFromString(string content, System.Net.Mime.ContentType contentType) => throw null;
                public static System.Net.Mail.Attachment CreateAttachmentFromString(string content, string name) => throw null;
                public static System.Net.Mail.Attachment CreateAttachmentFromString(string content, string name, System.Text.Encoding contentEncoding, string mediaType) => throw null;
                public Attachment(System.IO.Stream contentStream, System.Net.Mime.ContentType contentType) : base(default(System.IO.Stream)) => throw null;
                public Attachment(System.IO.Stream contentStream, string name) : base(default(System.IO.Stream)) => throw null;
                public Attachment(System.IO.Stream contentStream, string name, string mediaType) : base(default(System.IO.Stream)) => throw null;
                public Attachment(string fileName) : base(default(System.IO.Stream)) => throw null;
                public Attachment(string fileName, System.Net.Mime.ContentType contentType) : base(default(System.IO.Stream)) => throw null;
                public Attachment(string fileName, string mediaType) : base(default(System.IO.Stream)) => throw null;
                public string Name { get => throw null; set { } }
                public System.Text.Encoding NameEncoding { get => throw null; set { } }
            }
            public abstract class AttachmentBase : System.IDisposable
            {
                public string ContentId { get => throw null; set { } }
                public System.IO.Stream ContentStream { get => throw null; }
                public System.Net.Mime.ContentType ContentType { get => throw null; set { } }
                protected AttachmentBase(System.IO.Stream contentStream) => throw null;
                protected AttachmentBase(System.IO.Stream contentStream, System.Net.Mime.ContentType contentType) => throw null;
                protected AttachmentBase(System.IO.Stream contentStream, string mediaType) => throw null;
                protected AttachmentBase(string fileName) => throw null;
                protected AttachmentBase(string fileName, System.Net.Mime.ContentType contentType) => throw null;
                protected AttachmentBase(string fileName, string mediaType) => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public System.Net.Mime.TransferEncoding TransferEncoding { get => throw null; set { } }
            }
            public sealed class AttachmentCollection : System.Collections.ObjectModel.Collection<System.Net.Mail.Attachment>, System.IDisposable
            {
                protected override void ClearItems() => throw null;
                public void Dispose() => throw null;
                protected override void InsertItem(int index, System.Net.Mail.Attachment item) => throw null;
                protected override void RemoveItem(int index) => throw null;
                protected override void SetItem(int index, System.Net.Mail.Attachment item) => throw null;
            }
            [System.Flags]
            public enum DeliveryNotificationOptions
            {
                None = 0,
                OnSuccess = 1,
                OnFailure = 2,
                Delay = 4,
                Never = 134217728,
            }
            public class LinkedResource : System.Net.Mail.AttachmentBase
            {
                public System.Uri ContentLink { get => throw null; set { } }
                public static System.Net.Mail.LinkedResource CreateLinkedResourceFromString(string content) => throw null;
                public static System.Net.Mail.LinkedResource CreateLinkedResourceFromString(string content, System.Net.Mime.ContentType contentType) => throw null;
                public static System.Net.Mail.LinkedResource CreateLinkedResourceFromString(string content, System.Text.Encoding contentEncoding, string mediaType) => throw null;
                public LinkedResource(System.IO.Stream contentStream) : base(default(System.IO.Stream)) => throw null;
                public LinkedResource(System.IO.Stream contentStream, System.Net.Mime.ContentType contentType) : base(default(System.IO.Stream)) => throw null;
                public LinkedResource(System.IO.Stream contentStream, string mediaType) : base(default(System.IO.Stream)) => throw null;
                public LinkedResource(string fileName) : base(default(System.IO.Stream)) => throw null;
                public LinkedResource(string fileName, System.Net.Mime.ContentType contentType) : base(default(System.IO.Stream)) => throw null;
                public LinkedResource(string fileName, string mediaType) : base(default(System.IO.Stream)) => throw null;
            }
            public sealed class LinkedResourceCollection : System.Collections.ObjectModel.Collection<System.Net.Mail.LinkedResource>, System.IDisposable
            {
                protected override void ClearItems() => throw null;
                public void Dispose() => throw null;
                protected override void InsertItem(int index, System.Net.Mail.LinkedResource item) => throw null;
                protected override void RemoveItem(int index) => throw null;
                protected override void SetItem(int index, System.Net.Mail.LinkedResource item) => throw null;
            }
            public class MailAddress
            {
                public string Address { get => throw null; }
                public MailAddress(string address) => throw null;
                public MailAddress(string address, string displayName) => throw null;
                public MailAddress(string address, string displayName, System.Text.Encoding displayNameEncoding) => throw null;
                public string DisplayName { get => throw null; }
                public override bool Equals(object value) => throw null;
                public override int GetHashCode() => throw null;
                public string Host { get => throw null; }
                public override string ToString() => throw null;
                public static bool TryCreate(string address, out System.Net.Mail.MailAddress result) => throw null;
                public static bool TryCreate(string address, string displayName, out System.Net.Mail.MailAddress result) => throw null;
                public static bool TryCreate(string address, string displayName, System.Text.Encoding displayNameEncoding, out System.Net.Mail.MailAddress result) => throw null;
                public string User { get => throw null; }
            }
            public class MailAddressCollection : System.Collections.ObjectModel.Collection<System.Net.Mail.MailAddress>
            {
                public void Add(string addresses) => throw null;
                public MailAddressCollection() => throw null;
                protected override void InsertItem(int index, System.Net.Mail.MailAddress item) => throw null;
                protected override void SetItem(int index, System.Net.Mail.MailAddress item) => throw null;
                public override string ToString() => throw null;
            }
            public class MailMessage : System.IDisposable
            {
                public System.Net.Mail.AlternateViewCollection AlternateViews { get => throw null; }
                public System.Net.Mail.AttachmentCollection Attachments { get => throw null; }
                public System.Net.Mail.MailAddressCollection Bcc { get => throw null; }
                public string Body { get => throw null; set { } }
                public System.Text.Encoding BodyEncoding { get => throw null; set { } }
                public System.Net.Mime.TransferEncoding BodyTransferEncoding { get => throw null; set { } }
                public System.Net.Mail.MailAddressCollection CC { get => throw null; }
                public MailMessage() => throw null;
                public MailMessage(System.Net.Mail.MailAddress from, System.Net.Mail.MailAddress to) => throw null;
                public MailMessage(string from, string to) => throw null;
                public MailMessage(string from, string to, string subject, string body) => throw null;
                public System.Net.Mail.DeliveryNotificationOptions DeliveryNotificationOptions { get => throw null; set { } }
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public System.Net.Mail.MailAddress From { get => throw null; set { } }
                public System.Collections.Specialized.NameValueCollection Headers { get => throw null; }
                public System.Text.Encoding HeadersEncoding { get => throw null; set { } }
                public bool IsBodyHtml { get => throw null; set { } }
                public System.Net.Mail.MailPriority Priority { get => throw null; set { } }
                public System.Net.Mail.MailAddress ReplyTo { get => throw null; set { } }
                public System.Net.Mail.MailAddressCollection ReplyToList { get => throw null; }
                public System.Net.Mail.MailAddress Sender { get => throw null; set { } }
                public string Subject { get => throw null; set { } }
                public System.Text.Encoding SubjectEncoding { get => throw null; set { } }
                public System.Net.Mail.MailAddressCollection To { get => throw null; }
            }
            public enum MailPriority
            {
                Normal = 0,
                Low = 1,
                High = 2,
            }
            public delegate void SendCompletedEventHandler(object sender, System.ComponentModel.AsyncCompletedEventArgs e);
            public class SmtpClient : System.IDisposable
            {
                public System.Security.Cryptography.X509Certificates.X509CertificateCollection ClientCertificates { get => throw null; }
                public System.Net.ICredentialsByHost Credentials { get => throw null; set { } }
                public SmtpClient() => throw null;
                public SmtpClient(string host) => throw null;
                public SmtpClient(string host, int port) => throw null;
                public System.Net.Mail.SmtpDeliveryFormat DeliveryFormat { get => throw null; set { } }
                public System.Net.Mail.SmtpDeliveryMethod DeliveryMethod { get => throw null; set { } }
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public bool EnableSsl { get => throw null; set { } }
                public string Host { get => throw null; set { } }
                protected void OnSendCompleted(System.ComponentModel.AsyncCompletedEventArgs e) => throw null;
                public string PickupDirectoryLocation { get => throw null; set { } }
                public int Port { get => throw null; set { } }
                public void Send(System.Net.Mail.MailMessage message) => throw null;
                public void Send(string from, string recipients, string subject, string body) => throw null;
                public void SendAsync(System.Net.Mail.MailMessage message, object userToken) => throw null;
                public void SendAsync(string from, string recipients, string subject, string body, object userToken) => throw null;
                public void SendAsyncCancel() => throw null;
                public event System.Net.Mail.SendCompletedEventHandler SendCompleted;
                public System.Threading.Tasks.Task SendMailAsync(System.Net.Mail.MailMessage message) => throw null;
                public System.Threading.Tasks.Task SendMailAsync(System.Net.Mail.MailMessage message, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task SendMailAsync(string from, string recipients, string subject, string body) => throw null;
                public System.Threading.Tasks.Task SendMailAsync(string from, string recipients, string subject, string body, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Net.ServicePoint ServicePoint { get => throw null; }
                public string TargetName { get => throw null; set { } }
                public int Timeout { get => throw null; set { } }
                public bool UseDefaultCredentials { get => throw null; set { } }
            }
            public enum SmtpDeliveryFormat
            {
                SevenBit = 0,
                International = 1,
            }
            public enum SmtpDeliveryMethod
            {
                Network = 0,
                SpecifiedPickupDirectory = 1,
                PickupDirectoryFromIis = 2,
            }
            public class SmtpException : System.Exception
            {
                public SmtpException() => throw null;
                public SmtpException(System.Net.Mail.SmtpStatusCode statusCode) => throw null;
                public SmtpException(System.Net.Mail.SmtpStatusCode statusCode, string message) => throw null;
                protected SmtpException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                public SmtpException(string message) => throw null;
                public SmtpException(string message, System.Exception innerException) => throw null;
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                public System.Net.Mail.SmtpStatusCode StatusCode { get => throw null; set { } }
            }
            public class SmtpFailedRecipientException : System.Net.Mail.SmtpException
            {
                public SmtpFailedRecipientException() => throw null;
                public SmtpFailedRecipientException(System.Net.Mail.SmtpStatusCode statusCode, string failedRecipient) => throw null;
                public SmtpFailedRecipientException(System.Net.Mail.SmtpStatusCode statusCode, string failedRecipient, string serverResponse) => throw null;
                protected SmtpFailedRecipientException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public SmtpFailedRecipientException(string message) => throw null;
                public SmtpFailedRecipientException(string message, System.Exception innerException) => throw null;
                public SmtpFailedRecipientException(string message, string failedRecipient, System.Exception innerException) => throw null;
                public string FailedRecipient { get => throw null; }
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            }
            public class SmtpFailedRecipientsException : System.Net.Mail.SmtpFailedRecipientException
            {
                public SmtpFailedRecipientsException() => throw null;
                protected SmtpFailedRecipientsException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public SmtpFailedRecipientsException(string message) => throw null;
                public SmtpFailedRecipientsException(string message, System.Exception innerException) => throw null;
                public SmtpFailedRecipientsException(string message, System.Net.Mail.SmtpFailedRecipientException[] innerExceptions) => throw null;
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                public System.Net.Mail.SmtpFailedRecipientException[] InnerExceptions { get => throw null; }
            }
            public enum SmtpStatusCode
            {
                GeneralFailure = -1,
                SystemStatus = 211,
                HelpMessage = 214,
                ServiceReady = 220,
                ServiceClosingTransmissionChannel = 221,
                Ok = 250,
                UserNotLocalWillForward = 251,
                CannotVerifyUserWillAttemptDelivery = 252,
                StartMailInput = 354,
                ServiceNotAvailable = 421,
                MailboxBusy = 450,
                LocalErrorInProcessing = 451,
                InsufficientStorage = 452,
                ClientNotPermitted = 454,
                CommandUnrecognized = 500,
                SyntaxError = 501,
                CommandNotImplemented = 502,
                BadCommandSequence = 503,
                CommandParameterNotImplemented = 504,
                MustIssueStartTlsFirst = 530,
                MailboxUnavailable = 550,
                UserNotLocalTryAlternatePath = 551,
                ExceededStorageAllocation = 552,
                MailboxNameNotAllowed = 553,
                TransactionFailed = 554,
            }
        }
        namespace Mime
        {
            public class ContentDisposition
            {
                public System.DateTime CreationDate { get => throw null; set { } }
                public ContentDisposition() => throw null;
                public ContentDisposition(string disposition) => throw null;
                public string DispositionType { get => throw null; set { } }
                public override bool Equals(object rparam) => throw null;
                public string FileName { get => throw null; set { } }
                public override int GetHashCode() => throw null;
                public bool Inline { get => throw null; set { } }
                public System.DateTime ModificationDate { get => throw null; set { } }
                public System.Collections.Specialized.StringDictionary Parameters { get => throw null; }
                public System.DateTime ReadDate { get => throw null; set { } }
                public long Size { get => throw null; set { } }
                public override string ToString() => throw null;
            }
            public class ContentType
            {
                public string Boundary { get => throw null; set { } }
                public string CharSet { get => throw null; set { } }
                public ContentType() => throw null;
                public ContentType(string contentType) => throw null;
                public override bool Equals(object rparam) => throw null;
                public override int GetHashCode() => throw null;
                public string MediaType { get => throw null; set { } }
                public string Name { get => throw null; set { } }
                public System.Collections.Specialized.StringDictionary Parameters { get => throw null; }
                public override string ToString() => throw null;
            }
            public static class DispositionTypeNames
            {
                public const string Attachment = default;
                public const string Inline = default;
            }
            public static class MediaTypeNames
            {
                public static class Application
                {
                    public const string FormUrlEncoded = default;
                    public const string Json = default;
                    public const string JsonPatch = default;
                    public const string JsonSequence = default;
                    public const string Manifest = default;
                    public const string Octet = default;
                    public const string Pdf = default;
                    public const string ProblemJson = default;
                    public const string ProblemXml = default;
                    public const string Rtf = default;
                    public const string Soap = default;
                    public const string Wasm = default;
                    public const string Xml = default;
                    public const string XmlDtd = default;
                    public const string XmlPatch = default;
                    public const string Zip = default;
                }
                public static class Font
                {
                    public const string Collection = default;
                    public const string Otf = default;
                    public const string Sfnt = default;
                    public const string Ttf = default;
                    public const string Woff = default;
                    public const string Woff2 = default;
                }
                public static class Image
                {
                    public const string Avif = default;
                    public const string Bmp = default;
                    public const string Gif = default;
                    public const string Icon = default;
                    public const string Jpeg = default;
                    public const string Png = default;
                    public const string Svg = default;
                    public const string Tiff = default;
                    public const string Webp = default;
                }
                public static class Multipart
                {
                    public const string ByteRanges = default;
                    public const string FormData = default;
                }
                public static class Text
                {
                    public const string Css = default;
                    public const string Csv = default;
                    public const string Html = default;
                    public const string JavaScript = default;
                    public const string Markdown = default;
                    public const string Plain = default;
                    public const string RichText = default;
                    public const string Rtf = default;
                    public const string Xml = default;
                }
            }
            public enum TransferEncoding
            {
                Unknown = -1,
                QuotedPrintable = 0,
                Base64 = 1,
                SevenBit = 2,
                EightBit = 3,
            }
        }
    }
}
