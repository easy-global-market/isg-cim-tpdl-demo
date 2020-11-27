*** Settings ***
Documentation   Check that you can create a batch of entities
Variables   ../../../../../../resources/variables.py
Resource    ../../../../../../resources/ApiUtils.resource
Library     REST    $url
Library     JSONSchemaLibrary   ${EXECDIR}/schemas
Library     BuiltIn
Library     OperatingSystem


*** Variable ***
${batch_endpoint}=    entityOperations/create
${endpoint}=    entities

*** Test Case ***
Create batch of entities
    [Documentation]  Check that you can create a batch of entities
    [Tags]  critical

    ${first_minimal_entity}=    Get File    ${EXECDIR}/data/building-minimal.jsonld
    ${second_minimal_entity}=    Get File    ${EXECDIR}/data/building-minimal-2.jsonld
    ${first_minimal_entity_parsed}=    evaluate    json.loads($first_minimal_entity)    json
    ${second_minimal_entity_parsed}=    evaluate    json.loads($second_minimal_entity)    json

    @{entities_to_be_created}=  Create List   ${first_minimal_entity_parsed}     ${second_minimal_entity_parsed}
    Batch Create Entities   @{entities_to_be_created}

    Check HTTP Status Code Is  201
    #TODO call Batch Delete Entities
    Delete Entity by Id  urn:ngsi-ld:Building:3009ef20-9f62-41f5-bd66-92f041b428b9
    Delete Entity by Id  urn:ngsi-ld:Building:56hy789-eft6-9987-be54-adr45nf567ddz

*** Keywords ***
Batch Create Entities
    [Arguments]  @{entities_to_be_created}
    &{headers}=  Create Dictionary  Content-Type=application/ld+json
    ${response}=  POST  ${batch_endpoint}  body=@{entities_to_be_created}  headers=${headers}
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
