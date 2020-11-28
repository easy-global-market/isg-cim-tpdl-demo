*** Settings ***
Documentation   Check that you can create a batch of entities where some will succeed and others will fail
Variables   ../../../../../../resources/variables.py
Resource    ../../../../../../resources/ApiUtils.resource
Resource    ../../../../../../resources/AssertionUtils.resource
Resource    ../../../../../../resources/JsonUtils.resource
Library     REST    ${url}
Library     JSONLibrary
Library     String

Suite Setup      Create Entity  building-minimal-sample.jsonld     urn:ngsi-ld:Building:92f041b428b9

*** Variable ***
${batch_endpoint}=    entityOperations/create
${endpoint}=    entities
${building_id_prefix}=  urn:ngsi-ld:Building:

*** Test Case ***
Create batch of valid and invalid entities
    [Documentation]  Check that you can create a batch of valid and invalid entities
    [Tags]  critical

    ${first_entity_id}=     Generate Random Entity Id    ${building_id_prefix}
    ${second_entity_id}=     Generate Random Entity Id    ${building_id_prefix}
    ${first_entity}=    Load Entity    building-minimal-sample.jsonld      ${first_entity_id}
    ${second_entity}=    Load Entity    building-minimal-sample.jsonld      ${second_entity_id}
    ${already_existing_entity}=    Load Entity    building-minimal-sample.jsonld      urn:ngsi-ld:Building:92f041b428b9
    @{entities_to_be_created}=  Create List   ${first_entity}     ${second_entity}     ${already_existing_entity}

    Batch Create Entities   @{entities_to_be_created}

    @{expected_entities_ids}=  Create List   ${first_entity_id}     ${second_entity_id}
    Check Response Status Code Set To  207
    Check Response Body Set To  @{expected_entities_ids}

    #TODO call Batch Delete Entities
    Delete Entity by Id  ${first_entity_id}
    Delete Entity by Id  ${second_entity_id}
    Delete Entity by Id  urn:ngsi-ld:Building:92f041b428b9