#!/bin/bash
cat << EOF
{
  "name": "k8-master",
  "region": "fra1",
  "size": "s-1vcpu-1gb",
  "image": "centos-7-x64",
  "ssh_keys":["$(cat ./secrets/fingerprint)"],
  "backups": false,
  "ipv6": true,
  "user_data": null,
  "private_networking": null,
  "volumes": null,
  "tags": [
    "kubernetes"
  ]
}
EOF

