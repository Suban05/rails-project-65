start:
	rm -rf tmp/pids/server.pid
	bin/rails s

install:
	bin/setup

check: test lint

test:
	bin/rails test

lint:
	bundle exec rubocop

lint-fix:
	bundle exec rubocop -A

init-env:
	touch .env

.PHONY: test