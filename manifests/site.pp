## Puppet site manifest
## See enc.py and nodes.yaml for the ENC-based node catalog

# Default values
File {
    mode => '0644',
    owner => root,
    group => root,
}

node default {
    include role::noop
}
