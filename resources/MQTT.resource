*** Settings ***
Variables    ./variables.py
Library    MQTTLibrary

#MQTT Broker instructions
#>> docker pull eclipse-mosquitto
#>> docker run -d -p 1883:1883 eclipse-mosquitto

*** Variables ***
${broker.uri}=  127.0.0.1
${broker.port}=  1883
${client.id}=  mqtt.test.client
${topic}=  test/mqtt_test

*** Keywords ***
Notify Broker
    [Documentation]  Subscribe async, publish 1 message, listen for and validate it is received
    ${time}=  Get Time  epoch
    ${client}=  Catenate  SEPARATOR=.  robot.mqtt  ${time}
    ${topic}=  Set Variable  test/mqtt_test_sub
    
    #Subscribe topic async (with background looping)
    Subscribe Async  client.id=${client}  topic=${topic}
    
    #Publish one message to MQTT Broker
    Publish to MQTT Broker  topic=${topic}  message=test message  qos=1
    
    #Listen to the topic and return a list of message payloads received within the specified time
    #.. Requires an async Subscribe to have been called previously
    @{messages}=  Listen and Get Messages  topic=${topic}
    LOG  ${messages}

    #Validate received message
    Length Should Be  ${messages}  1
    Should Be Equal As Strings  ${messages}[0]  test message

    #Unsubscribe the client from the specified topic
    #Disconnect from MQTT Broker
    [Teardown]  Unsubscribe and Disconnect  ${topic}

Subscribe Async
    [Arguments]  ${broker.uri}=${broker.uri}  ${port}=${broker.port}  ${client.id}=${client.id}  ${topic}=${topic}  ${qos}=1  ${timeout}=0s  ${limit}=1
    Connect  ${broker.uri}  ${port}  ${client.id}  ${false}
    Subscribe  ${topic}  ${qos}  ${timeout}  ${limit}

Publish to MQTT Broker
    [Arguments]  ${broker.uri}=${broker.uri}  ${port}=${broker.port}  ${client.id}=${client.id}  ${clean_session}=${true}  ${topic}=${topic}  ${message}=${EMPTY}  ${qos}=0  ${retention}=${false}
    Connect  ${broker.uri}  ${port}  ${client.id}  ${clean_session}
    Publish  ${topic}  ${message}  ${qos}  ${retention}

Listen and Get Messages
    [Arguments]  ${topic}=${topic}  ${timeout}=1s  ${limit}=1
    @{messages}=  Listen  ${topic}  ${timeout}  ${limit}
    [Return]  @{messages}

Unsubscribe and Disconnect
    [Arguments]  ${topic}=${topic}
    Unsubscribe  ${topic}
    [Teardown]  Disconnect