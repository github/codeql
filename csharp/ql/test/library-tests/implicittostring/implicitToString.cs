using System;

public class TestImplicitToString
{
    public class Container
    {
        public override string ToString()
        {
            return "Container";
        }
    }

    public class Container2 : Container { }

    public class Container3 { }

    public class FormattableContainer : IFormattable
    {
        public string ToString(string format, IFormatProvider formatProvider)
        {
            return "Formatted container";
        }


        public override string ToString()
        {
            return "Container";
        }
    }

    public void M()
    {
        var container = new Container();

        var y = "Hello" + container; // Implicit ToString call
        y = "Hello" + container.ToString();
        y = $"Hello {container}"; // Implicit ToString() call
        y = $"Hello {container.ToString()}";
        y = $"Hello {container:D}"; // Implicit ToString() call.

        var z = "Hello" + y; // No implicit ToString call as `y` is already a string.

        var formattableContainer = new FormattableContainer();
        y = "Hello" + formattableContainer; // Implicit call to ToString().
        y = $"Hello {formattableContainer}"; // Implicit call to ToString(string, IFormatProvider). We don't handle this.
        y = $"Hello {formattableContainer:D}"; // Implicit call to ToString(string, IFormatProvider). We don't handle this.

        var container2 = new Container2();
        y = "Hello" + container2; // Implicit Container.ToString call.

        var container3 = new Container3();
        y = "Hello" + container3; // Implicit Object.ToString call.
    }
}
