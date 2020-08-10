#!/usr/bin/env bash

# A Check_MK "local" check to query the OpenWeather API and return 
#   important weather information.

# "The status of a service is given as a number: 0 for OK, 1 for WARN,
#    2 for CRIT and 3 for UNKNOWN."
STATUS=0
# "The service name as shown in Checkmk. This may not contain blanks."
SERVICE_NAME="OpenWeather"
# "Performance values for the data. More information about the
#   construction can be found later below. Alternatively a minus sign
#   can be coded if the check produces no metrics."
PERF_DATA="-"
# "Details for the status as they will be shown in Checkmk. This part
#   can also contain blanks."
CHECK_OUTPUT="OK"

# Return output:
echo "$STATUS $SERVICE_NAME $PERF_DATA $CHECK_OUTPUT"
