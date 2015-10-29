#!/usr/bin/makei
.PHONY: test
test:
	./postSlack.sh channel '#devtest' botname 'Hello' msg 'Hello from script' emoji ':package:'
