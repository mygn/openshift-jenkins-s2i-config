.PHONY: build
build:
	hack/build.sh

.PHONY: test
test:
	TAG_ON_SUCCESS=$(TAG_ON_SUCCESS) TEST_MODE=true hack/build.sh
