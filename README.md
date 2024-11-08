POC k8s local testbed

Uses virtualbox and vagrant to deploy local infra, and ansible for config 

deploys infrastructure for:
- 2x loadbalancers
- 3x controllers
- 3x executors
- 1x ansible orchestrator

idempotent ansible config for roles:
- haproxy_lb -- roundrobin with vip
- k8s -- dynamic bootstrap and join

# iac automated deployment
```
# requires redistributables outlined in READ: ./optional/redist_depends.sh
vagrant up
vagrant destroy -f
```

# todo:
1) testing fix for flannel subnet issue
2) dashboard
3) istio
4) grafana
5) slinky
6) ldap -- possible implementation idea in mind
