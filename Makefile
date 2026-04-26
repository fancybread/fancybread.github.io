.PHONY: help setup start stop kill restart status logs build clean reset

SCRIPT := ./mkdocs.sh

help:
	@$(SCRIPT) help

setup:
	@$(SCRIPT) setup

start:
	@$(SCRIPT) start

stop:
	@$(SCRIPT) stop

kill:
	@$(SCRIPT) kill

restart:
	@$(SCRIPT) restart

status:
	@$(SCRIPT) status

logs:
	@$(SCRIPT) logs

build:
	@$(SCRIPT) build

clean:
	@$(SCRIPT) clean

reset:
	@$(SCRIPT) reset
