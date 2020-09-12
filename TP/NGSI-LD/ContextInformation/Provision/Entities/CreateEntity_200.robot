*** Settings ***
Documentation   TP description.
Variables   ../../../../../resources/variables.py
Library     REST    ${url}
Library     JSONSchemaLibrary   .schemas/
Library     OperatingSystem

#Suite Setup 
#Suite Teardown

*** Variable ***
${endpoint}=    entities


*** Test Case ***
CreateEntity_200_MINIMAL
    [Documentation]  TP Variation description.
    [Tags]  critical
    Log To Console  "Will start Test Case CreateEntity_200_MINIMAL ..."
    #TO DO: read body from files
    Create Entity   {"id": "urn:ngsi-ld:Building:3009ef20-9f62-41f5-bd66-92f041b428b9", "type": "Building"}
    Check HTTP Status Code Is  201
    Check HTTP Response Body Json Schema Is  response.json   

*** Keywords ***
Create Entity  
    [Arguments]    ${body}    
    ${response}    POST    ${endpoint}      body=${body}
    Output    request
    Output    response
    Set Test Variable    ${response}

Check HTTP Status Code Is 
    [Arguments]    ${status}
    Log To Console  ${response}
    Should Be Equal    ${response['status']}    ${status}

Check HTTP Response Body Json Schema Is
    [Arguments]    ${input}
    Should Contain    ${response['headers']['Content-Type']}    application/json
    ${schema} =    Catenate    SEPARATOR=    ${input}    .schema.json
    Validate Json    ${schema}    ${response['body']}
    Log    Json Schema Validation OK

