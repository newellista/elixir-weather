defmodule Weather.CLI do

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
      { _, [ airport ], _ } -> { airport }
      _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: weather <airport_code> # see http://w1.weather.gov/xml/current_obs for codes
    """
    
    System.halt(0)
  end

  def process( { airport } ) do
    Weather.WeatherReport.fetch(airport)
      |> decode_response
      |> print_current_conditions
  end

  def decode_response(body), do: body

  def print_current_conditions(conditions) do
    IO.puts "Current weather conditions at #{conditions.location} are #{conditions.weather}"
    IO.puts "Temperature: #{conditions.temperature_string}"
    IO.puts "Wind is #{conditions.wind_string}"
    IO.puts "Relative humidity: #{conditions.relative_humidity}"
  end
end
