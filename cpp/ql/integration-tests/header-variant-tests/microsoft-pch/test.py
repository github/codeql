import os


def test(codeql, cpp):
    os.mkdir("pch")
    extractor = f"{cpp.get_tool("extractor")}" 
    codeql.database.create(command=[
        f'"{extractor}" --mimic-cl /Yca.h /Fppch/a.pch a.c',
        f'"{extractor}" --mimic-cl /Yub.h /Fppch/a.pch b.c',
        f'"{extractor}" --mimic-cl /Yuc.h /Fppch/a.pch c.c',
    ])
