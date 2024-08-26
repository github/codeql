function TrapTest {
    trap {"Error found."}
    nonsenseString
}

TrapTest