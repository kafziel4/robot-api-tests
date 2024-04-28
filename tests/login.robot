*** Settings ***
Documentation       ReqRes API Login endpoints Test Suite

Resource            ../resources/base.resource


*** Test Cases ***
POST to /login with valid data should return status 200 and the login token
    &{request_body}    Create Dictionary
    ...    email=eve.holt@reqres.in
    ...    password=pistol

    &{expected_response}    Create Dictionary    token=QpwL5tke4Pnpja7X4

    ${response}    Post Login    body=${request_body}

    Status Should Be    200    ${response}
    Header Should Be    ${response}    ${CONTENT_TYPE}    ${APPLICATION_JSON}

    &{content}    Get JSON content    ${response}
    Dictionaries Should Be Equal    ${content}    ${expected_response}

POST to /login with missing password should return status 400 and the validation error
    &{request_body}    Create Dictionary    email=peter@klaven
    &{expected_response}    Create Dictionary    error=${MISSING_PASSWORD}

    ${response}    Post Login    body=${request_body}

    Status Should Be    400    ${response}
    Header Should Be    ${response}    ${CONTENT_TYPE}    ${APPLICATION_JSON}

    &{content}    Get JSON content    ${response}
    Dictionaries Should Be Equal    ${content}    ${expected_response}
