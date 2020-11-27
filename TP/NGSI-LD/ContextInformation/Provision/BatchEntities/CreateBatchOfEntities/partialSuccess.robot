*** Settings ***
Documentation   Check that you can create a batch of entities where some will succeed and others will fail
Variables   ../../../../../../resources/variables.py
Resource    ../../../../../../resources/ApiUtils.resource
Resource    ../../../../../../resources/AssertionUtils.resource
Library     REST    ${url}
Library     JSONLibrary

Suite Setup      Create Entity  building-minimal-3.jsonld

*** Variable ***
${batch_endpoint}=    entityOperations/create
${endpoint}=    entities

*** Test Case ***
Create batch of valid and invalid entities
    [Documentation]  Check that you can create a batch of valid and invalid entities
    [Tags]  critical

    ${first_entity}=    Load Json From File    ${EXECDIR}/data/entities/building-minimal.jsonld
    ${second_entity}=    Load Json From File    ${EXECDIR}/data/entities/building-minimal-2.jsonld
    ${already_existing_entity}=    Load Json From File    ${EXECDIR}/data/entities/building-minimal-3.jsonld
    @{entities_to_be_created}=  Create List   ${first_entity}     ${second_entity}     ${already_existing_entity}

    Batch Create Entities   @{entities_to_be_created}

    @{expected_entities_ids}=  Create List   urn:ngsi-ld:Building:3009ef20-9f62-41f5-bd66-92f041b428b9     urn:ngsi-ld:Building:56hy789-eft6-9987-be54-adr45nf567ddz
    Check Response Status Code Set To  207
    Check Response Body Set To  @{expected_entities_ids}

    #TODO call Batch Delete Entities
    Delete Entity by Id  urn:ngsi-ld:Building:3009ef20-9f62-41f5-bd66-92f041b428b9
    Delete Entity by Id  urn:ngsi-ld:Building:56hy789-eft6-9987-be54-adr45nf567ddz
    Delete Entity by Id  urn:ngsi-ld:Building:3009ef20-9f62-41f5-bd66-345789442