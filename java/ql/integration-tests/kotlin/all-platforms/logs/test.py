import json
from math import log
import pathlib
import re


def test(codeql, java_full, cwd: pathlib.Path, expected_files):
    codeql.database.create(command=["kotlinc test.kt"])
    expected_files.add("logs.actual")

    with open("logs.actual", "w") as f_out:
        log_dir = cwd / "test-db" / "log"
        for file_index, log_file in enumerate(log_dir.glob("kotlin-extractor*.log"), 1):
            f_out.write(f"Log file {file_index}\n")
            for line in log_file.read_text().splitlines():
                j = json.loads(line)
                del j["timestamp"]
                msg = j["message"]
                msg = re.sub(
                    r"(?<=Extraction for invocation TRAP file ).*[\\/]test-db[\\/]trap[\\/]java[\\/]invocations[\\/]kotlin\..*\.trap",
                    "<FILENAME>",
                    msg,
                )
                msg = re.sub(
                    r"(?<=Extracting file ).?:?[\\/].*test\.kt",
                    "test.kt",
                    msg,
                )
                msg = re.sub("(?<=Kotlin version )[0-9.]+(-[a-zA-Z0-9.]+)?", "<VERSION>", msg)
                if msg.startswith("Peak memory: "):
                    # Peak memory information varies from run to run, so just ignore it
                    continue
                if msg.startswith("Will write TRAP file ") or msg.startswith(
                    "Finished writing TRAP file "
                ):
                    # These vary between machines etc, and aren't very interesting, so just ignore them
                    continue
                j["message"] = msg
                print(json.dumps(j), file=f_out)
