
## system-rquery-bash

Push system metrics into an rquery instance e.g. redishub.com by default.

Currently only diskpace and load average are pushed, for illustration.

While the intended purpose is for custom monitoring and alerting, that is out of scope of this service.

#### rquery

See my Node HTTP Redis service: https://github.com/evanx/rquery

This service is deployed for public use at: https://redishub.com


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

You can check your keyspace:
```shell
curl -s http://redishub.com/rquery/ks/MYKEYSPACE/keys | python -mjson.tool
```
```json
[
    "host:eowyn"
]
```
and a specific host:
```shell
curl -s https://redishub.com/rquery/ks/MYKEYSPACE/hgetall/host:`hostname -s` | python -mjson.tool
```

```json
{
    "cpuload": "1.23",
    "diskspace": "19"
}
```

### Related

See my Node HTTP Redis service: https://github.com/evanx/rquery

Related projects and further plans: https://github.com/evanx/mpush-redis/blob/master/related.md

