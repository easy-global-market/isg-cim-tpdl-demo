*** Settings ***
Documentation   Check that you can create a batch of entities
Variables   ../../../../../../resources/variables.py
Resource    ../../../../../../resources/ApiUtils.resource
Library     REST    ${url}
Library     JSONSchemaLibrary   ${EXECDIR}/schemas
Library     BuiltIn
Library     OperatingSystem


*** Variable ***
${endpoint}=    entityOperations/create

*** Test Case ***
AlreadyExists
    [Documentation]  Check that you can create a batch of entities
    [Tags]  critical
    Batch Create Entities   filename=building-minimal.jsonld    filename_2=building-minimal-2.jsonld
    Check HTTP Status Code Is  201
    # it will be replaced by on call Batch Delete Entities
    Delete Entity by Id  urn:ngsi-ld:Building:3009ef20-9f62-41f5-bd66-92f041b428b9
    Delete Entity by Id  urn:ngsi-ld:Building:56hy789-eft6-9987-be54-adr45nf567ddz

*** Keywords ***
Batch Create Entities
    [Arguments]  ${filename}    ${filename_2}
    &{headers}=  Create Dictionary  Content-Type=application/ld+json
    ${file_content}=    Get File    ${EXECDIR}/data/${filename}
    ${file_content_2}=    Get File    ${EXECDIR}/data/${filename_2}
    ${body}=  Create List   ${file_content}     ${file_content_2}
    log  ${body}
    ${response}=  POST  ${endpoint}  body=${body}  headers=${headers}
    Output  request
    Output  response
    Set Test Variable  ${response}

Check HTTP Status Code Is
    [Arguments]  ${status}
    ${response_status}=  convert to string  ${response['status']}
    Should Be Equal  ${response_status}  ${status}

Delete Entity by Id
    [Arguments]  ${id}
    ${response}=  DELETE  ${endpoint}/${id}
    Output  request
    Output  response
