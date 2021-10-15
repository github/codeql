class Qualifiers
{
    Qualifiers Field;
    static Qualifiers StaticField;
    Qualifiers Property { get; set; }
    static Qualifiers StaticProperty { get; set; }
    Qualifiers Method() => null;
    static Qualifiers StaticMethod() => null;

    void M()
    {
        var q = Field;
        q = Property;
        q = Method();

        q = this.Field;
        q = this.Property;
        q = this.Method();

        q = StaticField;
        q = StaticProperty;
        q = StaticMethod();

        q = Qualifiers.StaticField;
        q = Qualifiers.StaticProperty;
        q = Qualifiers.StaticMethod();

        q = Qualifiers.StaticField.Field;
        q = Qualifiers.StaticProperty.Property;
        q = Qualifiers.StaticMethod().Method();
    }
}
