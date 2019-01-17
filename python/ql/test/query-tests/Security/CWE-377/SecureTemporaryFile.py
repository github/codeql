from tempfile import NamedTemporaryFile

def write_results(results):
    with NamedTemporaryFile(mode="w+", delete=False) as f:
        f.write(results)
    print("Results written to", f.name)
