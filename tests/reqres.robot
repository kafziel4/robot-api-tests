*** Settings ***
Documentation       ReqRes API Test Suite

Library             RequestsLibrary
Resource            ../resources/base.resource


*** Variables ***
${HOST}                     https://reqres.in/api
${CONTENT_TYPE}             content-type
${CONTENT_lENGTH}           content-length
${APPLICATION_JSON}         application/json; charset=utf-8
${ONE_TO_THREE_DIGITS}      ^\\d{1,3}$
${DATE_IN_ISO_FORMAT}       ^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}.\\d{3}Z$


*** Test Cases ***
GET to /users should return status 200 and a list of users
    &{params}    Create Dictionary    page=2

    ${response}    GET    url=${HOST}/users    params=&{params}    expected_status=200
    Header Should Be    ${response}    ${CONTENT_TYPE}    ${APPLICATION_JSON}

    &{content}    Get JSON content    ${response}
    Should Be Equal    ${content.page}    ${2}
    Should Be Equal    ${content.per_page}    ${6}
    Should Be Equal    ${content.total}    ${12}
    Should Be Equal    ${content.total_pages}    ${2}

    ${length}    Get Length    ${content.data}
    Should Be Equal    ${length}    ${6}

    FOR    ${i}    IN RANGE    ${length}
        Should Be Equal    ${content.data}[${i}][id]    ${USERS}[${i}][id]
        Should Be Equal    ${content.data}[${i}][email]    ${USERS}[${i}][email]
        Should Be Equal    ${content.data}[${i}][first_name]    ${USERS}[${i}][first_name]
        Should Be Equal    ${content.data}[${i}][last_name]    ${USERS}[${i}][last_name]
        Should Be Equal    ${content.data}[${i}][avatar]    ${USERS}[${i}][avatar]
    END

GET to /users/id for an existing user should return status 200 and the user data
    &{expected_data}    Create Dictionary
    ...    id=${2}
    ...    email=janet.weaver@reqres.in
    ...    first_name=Janet
    ...    last_name=Weaver
    ...    avatar=https://reqres.in/img/faces/2-image.jpg

    ${response}    GET    url=${HOST}/users/2    expected_status=200
    Header Should Be    ${response}    ${CONTENT_TYPE}    ${APPLICATION_JSON}

    &{content}    Get JSON content    ${response}
    Should Be Equal    ${content.data.id}    ${expected_data.id}
    Should Be Equal    ${content.data.email}    ${expected_data.email}
    Should Be Equal    ${content.data.first_name}    ${expected_data.first_name}
    Should Be Equal    ${content.data.last_name}    ${expected_data.last_name}
    Should Be Equal    ${content.data.avatar}    ${expected_data.avatar}

GET to /users/id for a user that does not exist should return status 404
    ${response}    GET    url=${HOST}/users/23    expected_status=404
    Header Should Be    ${response}    ${CONTENT_TYPE}    ${APPLICATION_JSON}
    Should Be Empty    ${response.json()}

GET to /colors should return status 200 and a list of colors
    ${response}    GET    url=${HOST}/colors    expected_status=200
    Header Should Be    ${response}    ${CONTENT_TYPE}    ${APPLICATION_JSON}

    &{content}    Get JSON content    ${response}
    Should Be Equal    ${content.page}    ${1}
    Should Be Equal    ${content.per_page}    ${6}
    Should Be Equal    ${content.total}    ${12}
    Should Be Equal    ${content.total_pages}    ${2}

    ${length}    Get Length    ${content.data}
    Should Be Equal    ${length}    ${6}

    FOR    ${i}    IN RANGE    ${length}
        Should Be Equal    ${content.data}[${i}][id]    ${COLORS}[${i}][id]
        Should Be Equal    ${content.data}[${i}][name]    ${COLORS}[${i}][name]
        Should Be Equal    ${content.data}[${i}][year]    ${COLORS}[${i}][year]
        Should Be Equal    ${content.data}[${i}][color]    ${COLORS}[${i}][color]
        Should Be Equal    ${content.data}[${i}][pantone_value]    ${COLORS}[${i}][pantone_value]
    END

GET to /colors/id for an existing color should return status 200 and the color data
    &{expected_data}    Create Dictionary
    ...    id=${2}
    ...    name=fuchsia rose
    ...    year=${2001}
    ...    color=#C74375
    ...    pantone_value=17-2031

    ${response}    GET    url=${HOST}/colors/2    expected_status=200
    Header Should Be    ${response}    ${CONTENT_TYPE}    ${APPLICATION_JSON}

    &{content}    Get JSON content    ${response}
    Should Be Equal    ${content.data.id}    ${expected_data.id}
    Should Be Equal    ${content.data.name}    ${expected_data.name}
    Should Be Equal    ${content.data.year}    ${expected_data.year}
    Should Be Equal    ${content.data.color}    ${expected_data.color}
    Should Be Equal    ${content.data.pantone_value}    ${expected_data.pantone_value}

