# Deploying Hockeypuck with Juju

## Prerequisites

Juju 1.23.2 or later is recommended to make full use of this charm's [juju
actions](https://jujucharms.com/docs/stable/actions). Install a recent version of juju with:

`sudo apt-add-repository ppa:juju/stable`

## Deploying Hockeypuck

Deploy a Hockeypuck service:

`juju deploy cs:~hockeypuck/trusty/hockeypuck`

Deploy MongoDB and relate it:

`juju deploy mongodb`

`juju add-relation mongodb hockeypuck`

## HTTP reverse-proxy

Expose Hockeypuck on port 80 behind haproxy.

`juju deploy haproxy`

`juju add-relation hockeypuck:website haproxy:reverseproxy`

`juju expose haproxy`

Or behind squid for caching.

`juju deploy squid-reverseproxy`

`juju add-relation hockeypuck:website squid-reverseproxy`

`juju set squid-reverseproxy port=11371`

`juju expose squid`

# Actions

This charm provides several useful actions for managing your new keyserver.

## fetch-keyfiles

`fetch-keyfiles` downloads OpenPGP binary keyfiles from a remote location to a local directory on the keyserver.

### Parameters

#### src

Required. The remote location to fetch keyfiles from. This is expected to be a
directory containing concatenated OpenPGP public keys in RFC 4880 binary
format. These are the files typically produced by an SKS dump, and should have
a `*.pgp` file extension.

`rsync://`, `http://` and `ftp://` protocols are supported.

Please be mindful of the network activity that this action can place on the
remote server hosting the files. Use sparingly on global pool dumps; otherwise
mirror the files.

#### dest

Local directory where the files will be stored. `/srv/hockeypuck/import` is the
default if not specified.

## load-keyfiles

Stops the hockeypuck service and loads keyfiles into Hockeypuck.

### Parameters

#### path

Local directory where files will be loaded from. `/srv/hockeypuck/import` is the
default.

# Peering

## Peering with Relations

Assuming two Hockeypucks:

```
juju deploy cs:~hockeypuck/trusty/hockeypuck hkp1
juju deploy cs:~hockeypuck/trusty/hockeypuck hkp2
```

Enable gossip between them with:

```
juju add-relation hkp1:keymaster hkp2:gatekeeper
```

Destroy the relation to stop syncing keys:

```
juju destroy-relation hkp1:keymaster hkp2:gatekeeper
```

Regardless of which service is `keymaster` or `gatekeeper`, both services will
initiate and serve connections.

## Peering with Configuration

To peer with other keyservers (Hockeypuck or SKS servers) that aren't in your
Juju environment, set the config option `recon_partners`. The format of this
option is a space-delimited list of partners, where each partner is a
comma-separated pair of HTTP and recon addresses. Like this:

```
juju set hockeypuck recon_partners="peer1:http,peer1:recon peer2:http,peer2:recon"
```

Note that you can specify a different host for the HTTP and recon addresses.
This supports connecting to peers that expose these ports on different host
addresses.

