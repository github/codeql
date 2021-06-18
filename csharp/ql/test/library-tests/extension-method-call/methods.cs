using System;

namespace Test
{

    public static class Extensions
    {
        public static void Ext0<T>(this string self, T arg) { }

        public static void Ext1(this string self, int arg) { }

        public static void Ext2<T>(this T self, int arg) { }

        public static void Ext3<T>(this T self, int arg) { self.Ext3(arg); }

        public static void Ext4<T>(this T self, int arg) { Ext4(self, arg); }
    }

    public class Program
    {
        public static void M()
        {
            "".Ext0(1);
            "".Ext0<int>(1);
            "".Ext0<double>(1);
            "".Ext0<object>(null);
            Extensions.Ext0("", 1);
            Extensions.Ext0<int>("", 1);
            Extensions.Ext0<double>("", 1);
            Extensions.Ext0<object>("", null);

            "".Ext1(1);
            Extensions.Ext1("", 1);

            1.Ext2(1);
            1.Ext2<int>(1);
            "".Ext2(1);
            "".Ext2<string>(1);
            "".Ext2<object>(1);
            Extensions.Ext2(1, 1);
            Extensions.Ext2<int>(1, 1);
            Extensions.Ext2("", 1);
            Extensions.Ext2<string>("", 1);
            Extensions.Ext2<object>("", 1);
        }
    }
}
