EXECUTABLE := fractalpool
LATEST_TAG 		:= $(shell git describe --abbrev=0 --tags )
LATEST_TAG_COMMIT_SHA1   := $(shell git rev-list --tags --max-count=1 )
LATEST_COMMIT_SHA1     := $(shell git rev-parse HEAD )
BUILD_TIME      := $(shell date "+%F %T" )
GOFLAGS = -ldflags '-X "main.LatestTag=${LATEST_TAG}" -X "main.LatestTagCommitSHA1=${LATEST_TAG_COMMIT_SHA1}" -X "main.LatestCommitSHA1=${LATEST_COMMIT_SHA1}" -X "main.BuildTime=${BUILD_TIME}"'
GOBIN = ./build/bin

# Automatic detection operating system
ifeq ($(OS),Windows_NT)
    # Windows Environment
    OUTPUT_SUFFIX=.exe
else
    OUTPUT_SUFFIX=
endif

UNIX_EXECUTABLES := \
	build/darwin/amd64/bin/$(EXECUTABLE) \
	build/darwin/arm64/bin/$(EXECUTABLE) \
	build/linux/amd64/bin/$(EXECUTABLE) \
	build/freebsd/amd64/bin/$(EXECUTABLE)
WIN_EXECUTABLES := \
	build/windows/amd64/bin/$(EXECUTABLE).exe

EXECUTABLES=$(UNIX_EXECUTABLES) $(WIN_EXECUTABLES)

COMPRESSED_EXECUTABLES := \
     $(UNIX_EXECUTABLES:%=%.fractalpool.tar.gz) \
     $(WIN_EXECUTABLES:%.exe=%.fractalpool.zip) \
     $(WIN_EXECUTABLES:%.exe=%.fractalpool.cn.zip)


TARGETS=$(EXECUTABLES) $(COMPRESSED_EXECUTABLES)

.PHONY: fractalpool

fractalpool:
	@echo "Done building."
	@go build -o $(GOBIN)/fractalpool$(OUTPUT_SUFFIX) $(GOFLAGS)
	@echo "  $(shell $(GOBIN)/fractalpool -v))"
	@echo "Run \"$(GOBIN)/fractalpool\" to launch."

all: fractalpool

clean:
	@rm -f *.zip
	@rm -f *.tar.gz
	@rm -f ./build/bin/*
	@rm -rf ./build