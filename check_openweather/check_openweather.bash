#!/usr/bin/env bash

# A Check_MK "local" check to query the OpenWeather API and return 
#   important weather information.

# External variables file defining $LOCATION_ID and $APP_ID:
EXTERNAL_VARIABLES="./external_variables.bash"

# Temporary file to store data in:
TMP_FILE="/dev/shm/check_openweather.json"

# Hard-code units until per-unit code is developed:
OUTPUT_UNITS="imperial"

# "The status of a service is given as a number: 0 for OK, 1 for WARN,
#    2 for CRIT and 3 for UNKNOWN."
STATUS=3
# "The service name as shown in Checkmk. This may not contain blanks."
SERVICE_NAME="OpenWeather"
# "Performance values for the data. More information about the
#    construction can be found later below*. Alternatively a minus sign
#    can be coded if the check produces no metrics."
# * https://checkmk.com/cms_localchecks.html#perfdata
PERF_DATA="-"
# "Details for the status as they will be shown in Checkmk. This part
#    can also contain blanks."
CHECK_OUTPUT="UNKNOWN"

# Source external variables that should not be checked into git:
if [ -r $EXTERNAL_VARIABLES ]
  then
    source $EXTERNAL_VARIABLES
  else
    STATUS=3
    CHECK_OUTPUT="Unreadable or missing external variables file!"
fi

# Build OpenWeather URL:
BASE_URL_1="http://api.openweathermap.org/data/2.5/weather?id="
BASE_URL_2="&APPID="
BASE_URL_3="&units="
if [ $LOCATION_ID -a $APP_ID ]
  then
    BASE_URL=${BASE_URL_1}${LOCATION_ID}${BASE_URL_2}${APP_ID}${BASE_URL_3}${OUTPUT_UNITS}
  else
    STATUS=3
    CHECK_OUTPUT="Missing external variable(s)!"
fi

# Gather raw JSON input:
if [ $(which curl) ]
  then
    curl -s "$BASE_URL" -o "$TMP_FILE"
  else
    STATUS=3
    CHECK_OUTPUT="Missing required application: curl"
fi

# Parse the JSON into various values:
if [ $(which jq) ]
  then
    CONDITION=$(jq '.weather[0].main' $TMP_FILE)
    HUMIDITY=$(jq '.main.humidity' $TMP_FILE)
    PRESSURE=$(jq '.main.pressure' $TMP_FILE)
    TEMPERATURE=$(jq '.main.temp' $TMP_FILE)
    WIND_SPEED=$(jq '.wind.speed' $TMP_FILE)
    WIND_DIR=$(jq '.wind.deg' $TMP_FILE)
  else
    STATUS=3
    CHECK_OUTPUT="Missing required application: jq"
fi

# Remove the temporary file if it exists and is writable:
if [ -w $TMP_FILE ]
  then
    rm $TMP_FILE
    STATUS=0
  else
    STATUS=3
    CHECK_OUTPUT="Unable to remove temporary file!"
fi

# Reduce the pressure value by 1000 to make it easier to graph:
PRESSURE=$(expr $PRESSURE - 1000)

# Join CONDITION into one line if it comes through as two:
CONDITION=${CONDITION//$'\r'}

# Build performance data (https://checkmk.com/cms_localchecks.html#perfdata):
PERF_DATA="Humidity_PercentRelative=$HUMIDITY|Pressure_MillibarsFrom1000=$PRESSURE|Temperature_DegreesF=$TEMPERATURE|Windspeed_MPH=$WIND_SPEED|Winddirection_Degrees=$WIND_DIR"

# Build the check output:
CHECK_OUTPUT="OK - $CONDITION - $HUMIDITY % Relative Humidity - $PRESSURE mb from 1000 - $TEMPERATURE F - $WIND_SPEED MPH - $WIND_DIR bearing" # No need for alerts at this time.

# Return output:
echo "$STATUS $SERVICE_NAME $PERF_DATA $CHECK_OUTPUT"
