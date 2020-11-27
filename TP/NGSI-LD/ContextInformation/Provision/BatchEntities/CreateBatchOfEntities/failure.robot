*** Settings ***
Documentation   Check that you cannot create a batch of entities with an invalid request
Variables   ../../../../../../resources/variables.py
Resource    ../../../../../../resources/ApiUtils.resource
Resource    ../../../../../../resources/AssertionUtils.resource
Library     REST    ${url}
Library     JSONLibrary

*** Variable ***
${batch_endpoint}=    entityOperations/create
${endpoint}=    entities

*** Test Case ***
With empty json document
    [Documentation]  Check that you cannot create a batch of entities with an invalid json document
    [Tags]  critical

    Batch Create Entities With File   building-invalid.jsonld

    Check Response Status Code Set To  400