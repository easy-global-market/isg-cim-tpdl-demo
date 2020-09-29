#!/bin/bash

#Run test
robot --outputdir ./results .

#Override binding on runtime
#robot --variable binding:"MQTT" --outputdir ./results_MQTT .
#robot --variable binding:"HTTP" --outputdir ./results_HTTP .