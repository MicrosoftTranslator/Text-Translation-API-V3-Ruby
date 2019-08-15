require 'net/https'
require 'uri'
require 'cgi'
require 'json'

if (!ENV["TRANSLATOR_TEXT_ENDPOINT"])
    raise "Please set/export the following environment variable: TRANSLATOR_TEXT_ENDPOINT"
else
    endpoint = ENV["TRANSLATOR_TEXT_ENDPOINT"]
end

path = '/languages?api-version=3.0'

uri = URI (endpoint + path)

request = Net::HTTP::Get.new(uri)

response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    http.request (request)
end

result = response.body.force_encoding("utf-8")

json = JSON.pretty_generate(JSON.parse(result))

output_path = 'output.txt'

# Write response to file
File.open(output_path, 'w' ) do |output|
    output.print json
end
