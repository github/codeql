import os


def test(codeql, cpp):
    os.mkdir("pch")
    codeql.database.create(command=[
        f'"{cpp.get_tool("extractor")}" --mimic-cl /Yca.h /Fppch/a.pch a.c',
        f'"{cpp.get_tool("extractor")}" --mimic-cl /Yub.h /Fppch/a.pch b.c',
        f'"{cpp.get_tool("extractor")}" --mimic-cl /Yuc.h /Fppch/a.pch c.c',
    ])
