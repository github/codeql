class Bad
{
    int Size { get; set; }

    bool Espresso => !(Size > 4);
    bool Latte => Espresso == false && Size <= 8;
    bool Grande => Espresso == false ? Latte != true : false;
}
