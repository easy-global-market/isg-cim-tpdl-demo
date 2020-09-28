*** Settings ***
Variables    ./variables.py
Library      HttpCtrl.Client
Library      HttpCtrl.Server

*** Keywords ***
Check notification
    [Documentation]   Receive And Reply To POST
    
    #Initialize HTTP Client And Server
    Initialize Client   127.0.0.1   8000
    Start Server        127.0.0.1   8000

    #Receive And Reply To POST
    ${request body}=   Set Variable   { "message": "Hello!" }
    Send HTTP Request Async   POST   /post   ${request body}

    Wait For Request
    Reply By   200

    ${method}=   Get Request Method
    ${url}=      Get Request Url
    ${body}=     Get Request Body

    Should Be Equal   ${method}   POST
    Should Be Equal   ${url}      /post
    Should Be Equal   ${body}     ${request body}


    #Terminate HTTP Server
    Stop Server