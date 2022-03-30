class Good
{
    int Size { get; set; }

    bool Espresso => Size <= 4;
    bool Latte => !Espresso && Size <= 8;
    bool Grande => !Espresso && !Latte;
}
