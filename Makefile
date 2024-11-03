.PHONY: all build build-preview help serve

module-check: ## Check if all of the required submodules are correctly initialized.
	@git submodule status --recursive | awk '/^[+-]/ {err = 1; printf "\033[31mWARNING\033[0m Submodule not initialized: \033[34m%s\033[0m\n",$$2} END { if (err != 0) print "You need to run \033[32mmake module-init\033[0m to initialize missing modules first"; exit err }' 1>&2

non-production-build: module-check ## Build the non-production site, which adds noindex headers to prevent indexing
	GOMAXPROCS=1 hugo --cleanDestinationDir --enableGitInfo --environment nonprod
