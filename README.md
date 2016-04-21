
## system-rquery-bash

Push system metrics into rquery e.g. redishub.com


### Status

UNSTABLE


### Implementation

See: https://github.com/evanx/system-rquery-bash/bin


### Installation

```shell
git clone https://github.com/evanx/system-rquery-bash
```

### Usage

You can add this to your cron as follows:
```shell
* * * * * keyspace=mykeyspace hourlyMinute=0 dailyHour=0 ~/system-rquery-bash/bin/minutely.sh cron >> ~/tmp/cron.rquery.log 2>&1
```

You can check your keyspace 
```shell
echo curl -s redishub.com/rquery/ks/$USER/hgetall/host:`hostname -s`
```

### Related

Related projects and further plans: https://github.com/evanx/mpush-redis/blob/master/related.md

