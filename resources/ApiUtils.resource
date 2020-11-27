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