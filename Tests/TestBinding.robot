*** Settings ***
Documentation   Test Binding
Variables   ../resources/variables.py
Resource    ../resources/${binding}.resource
Test Timeout  30 seconds

*** Test Case ***
Test ${binding} binding
    Check notification
