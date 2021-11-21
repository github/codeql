## 0.0.4

### Major Analysis Improvements

* Added modeling of `aiopg` for sinks executing SQL.
* Added modeling of HTTP requests and responses when using `flask_admin` (`Flask-Admin` PyPI package), which leads to additional remote flow sources.
* Added modeling of the PyPI package `toml`, which provides encoding/decoding of TOML documents, leading to new taint-tracking steps.
