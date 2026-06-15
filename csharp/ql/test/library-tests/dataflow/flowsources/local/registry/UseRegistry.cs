using Microsoft.Win32;

namespace Test
{
    class UseRegistry
    {
        public static void GetRegistryValue(string keyName, string valueName)
        {
            RegistryKey key = Registry.LocalMachine.OpenSubKey(keyName);
            string value = (string)key.GetValue(valueName);
        }

        public static void GetRegistryValue2(string keyName, string valueName)
        {
            RegistryKey key = Registry.CurrentUser.OpenSubKey(keyName);
            string value = (string)key.GetValue(valueName);
        }

        public static void GetRegistryValue3(string keyName, string valueName)
        {
            RegistryKey key = Registry.ClassesRoot.OpenSubKey(keyName);
            string value = (string)key.GetValue(valueName);
        }

        public static void GetRegistryValue4(string keyName, string valueName)
        {
            RegistryKey key = Registry.Users.OpenSubKey(keyName);
            string value = (string)key.GetValue(valueName);
        }

        public static void GetRegistryValue5(string keyName, string valueName)
        {
            RegistryKey key = Registry.CurrentConfig.OpenSubKey(keyName);
            string value = (string)key.GetValue(valueName);
        }

        public static void GetRegistryValue6(string keyName, string valueName)
        {
            RegistryKey key = Registry.PerformanceData.OpenSubKey(keyName);
            string value = (string)key.GetValue(valueName);
        }

        public static void GetRegistryValueNames(string keyName, string valueName)
        {
            RegistryKey key = Registry.LocalMachine.OpenSubKey(keyName);
            string[] valueNames = key.GetValueNames();
        }

        public static void GetRegistrySubKeyNames(string keyName, string valueName)
        {
            RegistryKey key = Registry.LocalMachine.OpenSubKey(keyName);
            string[] subKeyNames = key.GetSubKeyNames();
        }
    }
}