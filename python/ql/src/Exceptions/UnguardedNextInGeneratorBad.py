
test_files = [
    ["header1", "text10", "text11", "text12"],
    ["header2", "text20", "text21", "text22"],
    [],
    ["header4", "text40", "text41", "text42"],
]

def separate_headers(files):
    for file in files:
        lines = iter(file)
        header = next(lines) # Will raise StopIteration if lines is exhausted
        body = [ l for l in lines ]
        yield header, body

def process_files(files):
    for header, body in separate_headers(files):
        print(format_page(header, body))

