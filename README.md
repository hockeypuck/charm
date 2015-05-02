# Deploying Hockeypuck with Juju

## Prerequisites

Juju 1.23.2 or later is recommended to make full use of this charm's [juju
actions](https://jujucharms.com/docs/stable/actions). Install juju with:

```
sudo apt-add-repository ppa:juju/stable
sudo apt-get update
sudo apt-get install juju-core
```

Also `apt-get install juju-local` if you'd like to use the local provider.

Familiarity with Juju and a bootstrapped environment is assumed. Read the [Juju
Documentation](https://jujucharms.com/docs/) to get started.

## Deploying Hockeypuck

Deploy a Hockeypuck service:

`juju deploy cs:~hockeypuck/trusty/hockeypuck`

Deploy MongoDB and relate it:

```
juju deploy mongodb
juju add-relation mongodb hockeypuck
```

## HTTP reverse-proxy

Expose Hockeypuck on port 80 behind haproxy.

```
juju deploy haproxy
juju add-relation hockeypuck:website haproxy:reverseproxy
juju expose haproxy
```

Or behind squid for caching.

```
juju deploy squid-reverseproxy
juju add-relation hockeypuck:website squid-reverseproxy
juju set squid-reverseproxy port=11371
juju expose squid
```

## TODOs
TODO: using the actions
TODO: peering relations

