// This file contains auto-generated code.

namespace System
{
    namespace Net
    {
        namespace Mail
        {
            // Generated from `System.Net.Mail.AlternateView` in `System.Net.Mail, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class AlternateView : System.Net.Mail.AttachmentBase
            {
                public AlternateView(System.IO.Stream contentStream) : base(default(System.IO.Stream)) => throw null;
                public AlternateView(System.IO.Stream contentStream, System.Net.Mime.ContentType contentType) : base(default(System.IO.Stream)) => throw null;
                public AlternateView(System.IO.Stream contentStream, string mediaType) : base(default(System.IO.Stream)) => throw null;
                public AlternateView(string fileName) : base(default(System.IO.Stream)) => throw null;
                public AlternateView(string fileName, System.Net.Mime.ContentType contentType) : base(default(System.IO.Stream)) => throw null;
                public AlternateView(string fileName, string mediaType) : base(default(System.IO.Stream)) => throw null;
                public System.Uri BaseUri { get => throw null; set => throw null; }
                public static System.Net.Mail.AlternateView CreateAlternateViewFromString(string content) => throw null;
                public static System.Net.Mail.AlternateView CreateAlternateViewFromString(string content, System.Net.Mime.ContentType contentType) => throw null;
                public static System.Net.Mail.AlternateView CreateAlternateViewFromString(string content, System.Text.Encoding contentEncoding, string mediaType) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                public System.Net.Mail.LinkedResourceCollection LinkedResources { get => throw null; }
            }

            // Generated from `System.Net.Mail.AlternateViewCollection` in `System.Net.Mail, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class AlternateViewCollection : System.Collections.ObjectModel.Collection<System.Net.Mail.AlternateView>, System.IDisposable
            {
                protected override void ClearItems() => throw null;
                public void Dispose() => throw null;
                protected override void InsertItem(int index, System.Net.Mail.AlternateView item) => throw null;
                protected override void RemoveItem(int index) => throw null;
                protected override void SetItem(int index, System.Net.Mail.AlternateView item) => throw null;
            }

            // Generated from `System.Net.Mail.Attachment` in `System.Net.Mail, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class Attachment : System.Net.Mail.AttachmentBase
            {
                public Attachment(System.IO.Stream contentStream, System.Net.Mime.ContentType contentType) : base(default(System.IO.Stream)) => throw null;
                public Attachment(System.IO.Stream contentStream, string name) : base(default(System.IO.Stream)) => throw null;
                public Attachment(System.IO.Stream contentStream, string name, string mediaType) : base(default(System.IO.Stream)) => throw null;
                public Attachment(string fileName) : base(default(System.IO.Stream)) => throw null;
                public Attachment(string fileName, System.Net.Mime.ContentType contentType) : base(default(System.IO.Stream)) => throw null;
                public Attachment(string fileName, string mediaType) : base(default(System.IO.Stream)) => throw null;
                public System.Net.Mime.ContentDisposition ContentDisposition { get => throw null; }
                public static System.Net.Mail.Attachment CreateAttachmentFromString(string content, System.Net.Mime.ContentType contentType) => throw null;
                public static System.Net.Mail.Attachment CreateAttachmentFromString(string content, string name) => throw null;
                public static System.Net.Mail.Attachment CreateAttachmentFromString(string content, string name, System.Text.Encoding contentEncoding, string mediaType) => throw null;
                public string Name { get => throw null; set => throw null; }
                public System.Text.Encoding NameEncoding { get => throw null; set => throw null; }
            }

            // Generated from `System.Net.Mail.AttachmentBase` in `System.Net.Mail, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public abstract class AttachmentBase : System.IDisposable
            {
                protected AttachmentBase(System.IO.Stream contentStream) => throw null;
                protected AttachmentBase(System.IO.Stream contentStream, System.Net.Mime.ContentType contentType) => throw null;
                protected AttachmentBase(System.IO.Stream contentStream, string mediaType) => throw null;
                protected AttachmentBase(string fileName) => throw null;
                protected AttachmentBase(string fileName, System.Net.Mime.ContentType contentType) => throw null;
                protected AttachmentBase(string fileName, string mediaType) => throw null;
                public string ContentId { get => throw null; set => throw null; }
                public System.IO.Stream ContentStream { get => throw null; }
                public System.Net.Mime.ContentType ContentType { get => throw null; set => throw null; }
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public System.Net.Mime.TransferEncoding TransferEncoding { get => throw null; set => throw null; }
            }

