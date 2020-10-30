CHARTY_VERSION?=0.2.0

all: deps build

.bin:
	mkdir -p .bin

.bin/charty: .bin
	@wget https://github.com/mudler/charty/releases/download/v$(CHARTY_VERSION)/charty-$(CHARTY_VERSION)-linux-amd64 -O .bin/charty
	chmod +x .bin/charty

deps: .bin/charty

clean:
	rm -rf .bin release

build:
	mkdir release
	.bin/charty package testcharts/package-smoke release/
	.bin/charty package testcharts/entropy-migration release/
	.bin/charty package testcharts/artifact-qa release/
