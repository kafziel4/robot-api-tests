*** Settings ***
Documentation       ReqRes API Users endpoints Test Suite

Resource            ../resources/base.resource


*** Test Cases ***
GET to /users should return status 200 and a list of users
    ${page}    Set Variable    2
    ${expected_page}    Set Variable    ${USERS_PAGE}
    ${expected_data}    Set Variable    ${USERS_DATA}

    ${response}    Get Users    page=${page}

    Status Should Be    200    ${response}
    Header Should Be    ${response}    ${CONTENT_TYPE}    ${APPLICATION_JSON}

    &{content}    Get JSON content    ${response}
    Dictionary Should Contain Sub Dictionary    ${content}    ${expected_page}
    Lists Should Be Equal    ${content.data}    ${expected_data}

GET to /users/id for an existing user should return status 200 and the user data
    &{expected_data}    Create Dictionary
    ...    id=${2}
    ...    email=janet.weaver@reqres.in
    ...    first_name=Janet
    ...    last_name=Weaver
    ...    avatar=https://reqres.in/img/faces/2-image.jpg

    ${response}    Get Single User    id=${expected_data.id}

    Status Should Be    200    ${response}
    Header Should Be    ${response}    ${CONTENT_TYPE}    ${APPLICATION_JSON}

    &{content}    Get JSON content    ${response}
    Dictionaries Should Be Equal    ${content.data}    ${expected_data}

GET to /users/id for a user that does not exist should return status 404
    ${id}    Set Variable    23

    ${response}    Get Single User    id=${id}

    Status Should Be    404    ${response}
    Header Should Be    ${response}    ${CONTENT_TYPE}    ${APPLICATION_JSON}

    &{content}    Get JSON content    ${response}
    Should Be Empty    ${content}

POST to /users with valid data should return status 201 and the user data
    &{request_body}    Create Dictionary
    ...    name=morpheus
    ...    job=leader

    ${response}    Post User    body=${request_body}

    Status Should Be    201    ${response}
    Header Should Be    ${response}    ${CONTENT_TYPE}    ${APPLICATION_JSON}

    &{content}    Get JSON content    ${response}
    Dictionary Should Contain Sub Dictionary    ${content}    ${request_body}
    Should Match Regexp    ${content.id}    ${ONE_TO_THREE_DIGITS}
    Should Match Regexp    ${content.createdAt}    ${DATE_IN_ISO_FORMAT}

PUT to /users/id for an existing user with valid data should return status 200 and the user data
    ${id}    Set Variable    2
    &{request_body}    Create Dictionary
    ...    name=morpheus
    ...    job=zion resident

    ${response}    Put User    id=${id}    body=${request_body}

    Status Should Be    200    ${response}
    Header Should Be    ${response}    ${CONTENT_TYPE}    ${APPLICATION_JSON}

    &{content}    Get JSON content    ${response}
    Dictionary Should Contain Sub Dictionary    ${content}    ${request_body}
    Should Match Regexp    ${content.updatedAt}    ${DATE_IN_ISO_FORMAT}

PATCH to /users/id for an existing user with valid data should return status 200 and the user data
    ${id}    Set Variable    2
    &{request_body}    Create Dictionary
    ...    name=morpheus
    ...    job=zion resident

    ${response}    Patch User    id=${id}    body=${request_body}

    Status Should Be    200    ${response}
    Header Should Be    ${response}    ${CONTENT_TYPE}    ${APPLICATION_JSON}

    &{content}    Get JSON content    ${response}
    Dictionary Should Contain Sub Dictionary    ${content}    ${request_body}
    Should Match Regexp    ${content.updatedAt}    ${DATE_IN_ISO_FORMAT}

DELETE to /users/id for an existing user should return status 204
    ${id}    Set Variable    2

    ${response}    Delete User    id=${id}

    Status Should Be    204    ${response}
    Header Should Be    ${response}    ${CONTENT_LENGTH}    0
