PACKAGE_DIRS := $(shell find . -mindepth 2 -type f -name 'go.mod' -exec dirname {} \; | sort)

all:
	TZ= go test ./...
	TZ= go test ./... -short -race
	TZ= go test ./... -run=NONE -bench=. -benchmem
	env GOOS=linux GOARCH=386 go test ./...
	go vet
	golangci-lint run

.PHONY: test
test:
	TZ= PGSSLMODE=disable go test ./... -v -race

tag:
	git tag $(VERSION)
	git tag extra/pgdebug/$(VERSION)
	git tag extra/pgotel/$(VERSION)
	git tag extra/pgsegment/$(VERSION)

fmt:
	gofmt -w -s ./
	goimports -w  -local github.com/go-pg/pg ./

go_mod_tidy:
	go get -u && go mod tidy
	set -e; for dir in $(PACKAGE_DIRS); do \
	  echo "go mod tidy in $${dir}"; \
	  (cd "$${dir}" && \
	    go get -u && \
	    go mod tidy); \
	done
