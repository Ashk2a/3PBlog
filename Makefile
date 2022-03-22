.DEFAULT_GOAL := help

PHP = php
YARN = yarn
MAKE = make
SYMFONY = symfony
BIN_CONSOLE = $(PHP) bin/console
COMPOSER = $(SYMFONY_BIN) composer


## —————————— ℹ️ Help ℹ️ ——————————

.PHONY: help

help: ## Get command list
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'


## —————————— ⏯ Project ⏯ ——————————

.PHONY: startsf startyarn start

start-dev: ## Start Dev
	$(MAKE) -j3 startsf startyarn

start-sf: ## Start symfony
	$(SYMFONY) server:start

yarn-watch: ## Start webpack in watch mode
	$(YARN) watch


## —————————— 🎵 Symfony 🎵 ——————————

db: ## Build the DB, control the schema validity and check the migration status
	$(BIN_CONSOLE) doctrine:cache:clear-metadata
	$(BIN_CONSOLE) doctrine:database:create --if-not-exists
	$(BIN_CONSOLE) doctrine:schema:drop --force
	$(BIN_CONSOLE) doctrine:schema:create
	$(BIN_CONSOLE) doctrine:schema:validate

fixtures: ## Load default fixtures
	$(BIN_CONSOLE) doctrine:fixtures:load --no-interaction


## —————————— 🧰 Assets 🧰 ——————————

.PHONY: install

assets: vendor modules ## Install assets
	@$(YARN) build

vendor: composer.json ## Install composer dependencies
	@$(COMPOSER) install

modules: yarn.lock ## Install yarn dependencies
	@$(YARN) install


## —————————— 🗑️ Cleaning 🗑️ ——————————

clear-cache: ## Clear Symfony cache.
	$(BIN_CONSOLE) c:c

purge-var: ## Delete cache and logs directory
	@rm -rf var/*
	@echo "var/ purged"

purge-assets: ## Delete node_modules and vendor directories
	@rm -rf node_modules/ vendor/
	@echo "Assets purged"

purge-build: ## Delete public/build/
	@rm -rf public/build/
	@echo "Build Assets purged"

purge-image-cache: ## Delete public/media/cache
	@rm -rf public/media/cache/
	@echo "Image cache purged"

purge-all: purge-var purge-assets purge-build purge-image-cache ## Delete var/ node_modules/ vendor/ public/build/ directories
	@echo "Assets purged"
