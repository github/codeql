// This file contains auto-generated code.

namespace System
{
    // Generated from `System.Console` in `System.Console, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public static class Console
    {
        public static System.ConsoleColor BackgroundColor { get => throw null; set => throw null; }
        public static void Beep() => throw null;
        public static void Beep(int frequency, int duration) => throw null;
        public static int BufferHeight { get => throw null; set => throw null; }
        public static int BufferWidth { get => throw null; set => throw null; }
        public static event System.ConsoleCancelEventHandler CancelKeyPress;
        public static bool CapsLock { get => throw null; }
        public static void Clear() => throw null;
        public static int CursorLeft { get => throw null; set => throw null; }
        public static int CursorSize { get => throw null; set => throw null; }
        public static int CursorTop { get => throw null; set => throw null; }
        public static bool CursorVisible { get => throw null; set => throw null; }
        public static System.IO.TextWriter Error { get => throw null; }
        public static System.ConsoleColor ForegroundColor { get => throw null; set => throw null; }
        public static (int, int) GetCursorPosition() => throw null;
        public static System.IO.TextReader In { get => throw null; }
        public static System.Text.Encoding InputEncoding { get => throw null; set => throw null; }
        public static bool IsErrorRedirected { get => throw null; }
        public static bool IsInputRedirected { get => throw null; }
        public static bool IsOutputRedirected { get => throw null; }
        public static bool KeyAvailable { get => throw null; }
        public static int LargestWindowHeight { get => throw null; }
        public static int LargestWindowWidth { get => throw null; }
        public static void MoveBufferArea(int sourceLeft, int sourceTop, int sourceWidth, int sourceHeight, int targetLeft, int targetTop) => throw null;
        public static void MoveBufferArea(int sourceLeft, int sourceTop, int sourceWidth, int sourceHeight, int targetLeft, int targetTop, System.Char sourceChar, System.ConsoleColor sourceForeColor, System.ConsoleColor sourceBackColor) => throw null;
        public static bool NumberLock { get => throw null; }
        public static System.IO.Stream OpenStandardError() => throw null;
        public static System.IO.Stream OpenStandardError(int bufferSize) => throw null;
        public static System.IO.Stream OpenStandardInput() => throw null;
        public static System.IO.Stream OpenStandardInput(int bufferSize) => throw null;
        public static System.IO.Stream OpenStandardOutput() => throw null;
        public static System.IO.Stream OpenStandardOutput(int bufferSize) => throw null;
        public static System.IO.TextWriter Out { get => throw null; }
        public static System.Text.Encoding OutputEncoding { get => throw null; set => throw null; }
        public static int Read() => throw null;
        public static System.ConsoleKeyInfo ReadKey() => throw null;
        public static System.ConsoleKeyInfo ReadKey(bool intercept) => throw null;
        public static string ReadLine() => throw null;
        public static void ResetColor() => throw null;
        public static void SetBufferSize(int width, int height) => throw null;
        public static void SetCursorPosition(int left, int top) => throw null;
        public static void SetError(System.IO.TextWriter newError) => throw null;
        public static void SetIn(System.IO.TextReader newIn) => throw null;
        public static void SetOut(System.IO.TextWriter newOut) => throw null;
        public static void SetWindowPosition(int left, int top) => throw null;
        public static void SetWindowSize(int width, int height) => throw null;
        public static string Title { get => throw null; set => throw null; }
        public static bool TreatControlCAsInput { get => throw null; set => throw null; }
        public static int WindowHeight { get => throw null; set => throw null; }
        public static int WindowLeft { get => throw null; set => throw null; }
        public static int WindowTop { get => throw null; set => throw null; }
        public static int WindowWidth { get => throw null; set => throw null; }
        public static void Write(System.Char[] buffer) => throw null;
        public static void Write(System.Char[] buffer, int index, int count) => throw null;
        public static void Write(bool value) => throw null;
        public static void Write(System.Char value) => throw null;
        public static void Write(System.Decimal value) => throw null;
        public static void Write(double value) => throw null;
        public static void Write(float value) => throw null;
        public static void Write(int value) => throw null;
        public static void Write(System.Int64 value) => throw null;
        public static void Write(object value) => throw null;
        public static void Write(string value) => throw null;
        public static void Write(string format, object arg0) => throw null;
        public static void Write(string format, object arg0, object arg1) => throw null;
        public static void Write(string format, object arg0, object arg1, object arg2) => throw null;
        public static void Write(string format, params object[] arg) => throw null;
        public static void Write(System.UInt32 value) => throw null;
        public static void Write(System.UInt64 value) => throw null;
        public static void WriteLine() => throw null;
        public static void WriteLine(System.Char[] buffer) => throw null;
        public static void WriteLine(System.Char[] buffer, int index, int count) => throw null;
        public static void WriteLine(bool value) => throw null;
        public static void WriteLine(System.Char value) => throw null;
        public static void WriteLine(System.Decimal value) => throw null;
        public static void WriteLine(double value) => throw null;
        public static void WriteLine(float value) => throw null;
        public static void WriteLine(int value) => throw null;
        public static void WriteLine(System.Int64 value) => throw null;
        public static void WriteLine(object value) => throw null;
        public static void WriteLine(string value) => throw null;
        public static void WriteLine(string format, object arg0) => throw null;
        public static void WriteLine(string format, object arg0, object arg1) => throw null;
        public static void WriteLine(string format, object arg0, object arg1, object arg2) => throw null;
        public static void WriteLine(string format, params object[] arg) => throw null;
        public static void WriteLine(System.UInt32 value) => throw null;
        public static void WriteLine(System.UInt64 value) => throw null;
    }

