*** Settings ***
Variables    ./variables.py
Library    MQTTLibrary

*** Variables ***
#docker pull eclipse-mosquitto
#docker run -d -p 1883:1883 eclipse-mosquitto
${broker.uri}=  127.0.0.1
${broker.port}=  1883
${client.id}=  mqtt.test.client
${topic}=  test/mqtt_test

*** Keywords ***
Check notification
    [Documentation]  Subscribe async, publish 1 message, listen for and validate it is received
    ${time}=  Get Time  epoch
    ${client}=  Catenate  SEPARATOR=.  robot.mqtt  ${time}
    ${topic}=  Set Variable  test/mqtt_test_sub
    Subscribe Async  client.id=${client}  topic=${topic}
    Publish to MQTT Broker  topic=${topic}  message=test message  qos=1
    @{messages}=  Listen and Get Messages  topic=${topic}
    LOG  ${messages}
    Length Should Be  ${messages}  1
    Should Be Equal As Strings  ${messages}[0]  test message
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