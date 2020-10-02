#!/bin/bash

#Run test
robot --outputdir ./results .

#Override binding on runtime
#robot --variable binding:"MQTT" --outputdir ./results_MQTT .
#robot --variable binding:"HTTP" --outputdir ./results_HTTP .

#Gather results from both runs in the same report
#rebot ./results_HTTP/output.xml ./results_MQTT/output.xml

#Generate allure report
#robot --variable binding:"MQTT" --listener allure_robotframework .
#allure generate . 
#allure open allure-report  