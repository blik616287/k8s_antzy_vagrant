POC k8s local testbed

![Screenshot_2024-11-21_13-39-51](https://github.com/user-attachments/assets/a479ac85-ce31-43cf-8dce-b1309f72e89c)

Uses virtualbox and vagrant to deploy local infra, and ansible for config 

deploys infrastructure for:
- 2x loadbalancers
- 3x controllers
- 3x executors
- 1x ansible orchestrator

idempotent ansible config for roles:
- haproxy_lb -- roundrobin with vip
- k8s -- dynamic bootstrap and join

supported plugins:
- calico
- ingress-nginx
- rook-ceph

# iac automated deployment
```
# requires redistributables outlined in READ: ./optional/redist_depends.sh
vagrant up
vagrant destroy -f
```

# todo:
~~testing fix for flannel subnet issue~~
- molecule role tests
- dashboard
- istio
- grafana
- slinky
- ldap -- possible implementation idea in mind