GET to /colors/id for a color that does not exist should return status 404
    ${response}    GET    url=${HOST}/colors/23    expected_status=404
    Header Should Be    ${response}    ${CONTENT_TYPE}    ${APPLICATION_JSON}
    Should Be Empty    ${response.json()}

POST to /users with valid data should return status 201 and the user data
    &{request_data}    Create Dictionary
    ...    name=morpheus
    ...    job=leader

    ${response}    POST    url=${HOST}/users    json=&{request_data}    expected_status=201
    Header Should Be    ${response}    ${CONTENT_TYPE}    ${APPLICATION_JSON}

    &{content}    Get JSON content    ${response}
    Should Be Equal    ${content.name}    ${request_data.name}
    Should Be Equal    ${content.job}    ${request_data.job}
    Should Match Regexp    ${content.id}    ${one_to_three_digits}
    Should Match Regexp    ${content.createdAt}    ${DATE_IN_ISO_FORMAT}

PUT to /users/id for an existing user with valid data should return status 200 and the user data
    &{request_data}    Create Dictionary
    ...    name=morpheus
    ...    job=zion resident

    ${response}    PUT    url=${HOST}/users/2    json=&{request_data}    expected_status=200
    Header Should Be    ${response}    ${CONTENT_TYPE}    ${APPLICATION_JSON}

    &{content}    Get JSON content    ${response}
    Should Be Equal    ${content.name}    ${request_data.name}
    Should Be Equal    ${content.job}    ${request_data.job}
    Should Match Regexp    ${content.updatedAt}    ${DATE_IN_ISO_FORMAT}

PATCH to /users/id for an existing user with valid data should return status 200 and the user data
    &{request_data}    Create Dictionary
    ...    name=morpheus
    ...    job=zion resident

    ${response}    PATCH    url=${HOST}/users/2    json=&{request_data}    expected_status=200
    Header Should Be    ${response}    ${CONTENT_TYPE}    ${APPLICATION_JSON}

    &{content}    Get JSON content    ${response}
    Should Be Equal    ${content.name}    ${request_data.name}
    Should Be Equal    ${content.job}    ${request_data.job}
    Should Match Regexp    ${content.updatedAt}    ${DATE_IN_ISO_FORMAT}

DELETE to /users/id for an existing user should return status 204
    ${response}    DELETE    url=${HOST}/users/2    expected_status=204
    Header Should Be    ${response}    ${CONTENT_lENGTH}    0

POST to /register with valid data should return status 200 and the registration id and token
    &{request_data}    Create Dictionary
    ...    email=eve.holt@reqres.in
    ...    password=pistol

    ${response}    POST    url=${HOST}/register    json=&{request_data}    expected_status=200
    Header Should Be    ${response}    ${CONTENT_TYPE}    ${APPLICATION_JSON}

    &{content}    Get JSON content    ${response}
    Should Be Equal    ${content.id}    ${4}
    Should Be Equal    ${content.token}    QpwL5tke4Pnpja7X4

POST to /register with missing password should return status 400 and the validation error
    &{request_data}    Create Dictionary    email=sydney@fife

    ${response}    POST    url=${HOST}/register    json=&{request_data}    expected_status=400
    Header Should Be    ${response}    ${CONTENT_TYPE}    ${APPLICATION_JSON}

    &{content}    Get JSON content    ${response}
    Should Be Equal    ${content.error}    Missing password

POST to /login with valid data should return status 200 and the login token
    &{request_data}    Create Dictionary
    ...    email=eve.holt@reqres.in
    ...    password=pistol

    ${response}    POST    url=${HOST}/login    json=&{request_data}    expected_status=200
    Header Should Be    ${response}    ${CONTENT_TYPE}    ${APPLICATION_JSON}

    &{content}    Get JSON content    ${response}
    Should Be Equal    ${content.token}    QpwL5tke4Pnpja7X4

POST to /login with missing password should return status 400 and the validation error
    &{request_data}    Create Dictionary    email=peter@klaven

    ${response}    POST    url=${HOST}/login    json=&{request_data}    expected_status=400
    Header Should Be    ${response}    ${CONTENT_TYPE}    ${APPLICATION_JSON}

    &{content}    Get JSON content    ${response}
    Should Be Equal    ${content.error}    Missing password


*** Keywords ***
Header Should Be
    [Arguments]    ${response}    ${header}    ${expected}
    Should Be Equal    ${response.headers}[${header}]    ${expected}

Get JSON content
    [Arguments]    ${response}
    &{content}    Set Variable    ${response.json()}
    RETURN    &{content}
