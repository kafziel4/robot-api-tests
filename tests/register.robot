*** Settings ***
Documentation       ReqRes API Register endpoints Test Suite

Resource            ../resources/base.resource


*** Test Cases ***
POST to /register with valid data should return status 200 and the registration id and token
    &{request_body}    Create Dictionary
    ...    email=eve.holt@reqres.in
    ...    password=pistol

    &{expecxted_response}    Create Dictionary
    ...    id=${4}
    ...    token=QpwL5tke4Pnpja7X4

    ${response}    Post Register    body=${request_body}

    Status Should Be    200    ${response}
    Header Should Be    ${response}    ${CONTENT_TYPE}    ${APPLICATION_JSON}

    &{content}    Get JSON content    ${response}
    Dictionaries Should Be Equal    ${content}    ${expecxted_response}

POST to /register with missing password should return status 400 and the validation error
    &{request_body}    Create Dictionary    email=sydney@fife
    &{expected_response}    Create Dictionary    error=${MISSING_PASSWORD}

    ${response}    Post Register    body=${request_body}

    Status Should Be    400    ${response}
    Header Should Be    ${response}    ${CONTENT_TYPE}    ${APPLICATION_JSON}

    &{content}    Get JSON content    ${response}
    Dictionaries Should Be Equal    ${content}    ${expected_response}
