*** Settings ***
Variables    ./variables.py

Library    REST    ${url}

*** Variables ***
${response}

*** Keywords ***
Api POST request
    [Arguments]    ${api path}    ${header}    ${body}    
    ${response}    POST    ${api path}/    headers=${header}    body=${body}
    Output    request
    Output    response
    Output Schema
    Set Test Variable    ${response}

Api GET request
    [Arguments]    ${api path}   ${header}    
    ${response}    GET    ${api path}    headers=${header}
    Output    request
    Output    response
    Output Schema
    Set Test Variable    ${response}

Api DEL request
    [Arguments]    ${header}    ${api path}
    ${response}    DEL    ${api path}    headers=${header}
    Output    request
    Output    response
    Output Schema
    Set Test Variable    ${response}

Delete Entity by Id
    [Arguments]  ${id}
    ${response}=  DELETE  ${endpoint}/${id}
    Output  request
    Output  response

Create Entity
    [Arguments]  ${filename}
    &{headers}=  Create Dictionary  Content-Type=application/ld+json
    ${response}=  POST  ${endpoint}  body=${EXECDIR}/data/entities/${filename}  headers=${headers}
    Output  request
    Output  response

Batch Create Entities
    [Arguments]  @{entities_to_be_created}
    &{headers}=  Create Dictionary  Content-Type=application/ld+json
    ${response}=  POST  ${batch_endpoint}  body=@{entities_to_be_created}  headers=${headers}
    Output  request
    Output  response
    Set Test Variable  ${response}

Batch Create Entities With File
    [Arguments]  ${filename}
    &{headers}=  Create Dictionary  Content-Type=application/ld+json
    ${response}=  POST  ${batch_endpoint}  body=${EXECDIR}/data/entities/${filename}  headers=${headers}
    Output  request
    Output  response
    Set Test Variable  ${response}
