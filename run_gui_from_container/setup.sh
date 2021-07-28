#!/bin/bash
if test "$(uname)" = "Darwin"
then
	cp docker-compose-mac.yml docker-compose.yml
elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
then
	cp docker-compose-linux.yml docker-compose.yml
fi
