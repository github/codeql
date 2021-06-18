// This file contains auto-generated code.

namespace System
{
    namespace Media
    {
        // Generated from `System.Media.SoundPlayer` in `System.Windows.Extensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SoundPlayer : System.ComponentModel.Component, System.Runtime.Serialization.ISerializable
        {
            void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public bool IsLoadCompleted { get => throw null; }
            public void Load() => throw null;
            public void LoadAsync() => throw null;
            public event System.ComponentModel.AsyncCompletedEventHandler LoadCompleted;
            public int LoadTimeout { get => throw null; set => throw null; }
            protected virtual void OnLoadCompleted(System.ComponentModel.AsyncCompletedEventArgs e) => throw null;
            protected virtual void OnSoundLocationChanged(System.EventArgs e) => throw null;
            protected virtual void OnStreamChanged(System.EventArgs e) => throw null;
            public void Play() => throw null;
            public void PlayLooping() => throw null;
            public void PlaySync() => throw null;
            public string SoundLocation { get => throw null; set => throw null; }
            public event System.EventHandler SoundLocationChanged;
            public SoundPlayer(string soundLocation) => throw null;
            public SoundPlayer(System.IO.Stream stream) => throw null;
            public SoundPlayer() => throw null;
            protected SoundPlayer(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext context) => throw null;
            public void Stop() => throw null;
            public System.IO.Stream Stream { get => throw null; set => throw null; }
            public event System.EventHandler StreamChanged;
            public object Tag { get => throw null; set => throw null; }
        }

        // Generated from `System.Media.SystemSound` in `System.Windows.Extensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SystemSound
        {
            public void Play() => throw null;
        }

        // Generated from `System.Media.SystemSounds` in `System.Windows.Extensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public static class SystemSounds
        {
            public static System.Media.SystemSound Asterisk { get => throw null; }
            public static System.Media.SystemSound Beep { get => throw null; }
            public static System.Media.SystemSound Exclamation { get => throw null; }
            public static System.Media.SystemSound Hand { get => throw null; }
            public static System.Media.SystemSound Question { get => throw null; }
        }

    }
    namespace Runtime
    {
        namespace Versioning
        {
            /* Duplicate type 'OSPlatformAttribute' is not stubbed in this assembly 'System.Windows.Extensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

            /* Duplicate type 'SupportedOSPlatformAttribute' is not stubbed in this assembly 'System.Windows.Extensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

            /* Duplicate type 'TargetPlatformAttribute' is not stubbed in this assembly 'System.Windows.Extensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

            /* Duplicate type 'UnsupportedOSPlatformAttribute' is not stubbed in this assembly 'System.Windows.Extensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. */

        }
    }
    namespace Security
    {
        namespace Cryptography
        {
            namespace X509Certificates
            {
                // Generated from `System.Security.Cryptography.X509Certificates.X509Certificate2UI` in `System.Windows.Extensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class X509Certificate2UI
                {
                    public static void DisplayCertificate(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, System.IntPtr hwndParent) => throw null;
                    public static void DisplayCertificate(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509Certificate2Collection SelectFromCollection(System.Security.Cryptography.X509Certificates.X509Certificate2Collection certificates, string title, string message, System.Security.Cryptography.X509Certificates.X509SelectionFlag selectionFlag, System.IntPtr hwndParent) => throw null;
                    public static System.Security.Cryptography.X509Certificates.X509Certificate2Collection SelectFromCollection(System.Security.Cryptography.X509Certificates.X509Certificate2Collection certificates, string title, string message, System.Security.Cryptography.X509Certificates.X509SelectionFlag selectionFlag) => throw null;
                    public X509Certificate2UI() => throw null;
                }

                // Generated from `System.Security.Cryptography.X509Certificates.X509SelectionFlag` in `System.Windows.Extensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public enum X509SelectionFlag
                {
                    MultiSelection,
                    SingleSelection,
                }

            }
        }
    }
    namespace Xaml
    {
        namespace Permissions
        {
            // Generated from `System.Xaml.Permissions.XamlAccessLevel` in `System.Windows.Extensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class XamlAccessLevel
            {
                public static System.Xaml.Permissions.XamlAccessLevel AssemblyAccessTo(System.Reflection.AssemblyName assemblyName) => throw null;
                public static System.Xaml.Permissions.XamlAccessLevel AssemblyAccessTo(System.Reflection.Assembly assembly) => throw null;
                public System.Reflection.AssemblyName AssemblyAccessToAssemblyName { get => throw null; }
                public static System.Xaml.Permissions.XamlAccessLevel PrivateAccessTo(string assemblyQualifiedTypeName) => throw null;
                public static System.Xaml.Permissions.XamlAccessLevel PrivateAccessTo(System.Type type) => throw null;
                public string PrivateAccessToTypeName { get => throw null; }
            }

        }
    }
}