    // Generated from `System.ConsoleCancelEventArgs` in `System.Console, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class ConsoleCancelEventArgs : System.EventArgs
    {
        public bool Cancel { get => throw null; set => throw null; }
        public System.ConsoleSpecialKey SpecialKey { get => throw null; }
    }

    // Generated from `System.ConsoleCancelEventHandler` in `System.Console, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public delegate void ConsoleCancelEventHandler(object sender, System.ConsoleCancelEventArgs e);

    // Generated from `System.ConsoleColor` in `System.Console, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public enum ConsoleColor
    {
        Black,
        Blue,
        Cyan,
        DarkBlue,
        DarkCyan,
        DarkGray,
        DarkGreen,
        DarkMagenta,
        DarkRed,
        DarkYellow,
        Gray,
        Green,
        Magenta,
        Red,
        White,
        Yellow,
    }

    // Generated from `System.ConsoleKey` in `System.Console, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public enum ConsoleKey
    {
        A,
        Add,
        Applications,
        Attention,
        B,
        Backspace,
        BrowserBack,
        BrowserFavorites,
        BrowserForward,
        BrowserHome,
        BrowserRefresh,
        BrowserSearch,
        BrowserStop,
        C,
        Clear,
        CrSel,
        D,
        D0,
        D1,
        D2,
        D3,
        D4,
        D5,
        D6,
        D7,
        D8,
        D9,
        Decimal,
        Delete,
        Divide,
        DownArrow,
        E,
        End,
        Enter,
        EraseEndOfFile,
        Escape,
        ExSel,
        Execute,
        F,
        F1,
        F10,
        F11,
        F12,
        F13,
        F14,
        F15,
        F16,
        F17,
        F18,
        F19,
        F2,
        F20,
        F21,
        F22,
        F23,
        F24,
        F3,
        F4,
        F5,
        F6,
        F7,
        F8,
        F9,
        G,
        H,
        Help,
        Home,
        I,
        Insert,
        J,
        K,
        L,
        LaunchApp1,
        LaunchApp2,
        LaunchMail,
        LaunchMediaSelect,
        LeftArrow,
        LeftWindows,
        M,
        MediaNext,
        MediaPlay,
        MediaPrevious,
        MediaStop,
        Multiply,
        N,
        NoName,
        NumPad0,
        NumPad1,
        NumPad2,
        NumPad3,
        NumPad4,
        NumPad5,
        NumPad6,
        NumPad7,
        NumPad8,
        NumPad9,
        O,
        Oem1,
        Oem102,
        Oem2,
        Oem3,
        Oem4,
        Oem5,
        Oem6,
        Oem7,
        Oem8,
        OemClear,
        OemComma,
        OemMinus,
        OemPeriod,
        OemPlus,
        P,
        Pa1,
        Packet,
        PageDown,
        PageUp,
        Pause,
        Play,
        Print,
        PrintScreen,
        Process,
        Q,
        R,
        RightArrow,
        RightWindows,
        S,
        Select,
        Separator,
        Sleep,
        Spacebar,
        Subtract,
        T,
        Tab,
        U,
        UpArrow,
        V,
        VolumeDown,
        VolumeMute,
        VolumeUp,
        W,
        X,
        Y,
        Z,
        Zoom,
    }

    // Generated from `System.ConsoleKeyInfo` in `System.Console, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public struct ConsoleKeyInfo : System.IEquatable<System.ConsoleKeyInfo>
    {
        public static bool operator !=(System.ConsoleKeyInfo a, System.ConsoleKeyInfo b) => throw null;
        public static bool operator ==(System.ConsoleKeyInfo a, System.ConsoleKeyInfo b) => throw null;
        // Stub generator skipped constructor 
        public ConsoleKeyInfo(System.Char keyChar, System.ConsoleKey key, bool shift, bool alt, bool control) => throw null;
        public bool Equals(System.ConsoleKeyInfo obj) => throw null;
        public override bool Equals(object value) => throw null;
        public override int GetHashCode() => throw null;
        public System.ConsoleKey Key { get => throw null; }
        public System.Char KeyChar { get => throw null; }
        public System.ConsoleModifiers Modifiers { get => throw null; }
    }

    // Generated from `System.ConsoleModifiers` in `System.Console, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    [System.Flags]
    public enum ConsoleModifiers
    {
        Alt,
        Control,
        Shift,
    }

    // Generated from `System.ConsoleSpecialKey` in `System.Console, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public enum ConsoleSpecialKey
    {
        ControlBreak,
        ControlC,
    }

}
