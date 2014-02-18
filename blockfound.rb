require 'rubygems'
require 'json'
require 'open-uri'
require 'yaml'
require 'net/https'
require 'optparse'

  values = {}
  parser = OptionParser.new do |opts|
    opts.on("--pool VAL", "Specify pool name from blockchain.info - use same case as https://blockchain.info/pools?timespan=24hrs, replace spaces with %20") { |val| values[:pool] = val }
    opts.on("--oldschool", "Get data from slush API instead of blockchain.info") { |val| values[:oldschool] = val }
    opts.on("--output VAL", "How to output data, defaults to cli, options are cli, pushover") { |val| values[:output] = val }
    opts.on("--help", "Show this help") do
      puts opts
      exit
    end
  end
  parser.parse!

  args = values.to_json
  res = JSON.parse(args)

  #validate if pool is set
  if args["pool"].nil?
    puts "need to specify a pool (--help for usage)"
  end

  #default output to cli if not specified
  if args["output"].nil?
    res["output"] = "cli"
  end

  #validate we have a correct output type
  output = res["output"]
  output_opts = /cli|pushover/
  oo = output_opts.match(output)
  unless oo
    puts 'Invalid output, try "cli" or "pushover"'
    exit
  end

  #get a new value of one minute past one jan 1 2000
  one = Time.local(2000,"jan",1,00,01,00)
  #strip out the date portion
  strpone = one.strftime("%T")

  #slush api section
  oldschool = res["oldschool"]
  if oldschool == true
    #slush specific
    result = JSON.load(open("http://mining.bitcoin.cz/stats/json/"))

    #pool speed
    gh = result["ghashes_ps"]
    #current round's duration
    cur_dur = result["round_duration"]
    #convert duration to a proper timestamp
    a = Time.parse cur_dur
    #strip out the date portion
    b = a.strftime("%T")

    #get all blocks
    blocks = result["blocks"]
    #get the keys, sort them and get the last one
    foo = blocks.keys.sort.last
    #get the data from the last round
    lastround = blocks[foo]
    #get how long the last round took
    duration = lastround["mining_duration"]
    message = "Found new block!! Elapsed: #{duration} Hashrate: #{gh}GH/s (via slush api)"
  else
    pool = res["pool"]
    bcurl = "http://blockchain.info/blocks/#{pool}?format=json"
    #clean up %20 if present
    pool_name = res["pool"]
    pool_name.gsub!('%20', ' ')
    bc_pjson = JSON.load(open(bcurl))
    bc_latest_height = bc_pjson["blocks"][0]["height"]
    bc_latest_time = Time.at(bc_pjson["blocks"][0]["time"]).utc
    bc_second_time = Time.at(bc_pjson["blocks"][1]["time"]).utc
    local_time = Time.now.utc
    elapsed = (bc_latest_time - bc_second_time).to_i
    elapsed_min = elapsed.to_i / 60
    elapsed_hrs = elapsed_min.to_i / 60
    elapsed_time = "#{elapsed_hrs}:#{elapsed_min % 60}:#{elapsed % 60}"
    current = (local_time - bc_latest_time).to_i
    current_min = current.to_i / 60
    current_hrs = current_min.to_i / 60
    a = Time.local(2000,"jan",1,"#{current_hrs}:#{current_min % 60}:#{current % 60}")
    b = a.strftime("%T")
    message = "#{pool_name} found block #{bc_latest_height} in #{elapsed_time}!! (via blockchain api)"
  end



  if(b > strpone)
    #pushover notifications
    if output == 'pushover'
      #get current path so we can detect the yaml file
      script_path = File.expand_path(File.dirname(__FILE__))
      yaml = YAML.load_file("#{script_path}/pushover.yaml")
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
    if output == 'cli'
      puts message
    end
  end
