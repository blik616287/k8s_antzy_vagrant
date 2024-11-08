```
rm -rf cache
ansible-playbook playbooks/deploy_haproxy_lb.yml -l load_balancers # --flush-cache
ansible-playbook playbooks/deploy_k8s.yml -l k8s_cluster # --flush-cache

ansible-playbook playbooks/bootstrap_k8s.yml -l ip
ansible-playbook playbooks/sync_k8s.yml -l ip

```
