POC k8s local testbed

![Screenshot_2024-11-13_20-30-09](https://github.com/user-attachments/assets/1005ed76-8eaa-46b8-989f-bf7c8e9879e7)

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
2) molecule role tests
3) dashboard
4) istio
5) grafana
6) slinky
7) ldap -- possible implementation idea in mind
