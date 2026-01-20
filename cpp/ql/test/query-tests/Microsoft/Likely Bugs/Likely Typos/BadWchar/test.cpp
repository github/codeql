// Query should catch invalidWchar1 and invalidWchar2 in invalidWcharTest function but not semiValidWchar and validWchar in validWcharTest function
typedef wchar_t WCHAR;

void invalidWcharTest()
{
    const WCHAR invalidWchar3[] = {
        L'C', L'P', L'R', L'O', L'G', L'R', L'A', L'M', L' ', L'1', L'.', L'0',
        'L\0'}; // 'L\0' should be L'\0'

    const WCHAR invalidWchar2[] = {
        L'C', L'P', L'R', L'O', L'G', L'R', L'A', L'M', L' ', L'1', L'.', L'0',
        'LZ'}; // 'LZ' should be L'Z'
}

void validWcharTest()
{
    const WCHAR semiValidWchar[] = {
        L'C', L'P', L'R', L'O', L'G', L'R', L'A', L'M', L' ', L'1', L'.', L'0',
        L'L\0'};

    const WCHAR validWchar[] = {
        L'C', L'P', L'R', L'O', L'G', L'R', L'A', L'M', L' ', L'1', L'.', L'0',
        L'\0'};
}