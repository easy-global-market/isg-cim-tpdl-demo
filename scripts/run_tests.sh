#!/bin/bash

#run all tests
robot --outputdir ./results .

#run all tests with base url overriden
robot --variable url:"URL_HERE" --outputdir ./results .

#specify which tests are critical
robot --critical critical --outputdir ./results .

#run by specific tag(s)
robot --include critical --outputdir ./results .
robot --include critical --include negative --outputdir ./results .

#run specific test suite
robot --outputdir ./results ./TP/NGSI-LD/ContextInformation
robot --outputdir ./results ./TP/NGSI-LD/ContextInformation/Provision/Entities/CreateEntity_200.robot

#run specific test case
robot --outputdir ./results -t "CreateEntity_200_MINIMAL" ./TP/NGSI-LD/ContextInformation/Provision/Entities/CreateEntity_200.robot

#rerun failed tests
robot --rerunfailedsuites ./results/output.xml  --outputdir ./results .
