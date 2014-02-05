require 'rubygems'
require 'json'
require 'open-uri'

  result = JSON.load(open("http://mining.bitcoin.cz/stats/json/"))

  gh = result["ghashes_ps"]
  cur_dur = result["round_duration"]
  a = Time.parse cur_dur
  b = a.strftime("%T")
  one = Time.local(2000,"jan",1,00,01,00)
  strpone = one.strftime("%T")
  if(b < strpone)
    puts "Found new block! #{gh}GH/s"
  end
