## 1.1.0

### New Features

* Data models can now be added with data extensions. In this way source, sink and summary models can be added in extension `.model.yml` files, rather than by writing classes in QL code. New models should be added in the `lib/ext` folder.

### Minor Analysis Improvements

* A partial model for the `Boost.Asio` network library has been added. This includes sources, sinks and summaries for certain functions in `Boost.Asio`, such as `read_until` and `write`.
