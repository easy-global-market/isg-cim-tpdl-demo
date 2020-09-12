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

Assert response status code
    [Arguments]     ${code}
    Should Be Equal     ${response}[status]  ${code}     

Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}
    ${status}=    Convert To Integer    ${expected_status}
    Console
    Should Be Equal    ${response['status']}    ${status}
    Log    Status code validated

Check HTTP Response Body Json Schema Is
    [Arguments]    ${input}
    Should Contain    ${response['headers']['Content-Type']}    application/json
    ${schema} =    Catenate    SEPARATOR=    ${input}    .schema.json
    Validate Json    ${schema}    ${response['body']}
    Log    Json Schema Validation OK

Should Be Present In Json List
    [Arguments]     ${expr}   ${json_field}   ${json_value}
    Log    Check if ${json_field} is present in ${expr} with the value ${jsonvalue}
    :FOR  ${item}  IN  @{expr}
    \  Exit For Loop If    "${item['${json_field}']}" == "${json_value}"
    Log    Item found ${item}
    [return]    ${item}

Check Result Contains
    [Arguments]    ${source}    ${parameter}    ${value}
    Should Be Present In Json List    ${source}    ${parameter}    ${value}