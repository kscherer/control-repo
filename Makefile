SHELL = /bin/bash #requires bash

.PHONY: help install update

.DEFAULT_GOAL := help

help:
	@echo "Make options for puppet module development"
	@echo
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'

install: ## Install r10k and librarian-puppet using bundler
	bundle install --path=.bundle

update: install ## Update the packages in the local bundle
	bundle update --path=.bundle

modules: install ## Install a local version of all the modules in the Puppetfile
	bundle exec r10k puppetfile install --config r10k.yaml --puppetfile Puppetfile --moduledir modules -v