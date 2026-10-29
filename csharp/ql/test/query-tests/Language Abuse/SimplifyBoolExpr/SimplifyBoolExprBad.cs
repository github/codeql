class Bad
{
    int Size { get; set; }

    bool Espresso => !(Size > 4); // $ Alert
    bool Latte => Espresso == false && Size <= 8; // $ Alert
    bool Grande => Espresso == false ? Latte != true : false; // $ Alert
}
