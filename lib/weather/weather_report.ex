
defmodule Weather.WeatherReport do
  require Record

  @user_agent [ {"User-agent", "Elixir newellista@gmail.com"} ]
  @needed_fields ~w(location weather temperature_string relative_humidity wind_string)

  Record.defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")

  def airport_url(airport) do
    "http://w1.weather.gov/xml/current_obs/#{String.upcase(airport)}.xml"
  end

  def extract_node(xml, node_name) do
    [element]  = :xmerl_xpath.string(String.to_char_list("/current_observation/#{node_name}"), xml)
    [text] = xmlElement(element, :content)
    value = xmlText(text, :value)
    { String.to_atom(node_name), to_string(value) }
  end

  def fetch(airport) do
    airport_url(airport)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def handle_response({:ok, %HTTPoison.Response{ status_code: 200, body: body}}) do
    body
    |> scan_response
    |> parse_xml
  end

  def handle_response({:ok, %HTTPoison.Response{ status_code: 404}}), do: { :error, "Not Found" }
  def handle_response({:error, %HTTPoison.Error{reason: reason}}) do
    IO.puts "#{reason}"
  end
  
  def parse_xml({xml, _}) do
    Enum.into(@needed_fields, %{}, fn node_name -> extract_node(xml, node_name) end)
  end

  def scan_response(xml) do
    :xmerl_scan.string(String.to_char_list(xml))
  end
end
