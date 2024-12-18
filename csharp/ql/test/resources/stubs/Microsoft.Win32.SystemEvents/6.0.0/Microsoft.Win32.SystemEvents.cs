// This file contains auto-generated code.
// Generated from `Microsoft.Win32.SystemEvents, Version=6.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`.
namespace Microsoft
{
    namespace Win32
    {
        public class PowerModeChangedEventArgs : System.EventArgs
        {
            public PowerModeChangedEventArgs(Microsoft.Win32.PowerModes mode) => throw null;
            public Microsoft.Win32.PowerModes Mode { get => throw null; }
        }
        public delegate void PowerModeChangedEventHandler(object sender, Microsoft.Win32.PowerModeChangedEventArgs e);
        public enum PowerModes
        {
            Resume = 1,
            StatusChange = 2,
            Suspend = 3,
        }
        public class SessionEndedEventArgs : System.EventArgs
        {
            public SessionEndedEventArgs(Microsoft.Win32.SessionEndReasons reason) => throw null;
            public Microsoft.Win32.SessionEndReasons Reason { get => throw null; }
        }
        public delegate void SessionEndedEventHandler(object sender, Microsoft.Win32.SessionEndedEventArgs e);
        public class SessionEndingEventArgs : System.EventArgs
        {
            public bool Cancel { get => throw null; set { } }
            public SessionEndingEventArgs(Microsoft.Win32.SessionEndReasons reason) => throw null;
            public Microsoft.Win32.SessionEndReasons Reason { get => throw null; }
        }
        public delegate void SessionEndingEventHandler(object sender, Microsoft.Win32.SessionEndingEventArgs e);
        public enum SessionEndReasons
        {
            Logoff = 1,
            SystemShutdown = 2,
        }
        public class SessionSwitchEventArgs : System.EventArgs
        {
            public SessionSwitchEventArgs(Microsoft.Win32.SessionSwitchReason reason) => throw null;
            public Microsoft.Win32.SessionSwitchReason Reason { get => throw null; }
        }
        public delegate void SessionSwitchEventHandler(object sender, Microsoft.Win32.SessionSwitchEventArgs e);
        public enum SessionSwitchReason
        {
            ConsoleConnect = 1,
            ConsoleDisconnect = 2,
            RemoteConnect = 3,
            RemoteDisconnect = 4,
            SessionLogon = 5,
            SessionLogoff = 6,
            SessionLock = 7,
            SessionUnlock = 8,
            SessionRemoteControl = 9,
        }
        public sealed class SystemEvents
        {
            public static nint CreateTimer(int interval) => throw null;
            public static event System.EventHandler DisplaySettingsChanged;
            public static event System.EventHandler DisplaySettingsChanging;
            public static event System.EventHandler EventsThreadShutdown;
            public static event System.EventHandler InstalledFontsChanged;
            public static void InvokeOnEventsThread(System.Delegate method) => throw null;
            public static void KillTimer(nint timerId) => throw null;
            public static event System.EventHandler LowMemory;
            public static event System.EventHandler PaletteChanged;
            public static event Microsoft.Win32.PowerModeChangedEventHandler PowerModeChanged;
            public static event Microsoft.Win32.SessionEndedEventHandler SessionEnded;
            public static event Microsoft.Win32.SessionEndingEventHandler SessionEnding;
            public static event Microsoft.Win32.SessionSwitchEventHandler SessionSwitch;
            public static event System.EventHandler TimeChanged;
            public static event Microsoft.Win32.TimerElapsedEventHandler TimerElapsed;
            public static event Microsoft.Win32.UserPreferenceChangedEventHandler UserPreferenceChanged;
            public static event Microsoft.Win32.UserPreferenceChangingEventHandler UserPreferenceChanging;
        }
        public class TimerElapsedEventArgs : System.EventArgs
        {
            public TimerElapsedEventArgs(nint timerId) => throw null;
            public nint TimerId { get => throw null; }
        }
        public delegate void TimerElapsedEventHandler(object sender, Microsoft.Win32.TimerElapsedEventArgs e);
        public enum UserPreferenceCategory
        {
            Accessibility = 1,
            Color = 2,
            Desktop = 3,
            General = 4,
            Icon = 5,
            Keyboard = 6,
            Menu = 7,
            Mouse = 8,
            Policy = 9,
            Power = 10,
            Screensaver = 11,
            Window = 12,
            Locale = 13,
            VisualStyle = 14,
        }
        public class UserPreferenceChangedEventArgs : System.EventArgs
        {
            public Microsoft.Win32.UserPreferenceCategory Category { get => throw null; }
            public UserPreferenceChangedEventArgs(Microsoft.Win32.UserPreferenceCategory category) => throw null;
        }
        public delegate void UserPreferenceChangedEventHandler(object sender, Microsoft.Win32.UserPreferenceChangedEventArgs e);
        public class UserPreferenceChangingEventArgs : System.EventArgs
        {
            public Microsoft.Win32.UserPreferenceCategory Category { get => throw null; }
            public UserPreferenceChangingEventArgs(Microsoft.Win32.UserPreferenceCategory category) => throw null;
        }
        public delegate void UserPreferenceChangingEventHandler(object sender, Microsoft.Win32.UserPreferenceChangingEventArgs e);
    }
}