            // Generated from `System.Net.Mail.AttachmentCollection` in `System.Net.Mail, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class AttachmentCollection : System.Collections.ObjectModel.Collection<System.Net.Mail.Attachment>, System.IDisposable
            {
                protected override void ClearItems() => throw null;
                public void Dispose() => throw null;
                protected override void InsertItem(int index, System.Net.Mail.Attachment item) => throw null;
                protected override void RemoveItem(int index) => throw null;
                protected override void SetItem(int index, System.Net.Mail.Attachment item) => throw null;
            }

            // Generated from `System.Net.Mail.DeliveryNotificationOptions` in `System.Net.Mail, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            [System.Flags]
            public enum DeliveryNotificationOptions
            {
                Delay,
                Never,
                None,
                OnFailure,
                OnSuccess,
            }

            // Generated from `System.Net.Mail.LinkedResource` in `System.Net.Mail, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class LinkedResource : System.Net.Mail.AttachmentBase
            {
                public System.Uri ContentLink { get => throw null; set => throw null; }
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

            // Generated from `System.Net.Mail.LinkedResourceCollection` in `System.Net.Mail, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class LinkedResourceCollection : System.Collections.ObjectModel.Collection<System.Net.Mail.LinkedResource>, System.IDisposable
            {
                protected override void ClearItems() => throw null;
                public void Dispose() => throw null;
                protected override void InsertItem(int index, System.Net.Mail.LinkedResource item) => throw null;
                protected override void RemoveItem(int index) => throw null;
                protected override void SetItem(int index, System.Net.Mail.LinkedResource item) => throw null;
            }

            // Generated from `System.Net.Mail.MailAddress` in `System.Net.Mail, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class MailAddress
            {
                public string Address { get => throw null; }
                public string DisplayName { get => throw null; }
                public override bool Equals(object value) => throw null;
                public override int GetHashCode() => throw null;
                public string Host { get => throw null; }
                public MailAddress(string address) => throw null;
                public MailAddress(string address, string displayName) => throw null;
                public MailAddress(string address, string displayName, System.Text.Encoding displayNameEncoding) => throw null;
                public override string ToString() => throw null;
                public static bool TryCreate(string address, out System.Net.Mail.MailAddress result) => throw null;
                public static bool TryCreate(string address, string displayName, System.Text.Encoding displayNameEncoding, out System.Net.Mail.MailAddress result) => throw null;
                public static bool TryCreate(string address, string displayName, out System.Net.Mail.MailAddress result) => throw null;
                public string User { get => throw null; }
            }

            // Generated from `System.Net.Mail.MailAddressCollection` in `System.Net.Mail, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class MailAddressCollection : System.Collections.ObjectModel.Collection<System.Net.Mail.MailAddress>
            {
                public void Add(string addresses) => throw null;
                protected override void InsertItem(int index, System.Net.Mail.MailAddress item) => throw null;
                public MailAddressCollection() => throw null;
                protected override void SetItem(int index, System.Net.Mail.MailAddress item) => throw null;
                public override string ToString() => throw null;
            }

            // Generated from `System.Net.Mail.MailMessage` in `System.Net.Mail, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class MailMessage : System.IDisposable
            {
                public System.Net.Mail.AlternateViewCollection AlternateViews { get => throw null; }
                public System.Net.Mail.AttachmentCollection Attachments { get => throw null; }
                public System.Net.Mail.MailAddressCollection Bcc { get => throw null; }
                public string Body { get => throw null; set => throw null; }
                public System.Text.Encoding BodyEncoding { get => throw null; set => throw null; }
                public System.Net.Mime.TransferEncoding BodyTransferEncoding { get => throw null; set => throw null; }
                public System.Net.Mail.MailAddressCollection CC { get => throw null; }
                public System.Net.Mail.DeliveryNotificationOptions DeliveryNotificationOptions { get => throw null; set => throw null; }
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public System.Net.Mail.MailAddress From { get => throw null; set => throw null; }
                public System.Collections.Specialized.NameValueCollection Headers { get => throw null; }
                public System.Text.Encoding HeadersEncoding { get => throw null; set => throw null; }
                public bool IsBodyHtml { get => throw null; set => throw null; }
                public MailMessage() => throw null;
                public MailMessage(System.Net.Mail.MailAddress from, System.Net.Mail.MailAddress to) => throw null;
                public MailMessage(string from, string to) => throw null;
                public MailMessage(string from, string to, string subject, string body) => throw null;
                public System.Net.Mail.MailPriority Priority { get => throw null; set => throw null; }
                public System.Net.Mail.MailAddress ReplyTo { get => throw null; set => throw null; }
                public System.Net.Mail.MailAddressCollection ReplyToList { get => throw null; }
                public System.Net.Mail.MailAddress Sender { get => throw null; set => throw null; }
                public string Subject { get => throw null; set => throw null; }
                public System.Text.Encoding SubjectEncoding { get => throw null; set => throw null; }
                public System.Net.Mail.MailAddressCollection To { get => throw null; }
            }

            // Generated from `System.Net.Mail.MailPriority` in `System.Net.Mail, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum MailPriority
            {
                High,
                Low,
                Normal,
            }

            // Generated from `System.Net.Mail.SendCompletedEventHandler` in `System.Net.Mail, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public delegate void SendCompletedEventHandler(object sender, System.ComponentModel.AsyncCompletedEventArgs e);

            // Generated from `System.Net.Mail.SmtpClient` in `System.Net.Mail, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class SmtpClient : System.IDisposable
            {
                public System.Security.Cryptography.X509Certificates.X509CertificateCollection ClientCertificates { get => throw null; }
                public System.Net.ICredentialsByHost Credentials { get => throw null; set => throw null; }
                public System.Net.Mail.SmtpDeliveryFormat DeliveryFormat { get => throw null; set => throw null; }
                public System.Net.Mail.SmtpDeliveryMethod DeliveryMethod { get => throw null; set => throw null; }
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public bool EnableSsl { get => throw null; set => throw null; }
                public string Host { get => throw null; set => throw null; }
                protected void OnSendCompleted(System.ComponentModel.AsyncCompletedEventArgs e) => throw null;
                public string PickupDirectoryLocation { get => throw null; set => throw null; }
                public int Port { get => throw null; set => throw null; }
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
                public SmtpClient() => throw null;
                public SmtpClient(string host) => throw null;
                public SmtpClient(string host, int port) => throw null;
                public string TargetName { get => throw null; set => throw null; }
                public int Timeout { get => throw null; set => throw null; }
                public bool UseDefaultCredentials { get => throw null; set => throw null; }
            }

            // Generated from `System.Net.Mail.SmtpDeliveryFormat` in `System.Net.Mail, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum SmtpDeliveryFormat
            {
                International,
                SevenBit,
            }

            // Generated from `System.Net.Mail.SmtpDeliveryMethod` in `System.Net.Mail, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum SmtpDeliveryMethod
            {
                Network,
                PickupDirectoryFromIis,
                SpecifiedPickupDirectory,
            }

            // Generated from `System.Net.Mail.SmtpException` in `System.Net.Mail, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class SmtpException : System.Exception, System.Runtime.Serialization.ISerializable
            {
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                public SmtpException() => throw null;
                protected SmtpException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                public SmtpException(System.Net.Mail.SmtpStatusCode statusCode) => throw null;
                public SmtpException(System.Net.Mail.SmtpStatusCode statusCode, string message) => throw null;
                public SmtpException(string message) => throw null;
                public SmtpException(string message, System.Exception innerException) => throw null;
                public System.Net.Mail.SmtpStatusCode StatusCode { get => throw null; set => throw null; }
            }

            // Generated from `System.Net.Mail.SmtpFailedRecipientException` in `System.Net.Mail, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class SmtpFailedRecipientException : System.Net.Mail.SmtpException, System.Runtime.Serialization.ISerializable
            {
                public string FailedRecipient { get => throw null; }
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                public SmtpFailedRecipientException() => throw null;
                protected SmtpFailedRecipientException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public SmtpFailedRecipientException(System.Net.Mail.SmtpStatusCode statusCode, string failedRecipient) => throw null;
                public SmtpFailedRecipientException(System.Net.Mail.SmtpStatusCode statusCode, string failedRecipient, string serverResponse) => throw null;
                public SmtpFailedRecipientException(string message) => throw null;
                public SmtpFailedRecipientException(string message, System.Exception innerException) => throw null;
                public SmtpFailedRecipientException(string message, string failedRecipient, System.Exception innerException) => throw null;
            }

            // Generated from `System.Net.Mail.SmtpFailedRecipientsException` in `System.Net.Mail, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class SmtpFailedRecipientsException : System.Net.Mail.SmtpFailedRecipientException, System.Runtime.Serialization.ISerializable
            {
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                public System.Net.Mail.SmtpFailedRecipientException[] InnerExceptions { get => throw null; }
                public SmtpFailedRecipientsException() => throw null;
                protected SmtpFailedRecipientsException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public SmtpFailedRecipientsException(string message) => throw null;
                public SmtpFailedRecipientsException(string message, System.Exception innerException) => throw null;
                public SmtpFailedRecipientsException(string message, System.Net.Mail.SmtpFailedRecipientException[] innerExceptions) => throw null;
            }

            // Generated from `System.Net.Mail.SmtpStatusCode` in `System.Net.Mail, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum SmtpStatusCode
            {
                BadCommandSequence,
                CannotVerifyUserWillAttemptDelivery,
                ClientNotPermitted,
                CommandNotImplemented,
                CommandParameterNotImplemented,
                CommandUnrecognized,
                ExceededStorageAllocation,
                GeneralFailure,
                HelpMessage,
                InsufficientStorage,
                LocalErrorInProcessing,
                MailboxBusy,
                MailboxNameNotAllowed,
                MailboxUnavailable,
                MustIssueStartTlsFirst,
                Ok,
                ServiceClosingTransmissionChannel,
                ServiceNotAvailable,
                ServiceReady,
                StartMailInput,
                SyntaxError,
                SystemStatus,
                TransactionFailed,
                UserNotLocalTryAlternatePath,
                UserNotLocalWillForward,
            }

        }
        namespace Mime
        {
            // Generated from `System.Net.Mime.ContentDisposition` in `System.Net.Mail, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class ContentDisposition
            {
                public ContentDisposition() => throw null;
                public ContentDisposition(string disposition) => throw null;
                public System.DateTime CreationDate { get => throw null; set => throw null; }
                public string DispositionType { get => throw null; set => throw null; }
                public override bool Equals(object rparam) => throw null;
                public string FileName { get => throw null; set => throw null; }
                public override int GetHashCode() => throw null;
                public bool Inline { get => throw null; set => throw null; }
                public System.DateTime ModificationDate { get => throw null; set => throw null; }
                public System.Collections.Specialized.StringDictionary Parameters { get => throw null; }
                public System.DateTime ReadDate { get => throw null; set => throw null; }
                public System.Int64 Size { get => throw null; set => throw null; }
                public override string ToString() => throw null;
            }

