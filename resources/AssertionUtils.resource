*** Keywords ***
Check Response Status Code Set To
    [Arguments]  ${expected_status}
    ${response_status}=  convert to string  ${response['status']}
    Should Be Equal  ${response_status}  ${expected_status}

Check Response Body Containing Array
    [Arguments]  @{expected_array}
    Lists Should Be Equal  ${response['body']}  ${expected_array}   ignore_order=True

Check Response Body Containing Batch Operation Result
    [Arguments]  ${expected_batch_operation_result}
    @{expected_success}=    Get From Dictionary     ${expected_batch_operation_result}     success
    @{expected_errors}=    Get From Dictionary     ${expected_batch_operation_result}     errors
    Lists Should Be Equal  ${response['body']['success']}  ${expected_success}   ignore_order=True

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