class MissedTernaryOpportunity
{
    int Field;

    public bool M()
    {
        if (true) { return false; } else { Field++; return true; } // GOOD
        return true ? false : true; // GOOD
        if (true) return false; else { { return true; } } // BAD
        var x = "";
        if (true) { Field = 0; } else { x = ""; } // GOOD
        if (true) { Field = 0; } else { x = ""; Field = 1; } // GOOD
        Field = true ? 0 : 1; // GOOD
        if (true) { this.Field = 0; } else Field = 1; // BAD
    }
}
