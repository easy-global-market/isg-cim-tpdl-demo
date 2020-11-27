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
Create batch of minimal entities
    [Documentation]  Check that you can create a batch of minimal entities
    [Tags]  critical

    ${first_minimal_entity}=    Get File    ${EXECDIR}/data/building-minimal.jsonld
    ${second_minimal_entity}=    Get File    ${EXECDIR}/data/building-minimal-2.jsonld
    ${first_minimal_entity_parsed}=    evaluate    json.loads($first_minimal_entity)    json
    ${second_minimal_entity_parsed}=    evaluate    json.loads($second_minimal_entity)    json
    @{entities_to_be_created}=  Create List   ${first_minimal_entity_parsed}     ${second_minimal_entity_parsed}

    Batch Create Entities   @{entities_to_be_created}

    @{expected_entities_ids}=  Create List   urn:ngsi-ld:Building:3009ef20-9f62-41f5-bd66-92f041b428b9     urn:ngsi-ld:Building:56hy789-eft6-9987-be54-adr45nf567ddz
    Check Response Status Code Set To  201
    Check Response Body Set To  @{expected_entities_ids}

    #TODO call Batch Delete Entities
    Delete Entity by Id  urn:ngsi-ld:Building:3009ef20-9f62-41f5-bd66-92f041b428b9
    Delete Entity by Id  urn:ngsi-ld:Building:56hy789-eft6-9987-be54-adr45nf567ddz

Create batch of entities having only simple properties
    [Documentation]  Check that you can create a batch of entities having only simple properties
    [Tags]  critical

    ${first_entity}=    Get File    ${EXECDIR}/data/building-simple-attributes.jsonld
    ${second_entity}=    Get File    ${EXECDIR}/data/building-simple-attributes-2.jsonld
    ${first_entity_parsed}=    evaluate    json.loads($first_entity)    json
    ${second_entity_parsed}=    evaluate    json.loads($second_entity)    json
    @{entities_to_be_created}=  Create List   ${first_entity_parsed}     ${second_entity_parsed}

    Batch Create Entities   @{entities_to_be_created}

    @{expected_entities_ids}=  Create List   urn:ngsi-ld:Building:3009ef20-9f62-41f5-bd66-92f041b428b9     urn:ngsi-ld:Building:56hy789-eft6-9987-be54-adr45nf567ddz
    Check Response Status Code Set To  201
    Check Response Body Set To  @{expected_entities_ids}

    #TODO call Batch Delete Entities
    Delete Entity by Id  urn:ngsi-ld:Building:3009ef20-9f62-41f5-bd66-92f041b428b9
    Delete Entity by Id  urn:ngsi-ld:Building:56hy789-eft6-9987-be54-adr45nf567ddz

Create batch of entities having multiple attributes
    [Documentation]  Check that you can create a batch of entities having multiple attributes
    [Tags]  critical

    ${first_entity}=    Get File    ${EXECDIR}/data/building-relationship-of-property.jsonld
    ${second_entity}=    Get File    ${EXECDIR}/data/building-relationship-of-property-2.jsonld
    ${first_entity_parsed}=    evaluate    json.loads($first_entity)    json
    ${second_entity_parsed}=    evaluate    json.loads($second_entity)    json
    @{entities_to_be_created}=  Create List   ${first_entity_parsed}     ${second_entity_parsed}

    Batch Create Entities   @{entities_to_be_created}

    @{expected_entities_ids}=  Create List   urn:ngsi-ld:Building:3009ef20-9f62-41f5-bd66-92f041b428b9     urn:ngsi-ld:Building:56hy789-eft6-9987-be54-adr45nf567ddz
    Check Response Status Code Set To  201
    Check Response Body Set To  @{expected_entities_ids}

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

Check Response Status Code Set To
    [Arguments]  ${status}
    ${response_status}=  convert to string  ${response['status']}
    Should Be Equal  ${response_status}  ${status}

Delete Entity by Id
    [Arguments]  ${id}
    ${response}=  DELETE  ${endpoint}/${id}
    Output  request
    Output  response

Check Response Body Set To
    [Arguments]  @{expected_entities_ids}
    Should Contain  ${response['body']['success']}  @{expected_entities_ids}

