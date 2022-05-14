#!/usr/bin/env bash
FILE=../src/project.sh
setup() {
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'
    load 'test_helper/bats-file/load'
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    PATH="$DIR/../src:$PATH"
}

@test "verify bash version" {
  run bash --help
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "GNU bash, version 4.4.20(1)-release-(x86_64-pc-linux-gnu)" ]
}

@test "should run script" {
    $FILE 'Hello ' 'Baeldung' '/tmp/output'
}

@test "should return concatenated strings" {
    run $FILE 'Hello ' 'Baeldung' '/tmp/output'

    assert_output 'Hello Baeldung'
}

@test "should create file" {
    run $FILE 'Hello ' 'Baeldung' '/tmp/output'

    assert_exist /tmp/output
}

@test "should write to file" {
    run $FILE 'Hello ' 'Baeldung' '/tmp/output'

    file_content=`cat /tmp/output`
    [ "$file_content" == 'Hello Baeldung' ]
}

@test "should write logs" {
    skip "Logs are not implemented yet"
    run $FILE 'Hello ' 'Baeldung' '/tmp/output'

    file_content=`cat /tmp/logs`
    [ "$file_content" == 'I logged something' ]
}

teardown() {
    rm -f /tmp/output
}