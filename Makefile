.SILENT: deps lint clean gen-mock test build run run-docker

CYAN=\033[0;36m
RESET=\033[0m

pprint = echo -e "${CYAN}::>${RESET} ${1}"
completed = $(call pprint,Completed!)

deps:
	$(call pprint, Downloading go libraries...)
	go mod download
	$(call completed)

lint:
	$(call pprint, Runnning linter...)
	curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s v1.50.1
	./bin/golangci-lint --version
	./bin/golangci-lint run ./...
	$(call completed)

clean:
	$(call pprint,Cleaning up...)
	rm -rf ./bin
	find . -name "mocks" | xargs rm -rf {}
	find . -name ".cover.out" | xargs rm -rf {}
	$(call completed)

# gen-mock: clean deps
# 	$(call pprint, Generating mocks for tests...)
# 	go get github.com/golang/mock/mockgen
# 	go generate ./...
# 	$(call completed)

# test: gen-mock
# 	$(call pprint, Runnning tests...)
# 	go test ./... -coverprofile .cover.out
# 	$(call completed)

build: clean deps
	$(call pprint, Building app...)
	go build -o ./cmd/main ./cmd
	$(call completed)

run:
	$(call pprint, Running app...)
	go run ./cmd/main.go
	$(call completed)

# run-docker:
# 	$(call pprint, Running app...)
# 	docker-compose up -d --build
# 	$(call completed)