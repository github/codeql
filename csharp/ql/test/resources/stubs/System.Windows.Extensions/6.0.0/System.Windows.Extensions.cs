// This file contains auto-generated code.
// Generated from `System.Windows.Extensions, Version=6.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`.
namespace System
{
    namespace Media
    {
        public class SoundPlayer : System.ComponentModel.Component, System.Runtime.Serialization.ISerializable
        {
            public SoundPlayer() => throw null;
            public SoundPlayer(System.IO.Stream stream) => throw null;
            protected SoundPlayer(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext context) => throw null;
            public SoundPlayer(string soundLocation) => throw null;
            void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public bool IsLoadCompleted { get => throw null; }
            public void Load() => throw null;
            public void LoadAsync() => throw null;
            public event System.ComponentModel.AsyncCompletedEventHandler LoadCompleted;
            public int LoadTimeout { get => throw null; set { } }
            protected virtual void OnLoadCompleted(System.ComponentModel.AsyncCompletedEventArgs e) => throw null;
            protected virtual void OnSoundLocationChanged(System.EventArgs e) => throw null;
            protected virtual void OnStreamChanged(System.EventArgs e) => throw null;
            public void Play() => throw null;
            public void PlayLooping() => throw null;
            public void PlaySync() => throw null;
            public string SoundLocation { get => throw null; set { } }
            public event System.EventHandler SoundLocationChanged;
            public void Stop() => throw null;
            public System.IO.Stream Stream { get => throw null; set { } }
            public event System.EventHandler StreamChanged;
            public object Tag { get => throw null; set { } }
        }
        public class SystemSound
        {
            public void Play() => throw null;
        }
        public static class SystemSounds
        {
            public static System.Media.SystemSound Asterisk { get => throw null; }
            public static System.Media.SystemSound Beep { get => throw null; }
            public static System.Media.SystemSound Exclamation { get => throw null; }
            public static System.Media.SystemSound Hand { get => throw null; }
            public static System.Media.SystemSound Question { get => throw null; }
        }
    }
    namespace Security
    {
        namespace Cryptography
        {
            namespace X509Certificates
            {
                public sealed class X509Certificate2UI
                {
                    public X509Certificate2UI() => throw null;
                    public static void DisplayCertificate(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public static void DisplayCertificate(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, nint hwndParent) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509Certificate2Collection SelectFromCollection(System.Security.Cryptography.X509Certificates.X509Certificate2Collection certificates, string title, string message, System.Security.Cryptography.X509Certificates.X509SelectionFlag selectionFlag) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509Certificate2Collection SelectFromCollection(System.Security.Cryptography.X509Certificates.X509Certificate2Collection certificates, string title, string message, System.Security.Cryptography.X509Certificates.X509SelectionFlag selectionFlag, nint hwndParent) => throw null;
                }
                public enum X509SelectionFlag
                {
                    SingleSelection = 0,
                    MultiSelection = 1,
                }
            }
        }
    }
    namespace Xaml
    {
        namespace Permissions
        {
            public class XamlAccessLevel
            {
                public static System.Xaml.Permissions.XamlAccessLevel AssemblyAccessTo(System.Reflection.Assembly assembly) => throw null;
                public static System.Xaml.Permissions.XamlAccessLevel AssemblyAccessTo(System.Reflection.AssemblyName assemblyName) => throw null;
                public System.Reflection.AssemblyName AssemblyAccessToAssemblyName { get => throw null; }
                public static System.Xaml.Permissions.XamlAccessLevel PrivateAccessTo(string assemblyQualifiedTypeName) => throw null;
                public static System.Xaml.Permissions.XamlAccessLevel PrivateAccessTo(System.Type type) => throw null;
                public string PrivateAccessToTypeName { get => throw null; }
            }
        }
    }
}
