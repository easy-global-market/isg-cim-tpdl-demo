*** Keywords ***
Load Entity
    [Arguments]    ${entity_file_name}     ${entity_id}

    ${entity_payload}=    Load Json From File    ${EXECDIR}/data/entities/${entity_file_name}
    ${entity}=    Update Value To Json    ${entity_payload}     $..id   ${entity_id}

    [return]    ${entity}

Generate Random Entity Id
    [Arguments]    ${id_prefix}

    ${random_id}=     Generate Random String    16    [NUMBERS]
    ${entity_id}=    Catenate    ${id_prefix}${random_id}

    [return]    ${entity_id}