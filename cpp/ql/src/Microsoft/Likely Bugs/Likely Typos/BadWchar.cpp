// Query should catch invalidWchar1 and invalidWchar2 but not semiValidWchar and validWchar
const WCHAR invalidWchar3[] = {
    L'C', L'P', L'R', L'O', L'G', L'R', L'A', L'M', L' ', L'1', L'.', L'0',
    'L\0'};

const WCHAR invalidWchar2[] = {
    L'C', L'P', L'R', L'O', L'G', L'R', L'A', L'M', L' ', L'1', L'.', L'0',
    'LZ'};

const WCHAR semiValidWchar[] = {
    L'C', L'P', L'R', L'O', L'G', L'R', L'A', L'M', L' ', L'1', L'.', L'0',
    L'L\0'};

const WCHAR validWchar[] = {
    L'C', L'P', L'R', L'O', L'G', L'R', L'A', L'M', L' ', L'1', L'.', L'0',
    L'\0'};