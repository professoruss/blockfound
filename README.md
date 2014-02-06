Blockfound
=========
Donations appreciated 19nvKuFF5B6SAhpi1L8PpJVn55QeWxBJC8

Blockfound will notify you when Slush's pool finds a new block
  - Ruby
  - Support for [Pushover] - ios/android push notifications
  - Run via cron or irc bot

Version
----

1.0


Installation
--------------

```sh
gem install json
gem install yaml
git clone https://github.com/professoruss/blockfound.git
```


Run the damn thing!
---------------
output to console
```sh
ruby blockfound.rb
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
ruby blockfound.rb pushover
```

Run via cron
-----------
```sh
* * * * * sleep 1 ;ruby blockfound/blockfound.rb pushover > /dev/null 2>&1
```

License
----

MIT


[Pushover]:https://pushover.net
    
