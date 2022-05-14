#!/bin/bash
FROM bats/bats:latest

COPY . /bats
WORKDIR /bats


ENTRYPOINT ["./server.sh"]
