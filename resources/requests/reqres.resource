*** Settings ***
Documentation       Requests for ReqRes API

Library             RequestsLibrary


*** Variables ***
${HOST}             https://reqres.in/api
${USERS_PATH}       users
${COLORS_PATH}      colors
${REGISTER_PATH}    register
${LOGIN_PATH}       login


*** Keywords ***
Get Users
    [Arguments]    ${page}
    &{params}    Create Dictionary    page=${page}
    ${response}    GET    url=${HOST}/${USERS_PATH}    params=&{params}    expected_status=any
    RETURN    ${response}

Get Single User
    [Arguments]    ${id}
    ${response}    GET    url=${HOST}/${USERS_PATH}/${id}    expected_status=any
    RETURN    ${response}

Post User
    [Arguments]    ${body}
    ${response}    POST    url=${HOST}/${USERS_PATH}    json=&{body}    expected_status=any
    RETURN    ${response}

Put User
    [Arguments]    ${id}    ${body}
    ${response}    PUT    url=${HOST}/${USERS_PATH}/${id}    json=&{body}    expected_status=any
    RETURN    ${response}

Patch User
    [Arguments]    ${id}    ${body}
    ${response}    PATCH    url=${HOST}/${USERS_PATH}/${id}    json=&{body}    expected_status=any
    RETURN    ${response}

Delete User
    [Arguments]    ${id}
    ${response}    DELETE    url=${HOST}/${USERS_PATH}/${id}    expected_status=any
    RETURN    ${response}

Get Colors
    ${response}    GET    url=${HOST}/${COLORS_PATH}    expected_status=any
    RETURN    ${response}

Get Single Color
    [Arguments]    ${id}
    ${response}    GET    url=${HOST}/${COLORS_PATH}/${id}    expected_status=any
    RETURN    ${response}

Post Register
    [Arguments]    ${body}
    ${response}    POST    url=${HOST}/${REGISTER_PATH}    json=&{body}    expected_status=any
    RETURN    ${response}

Post Login
    [Arguments]    ${body}
    ${response}    POST    url=${HOST}/${LOGIN_PATH}    json=&{body}    expected_status=any
    RETURN    ${response}
