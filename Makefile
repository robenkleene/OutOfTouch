SCHEME = OutOfTouch

.PHONY: build test lint autocorrect swiftformat swiftlint_autocorrect bootstrap archive

ci: bootstrap build
ac: autocorrect
autocorrect: swiftformat swiftlint_autocorrect

lint:
	swiftlint --strict

swiftformat:
	git ls-files '*.swift' -z | xargs -0 swiftformat --commas inline

swiftlint_autocorrect:
	swiftlint autocorrect

build:
	xcodebuild build \
		-alltargets \
		-configuration Debug

archive:
	carthage build --no-skip-current
	carthage archive OutOfTouch

bootstrap:
	carthage bootstrap

test:
	xcodebuild test \
		-alltargets \
		-configuration Debug \
		-scheme $(SCHEME)

