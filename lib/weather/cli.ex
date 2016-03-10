defmodule Weather.CLI do
  import Weather.WeatherReport, only: [fetch: 1]

  def main(argv) do
    argv
      |> parse_args
      |> process
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean],
                                     aliases: [h: :help])

    case parse do
      { [ help: true ], _, _ } -> :help
      { _, [ airport ], _ } -> airport
      _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: weather <airport_code> # see http://w1.weather.gov/xml/current_obs for codes
    """

    System.halt(0)
  end

  def process(airport) do
    fetch(airport)
      |> print_response
  end

  def print_response({:error, reason}) do
    IO.puts "Error: #{reason}"
  end

  def print_response({:ok, conditions}) do
    IO.puts ~s"""
    Current weather conditions at #{conditions.location} are #{conditions.weather}
    Temperature: #{conditions.temperature_string}
    Wind is #{conditions.wind_string}
    Relative humidity: #{conditions.relative_humidity}
    """
  end
end
