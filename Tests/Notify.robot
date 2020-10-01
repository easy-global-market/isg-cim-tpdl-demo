*** Settings ***
Documentation   Test Binding
Variables   ../resources/variables.py
Resource    ../resources/${binding}.resource
Test Timeout  30 seconds

*** Test Case ***
Test notify ${binding} Broker
   [Documentation]  Validate notification received by the broker (MQTT or HTTP)
   Connect to broker
   Notify broker
   Wait for notification and validate it
   [Teardown]  Discconect from broker