            // Generated from `System.Net.Mime.ContentType` in `System.Net.Mail, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class ContentType
            {
                public string Boundary { get => throw null; set => throw null; }
                public string CharSet { get => throw null; set => throw null; }
                public ContentType() => throw null;
                public ContentType(string contentType) => throw null;
                public override bool Equals(object rparam) => throw null;
                public override int GetHashCode() => throw null;
                public string MediaType { get => throw null; set => throw null; }
                public string Name { get => throw null; set => throw null; }
                public System.Collections.Specialized.StringDictionary Parameters { get => throw null; }
                public override string ToString() => throw null;
            }

            // Generated from `System.Net.Mime.DispositionTypeNames` in `System.Net.Mail, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public static class DispositionTypeNames
            {
                public const string Attachment = default;
                public const string Inline = default;
            }

            // Generated from `System.Net.Mime.MediaTypeNames` in `System.Net.Mail, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public static class MediaTypeNames
            {
                // Generated from `System.Net.Mime.MediaTypeNames+Application` in `System.Net.Mail, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public static class Application
                {
                    public const string Json = default;
                    public const string Octet = default;
                    public const string Pdf = default;
                    public const string Rtf = default;
                    public const string Soap = default;
                    public const string Xml = default;
                    public const string Zip = default;
                }


                // Generated from `System.Net.Mime.MediaTypeNames+Image` in `System.Net.Mail, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public static class Image
                {
                    public const string Gif = default;
                    public const string Jpeg = default;
                    public const string Tiff = default;
                }


                // Generated from `System.Net.Mime.MediaTypeNames+Text` in `System.Net.Mail, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public static class Text
                {
                    public const string Html = default;
                    public const string Plain = default;
                    public const string RichText = default;
                    public const string Xml = default;
                }


            }

            // Generated from `System.Net.Mime.TransferEncoding` in `System.Net.Mail, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum TransferEncoding
            {
                Base64,
                EightBit,
                QuotedPrintable,
                SevenBit,
                Unknown,
            }

        }
    }
}
