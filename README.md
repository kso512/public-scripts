# public-scripts

Various scripts I've written or cobbled together

## check_openweather

A Check_MK "local" check to query the OpenWeather API and return important weather information.

### Requirements

This script requires the following:

- curl
- A writable folder, default to /dev/shm
- An OpenWeather API Application ID
- An OpenWeather Location ID
- An 'external_variables.bash' file, defining the last two

### Notes

This code does not work "out of the box" as the API I use bears rate limits which prevents sharing.  Creating an OpenWeather API account is free and can be done at the [OpenWeather Sign Up page](https://openweathermap.org/home/sign_up).

The format for the URL required is:

    http://://api.openweathermap.org/data/2.5/weather?id=<LOCATION_ID>&APPID=<APP_ID>&units=<OUTPUT_UNITS>

***<LOCATION_ID>*** & ***<APP_ID>*** come from your work based on signing up for and receiving API access, plus researching the appropriate location ID which is preferred over other formats.

***<OUTPUT_UNITS>*** will be hard-coded initially until I work in per-unit output.

The "external_variables.bash" file defines these variables and should be kept safe and private, away from public repositories.

A temporaray JSON file is used to parse data, by default under *\dev\shm* for speed and removal upon reboot.

### References

- [Local checks](http://mathias-kettner.com/checkmk_localchecks.html)
- [Weather API](https://openweathermap.org/api)
