# Weather

**TODO: Retrieve current weather conditions from NOAA

## Run
`mix run -e 'Weather.CLI.main(["kpvu"])'`

or

```
$ mix escript.build
$ ./weather kpvu
```

## Description
This is my solution to the problem described in "Programming Elixir" at the end of Chapter 13.  The problem is as follows:


In the United States, the National Oceanic and Atmospheric Acministration provides hourly XML feeds of conditions at 1,800 locations.  For example, the feed for a small airport close to where I'm writing this is at http://w1.weather.gov/xml/current_obs/KPVU.html.

Write an application that fetches this data, parses it, and displays it in a nice format.

(Hint: you might not have to download a library to handle XML parsing.)


