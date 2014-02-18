Blockfound
=========
Donations appreciated 19nvKuFF5B6SAhpi1L8PpJVn55QeWxBJC8

Blockfound will notify you when your pool finds a new block
  - Ruby
  - Support for [Pushover] - ios/android push notifications
  - Run via cron or irc bot
  - Data comes from blockchain.info API (or optionally slush API)

Version
----

2.0


Installation
--------------

```sh
gem install json
gem install yaml
git clone https://github.com/professoruss/blockfound.git
```

Command line options
---------------
```sh
--pool <Slush, BTC%Guild, Eligius> (Specify pool name from blockchain.info - use same case as https://blockchain.info/pools?timespan=24hrs, replace spaces with %20)
--oldschool (Get data from slush API instead of blockchain.info)
--output <cli, pushover> (specify the output, defaults to cli)
--help (uhh, help)
```

Run the damn thing!
---------------
output to console
```sh
ruby blockfound.rb --pool Slush
```

Push Notifications Via pushover
-------------------------------
enter your token and user into the yaml file
```sh
cd blockfound
vim pushover.yaml
```
push notifications
```sh
ruby blockfound.rb --pool Slush --output pushover
```

Run via cron
-----------
```sh
* * * * * sleep 1 ;ruby blockfound/blockfound.rb --pool Slush --output pushover > /dev/null 2>&1
```

License
----

MIT


[Pushover]:https://pushover.net
    
