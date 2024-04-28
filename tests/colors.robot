*** Settings ***
Documentation       ReqRes API Colors endpoints Test Suite

Resource            ../resources/base.resource


*** Test Cases ***
GET to /colors should return status 200 and a list of colors
    ${expected_page}    Set Variable    ${COLORS_PAGE}
    ${expected_data}    Set Variable    ${COLORS_DATA}

    ${response}    Get Colors

    Status Should Be    200    ${response}
    Header Should Be    ${response}    ${CONTENT_TYPE}    ${APPLICATION_JSON}

    &{content}    Get JSON content    ${response}
    Dictionary Should Contain Sub Dictionary    ${content}    ${expected_page}
    Lists Should Be Equal    ${content.data}    ${expected_data}

GET to /colors/id for an existing color should return status 200 and the color data
    &{expected_data}    Create Dictionary
    ...    id=${2}
    ...    name=fuchsia rose
    ...    year=${2001}
    ...    color=#C74375
    ...    pantone_value=17-2031

    ${response}    Get Single Color    id=${expected_data.id}

    Status Should Be    200    ${response}
    Header Should Be    ${response}    ${CONTENT_TYPE}    ${APPLICATION_JSON}

    &{content}    Get JSON content    ${response}
    Dictionaries Should Be Equal    ${content.data}    ${expected_data}

GET to /colors/id for a color that does not exist should return status 404
    ${id}    Set Variable    23

    ${response}    Get Single Color    id=${id}

    Status Should Be    404    ${response}
    Header Should Be    ${response}    ${CONTENT_TYPE}    ${APPLICATION_JSON}

    &{content}    Get JSON content    ${response}
    Should Be Empty    ${content}
