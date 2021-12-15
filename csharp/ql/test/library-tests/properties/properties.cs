using System;
using System.IO;
using System.Collections.Generic;

namespace Properties
{
    public class Button
    {

        private string caption;

        public string Caption
        {

            get { return caption; }

            set
            {
                if (caption != value)
                {
                    caption = value;
                }
            }
        }

        public void Paint()
        {
            Button okButton = new Button();
            okButton.Caption = "OK";  // Invokes set accessor
            string s = okButton.Caption;  // Invokes get accessor
        }
    }

    class Counter
    {

        private int next;

        public int Next
        {  //bad style but correct
            get { return next++; }
        }

    }

    public class Point
    {

        public int X { get; set; } // automatically implemented
        public int Y { get; set; } // automatically implemented

    }

    public class ReadOnlyPoint
    {

        public int X { get; private set; }
        public int Y { get; private set; }
        public ReadOnlyPoint(int x, int y)
        {
            X = x;
            Y = y;
        }

    }

    public abstract class A
    {
        int y;
        public virtual int X { get { return 0; } }
        public virtual int Y
        {
            get { return y; }
            set { y = value; }
        }
        public abstract int Z { get; set; }
    }

    class B : A
    {
        int z;
        public override int X { get { return base.X + 1; } }
        public override int Y { set { base.Y = value < 0 ? 0 : value; } }
        public override int Z
        {
            get { return z; }
            set { z = value; }
        }
    }

    class Test
    {
        private static int Init { set { } }
        void Main()
        {
            List<double> ds = new List<double>();
            List<object> os = new List<object>();
            if (ds.Count == os.Count)
            {
            }
        }
    }

    interface InterfaceWithProperties
    {
        int Prop1 { get; }
        int Prop2 { set; }
    }

    class ImplementsProperties : InterfaceWithProperties
    {
        public int Prop1
        {
            get { return 0; }
        }

        public int Prop2
        {
            set { }
        }

        int InterfaceWithProperties.Prop2
        {
            set { }
        }
    }
}
