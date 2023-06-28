## Running tests

To run tests, you need Docker which starts PostgreSQL and MySQL servers:

```shell
cd internal/dbtest
./test.sh
```

To ease debugging, you can run tests and print all executed queries:

```shell
BUNDEBUG=2 TZ= go test -run=TestName
```

## Releasing

1. Run `release.sh` script which updates versions in go.mod files and pushes a new branch to GitHub:

```shell
TAG=v1.0.0 ./scripts/release.sh
```

2. Open a pull request and wait for the build to finish.

3. Merge the pull request and run `tag.sh` to create tags for packages:

```shell
TAG=v1.0.0 ./scripts/tag.sh
```

## Documentation

To contribute to the docs visit https://github.com/go-bun/bun-docs
