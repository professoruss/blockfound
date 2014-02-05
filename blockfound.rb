require 'rubygems'
require 'json'
require 'open-uri'
require 'yaml'
require 'net/https'

  result = JSON.load(open("http://mining.bitcoin.cz/stats/json/"))

  #pool speed
  gh = result["ghashes_ps"]
  #current round's duration
  cur_dur = result["round_duration"]
  #convert duration to a proper timestamp
  a = Time.parse cur_dur
  #strip out the date portion
  b = a.strftime("%T")
  #get a new value of one minute past one jan 1 2000
  one = Time.local(2000,"jan",1,00,01,00)
  #strip out the date portion
  strpone = one.strftime("%T")

  #get all blocks
  blocks = result["blocks"]
  #get the keys, sort them and get the last one
  foo = blocks.keys.sort.last
  #get the data from the last round
  lastround = blocks[foo]
  #get how long the last round took
  duration = lastround["mining_duration"]
  message = "Found new block!! Elapsed: #{duration} Hashrate: #{gh}GH/s"
  if(b > strpone)
    #pushover notifications
    if ARGV[0] == 'pushover'
      yaml = YAML.load_file('pushover.yaml')
      url = URI.parse("https://api.pushover.net/1/messages.json")
      req = Net::HTTP::Post.new(url.path)
      req.set_form_data({
        :token => "#{yaml['token']}",
        :user => "#{yaml['user']}",
        :message => "#{message}",
      })
      res = Net::HTTP.new(url.host, url.port)
      res.use_ssl = true
      res.verify_mode = OpenSSL::SSL::VERIFY_PEER
      res.start {|http| http.request(req) }

      exit
    end
    puts message
  end
