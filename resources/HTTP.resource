*** Settings ***
Variables    ./variables.py
Library      HttpCtrl.Client
Library      HttpCtrl.Server

*** Keywords ***
Notify Broker
    [Documentation]   Receive And Reply To POST
    
    #Initialize HTTP Client And Server
    Initialize Client   127.0.0.1   8000
    Start Server        127.0.0.1   8000

    #HTTP client sends POST request to HTTP server 
    #.. "Send HTTP Request Async"
    #.... Non-blocking function to send request that waits for reply using separate thread. 
    #.... Further details: https://annoviko.github.io/robotframework-httpctrl/client.html#Send%20Http%20Request%20Async
    ${request body}=   Set Variable   { "message": "Hello!" }
    ${connection}=     Send HTTP Request Async   POST   /post   ${request body}

    #HTTP server receives it and checks incoming request for correctness
    #.. "Wait For Request"
    #.... This call is blocked until HTTP request arrives or timeout.
    #.... Further detaills: https://annoviko.github.io/robotframework-httpctrl/server.html#Wait%20For%20Request
    Wait For Request

    ${received_req_method}=   Get Request Method
    ${received_req_url}=      Get Request Url
    ${received_req_body}=     Get Request Body
    Should Be Equal   ${received_req_method}   POST
    Should Be Equal   ${received_req_url}      /post
    Should Be Equal   ${received_req_body}     ${request body}

    #HTTP server replies to the request and client checks response for correctness
    Reply By   200  

    ${response}=          Get Async Response         ${connection}   5
    ${response_status}=   Get Status From Response   ${response}
    ${expected status}=   Convert To Integer         200
    
    Should be Equal   ${response_status}   ${expected status}

    #Terminate HTTP Server
    Stop Server