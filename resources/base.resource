*** Settings ***
Documentation       Main resource file

Library             Collections
Variables           fixtures/users.py
Variables           fixtures/colors.py
Resource            requests/reqres.resource


*** Variables ***
${CONTENT_TYPE}             content-type
${CONTENT_LENGTH}           content-length
${APPLICATION_JSON}         application/json; charset=utf-8
${MISSING_PASSWORD}         Missing password
${ONE_TO_THREE_DIGITS}      ^\\d{1,3}$
${DATE_IN_ISO_FORMAT}       ^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}.\\d{3}Z$
@{IGNORED}                  support


*** Keywords ***
Header Should Be
    [Arguments]    ${response}    ${header}    ${expected}
    Should Be Equal    ${response.headers}[${header}]    ${expected}

Get JSON content
    [Arguments]    ${response}
    ${content}    Set Variable    ${response.json()}
    RETURN    ${content}
