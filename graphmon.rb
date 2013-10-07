#!/usr/bin/env ruby
require 'json'
require 'pp'

def alerti(value)
  message = "alert threshold exceeded at #{value}"
  puts
  puts message
  `say "#{message}"`
end

server = 'wwwpr04_dfw_thoughtworks_com'
threshold = 50
threshold = ARGV[0].to_f if ARGV[0]
puts "threshold: #{threshold}"
puts "server: #{server}"

while(true) do
  json = `curl --silent "http://localhost:8190/render?target=collectd.#{server}.cpu-0.cpu-wait.value&rawData=true&format=json&from=-1min"`
  data = JSON.parse(json)
  values = data.first['datapoints'].collect {|x| x.first}.select {|x| x}
  print "."
  alerti(values.max) if values.max > threshold 
  sleep 5
end

