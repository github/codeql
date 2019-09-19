class EraInfo
{
public:
    EraInfo() {

    };

    EraInfo(int year, int month, int day) {

    };

    EraInfo(int Era, int foo, int year, int month, int day, const wchar_t * eraName)
    {

    }

    static EraInfo * EraInfoFromDate(int Era, int foo, int year, int month, int day, wchar_t * eraName)
    {
        return new EraInfo(Era, foo, year, month, day, eraName);
    }
};

int Main()
{

    // BAD: constructor creating a EraInfo with exact Heisei era start date
    EraInfo * pDateTimeUtil = new EraInfo(1989, 1, 8);

    // BAD: constructor creating a EraInfo with exact Heisei era start date
    EraInfo * pDateTimeUtil1 = new EraInfo(1, 2, 1989, 1, 8, L"\u5e73\u6210");

    // Good: constructor creating a EraInfo with another date
    EraInfo * pDateTimeUtil2 = new EraInfo(1, 2, 1900, 1, 1, L"foo");

    // BAD: method call passing exact Haisei era start date as parameters
    EraInfo * pDateTimeUtil3 = EraInfo::EraInfoFromDate(1, 2, 1989, 1, 8, L"\u5e73\u6210");

    // GOOD: method call with the same parameters in a different order (we only track year, month, day)
    EraInfo * pDateTimeUtil4 = EraInfo::EraInfoFromDate(1, 2, 8, 1, 1989, L"\u5e73\u6210");

    // BAD: constructor creating a EraInfo with exact Reiwa era start date
    EraInfo * pDateTimeUtil5 = new EraInfo(2019, 5, 1);
}