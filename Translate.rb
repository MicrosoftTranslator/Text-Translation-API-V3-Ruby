require 'net/https'
require 'uri'
require 'cgi'
require 'json'
require 'securerandom'

if (!ENV["TRANSLATOR_TEXT_SUBSCRIPTION_KEY"])
    raise "Please set/export the following environment variable: TRANSLATOR_TEXT_SUBSCRIPTION_KEY"
else
    subscription_key = ENV["TRANSLATOR_TEXT_SUBSCRIPTION_KEY"]
end
if (!ENV["TRANSLATOR_TEXT_ENDPOINT"])
    raise "Please set/export the following environment variable: TRANSLATOR_TEXT_ENDPOINT"
else
    endpoint = ENV["TRANSLATOR_TEXT_ENDPOINT"]
end

path = '/translate?api-version=3.0'

# Translate to German and Italian.
params = '&to=de&to=it'

uri = URI (endpoint + path + params)

text = 'Hello, world!'

content = '[{"Text" : "' + text + '"}]'

request = Net::HTTP::Post.new(uri)
request['Content-type'] = 'application/json'
request['Content-length'] = content.length
request['Ocp-Apim-Subscription-Key'] = subscription_key
request['X-ClientTraceId'] = SecureRandom.uuid
request.body = content

response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    http.request (request)
end

result = response.body.force_encoding("utf-8")

json = JSON.pretty_generate(JSON.parse(result))
puts json
