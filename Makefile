all:
	carthage build --no-skip-current
	carthage archive
