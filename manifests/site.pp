## Puppet site manifest
## See enc.py and nodes.yaml for the ENC-based node catalog

node default {
    include role::noop
}
