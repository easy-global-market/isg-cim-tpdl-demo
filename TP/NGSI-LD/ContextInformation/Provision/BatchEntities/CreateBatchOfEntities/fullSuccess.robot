*** Settings ***
Documentation   Check that you can create a batch of entities
Variables   ../../../../../../resources/variables.py
Resource    ../../../../../../resources/ApiUtils.resource
Resource    ../../../../../../resources/AssertionUtils.resource
Library     REST    ${url}
Library     JSONLibrary

*** Variable ***
${batch_endpoint}=    entityOperations/create
${endpoint}=    entities

*** Test Case ***
Create batch of minimal entities
    [Documentation]  Check that you can create a batch of minimal entities
    [Tags]  critical

    ${first_minimal_entity}=    Load Json From File    ${EXECDIR}/data/entities/building-minimal.jsonld
    ${second_minimal_entity}=    Load Json From File    ${EXECDIR}/data/entities/building-minimal-2.jsonld
    @{entities_to_be_created}=  Create List   ${first_minimal_entity}     ${second_minimal_entity}

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

    ${first_entity}=    Load Json From File    ${EXECDIR}/data/entities/building-simple-attributes.jsonld
    ${second_entity}=    Load Json From File    ${EXECDIR}/data/entities/building-simple-attributes-2.jsonld
    @{entities_to_be_created}=  Create List   ${first_entity}     ${second_entity}

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

    ${first_entity}=    Load Json From File    ${EXECDIR}/data/entities/building-relationship-of-property.jsonld
    ${second_entity}=    Load Json From File    ${EXECDIR}/data/entities/building-relationship-of-property-2.jsonld
    @{entities_to_be_created}=  Create List   ${first_entity}     ${second_entity}

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
