# Recorded Call Graph Metrics

also known as _call graph tracing_.

Execute a python program and for each call being made, record the call and callee. This allows us to compare call graph resolution from static analysis with actual data -- that is, can we statically determine the target of each actual call correctly.

Using the call graph tracer does incur a heavy toll on the performance. Expect 10x longer to execute the program.

Number of calls recorded vary a little from run to run. I have not been able to pinpoint why.

## Running against real projects

Currently it's possible to gather metrics from traced runs of the standard test suite of a few projects (defined in [projects.json](./projects.json)): `youtube-dl`, `wcwidth`, and `flask`.

To run against all projects, use

```bash
$ ./helper.sh all $(./helper.sh projects)
```

To view the results, use
```
$ head -n 100 projects/*/Metrics.txt
```

### Expanding set of projects

It should be fairly straightforward to expand the set of projects. Most projects use `tox` for running their tests against multiple python versions. I didn't look into any kind of integration, but have manually picked out the instructions required to get going.

As an example, compare the [`tox.ini`](https://github.com/pallets/flask/blob/21c3df31de4bc2f838c945bd37d185210d9bab1a/tox.ini) file from flask with the configuration

```json
    "flask": {
        "repo": "https://github.com/pallets/flask.git",
        "sha": "21c3df31de4bc2f838c945bd37d185210d9bab1a",
        "module_command": "pytest -c /dev/null tests examples",
        "setup": [
            "pip install -r requirements/tests.txt",
            "pip install -q -e examples/tutorial[test]",
            "pip install -q -e examples/javascript[test]"
        ]
    }
```

## Local development

### Setup

1. Ensure you have at least Python 3.7

2. Create virtual environment `python3 -m venv venv` and activate it

3. Install dependencies `pip install -r --upgrade requirements.txt`

4. Install this codebase as an editable package `pip install -e .`

5. Setup your editor. If you're using VS Code, create a new project for this folder, and
   use these settings for correct autoformatting of code on save:
  ```
  {
      "python.pythonPath": "venv/bin/python",
      "python.linting.enabled": true,
      "python.linting.flake8Enabled": true,
      "python.formatting.provider": "black",
      "editor.formatOnSave": true,
      "[python]": {
          "editor.codeActionsOnSave": {
              "source.organizeImports": true
          }
      },
      "python.autoComplete.extraPaths": [
          "src"
      ]
  }
  ```

6. Enjoy writing code, and being able to run `cg-trace` on your command line :tada:

### Using it

After following setup instructions above, you should be able to reproduce the example trace by running

```
cg-trace --xml example/simple.xml example/simple.py
```

You can also run traces for all tests and build a database by running `tests/create-test-db.sh`. Then run the queries inside the `ql/` directory.

## Tracing Limitations

### Multi-threading

Should be possible by using [`threading.setprofile`](https://docs.python.org/3.8/library/threading.html#threading.setprofile), but that hasn't been done yet.

### Code that uses `sys.setprofile`

Since that is our mechanism for recording calls, any code that uses `sys.setprofile` will not work together with the call-graph tracer.

### Class instantiation

Does not always fire off an event in the `sys.setprofile` function (neither in `sys.settrace`), so is not recorded. Example:

```
r = range(10)
```

when disassembled (`python -m dis <file>`):

```
  9          48 LOAD_NAME                7 (range)
             50 LOAD_CONST               5 (10)
             52 CALL_FUNCTION            1
             54 STORE_NAME               8 (r)
```

but no event :disappointed:
