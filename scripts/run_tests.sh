#!/bin/bash

#Run test
robot --outputdir ./results .

#Override binding on runtime
#robot --variable binding:"HTTP" --outputdir ./results .