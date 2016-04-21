
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
* * * * * keyspace=MYKEYSPACE hourlyMinute=0 dailyHour=0 ~/system-rquery-bash/bin/minutely.sh cron >> ~/tmp/cron.rquery.log 2>&1
```
where you must specify your keyspace, i.e. substitute `MYKEYSPACE` for your keyspace for your hosts.

You can check your keyspace 
```shell
curl -s redishub.com/rquery/ks/MYKEYSPACE/hgetall/host:`hostname -s` | python -mjson.tool
```

### Related

Related projects and further plans: https://github.com/evanx/mpush-redis/blob/master/related.md

