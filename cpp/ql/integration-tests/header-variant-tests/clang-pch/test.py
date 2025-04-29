import os


def test(codeql, cpp):
    os.mkdir("pch")
    codeql.database.create(command=[
        f'"{cpp.get_tool("extractor")}" --mimic-clang -emit-pch -o pch/a.pch a.c',
        f'"{cpp.get_tool("extractor")}" --mimic-clang -include-pch pch/a.pch -Iextra_dummy_path b.c',
        f'"{cpp.get_tool("extractor")}" --mimic-clang -include pch/a -Iextra_dummy_path c.c',
        f'"{cpp.get_tool("extractor")}" --mimic-clang -emit-pch -o pch/d.pch d.c',
        f'"{cpp.get_tool("extractor")}" --mimic-clang -include-pch pch/d.pch e.c',
        f'"{cpp.get_tool("extractor")}" --mimic-clang -emit-pch -o pch/f.pch f.c',
        f'"{cpp.get_tool("extractor")}" --mimic-clang -include-pch pch/f.pch g.c',
        f'"{cpp.get_tool("extractor")}" --mimic-clang -emit-pch -o pch/h.pch h.c',
        f'"{cpp.get_tool("extractor")}" --mimic-clang -include-pch pch/h.pch i.c',
    ])
