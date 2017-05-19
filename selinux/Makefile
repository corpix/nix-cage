all: devcage.pp

devcage.pp: devcage.te
	checkmodule -M -m -o devcage.mod $<
	semodule_package -o $@ -m devcage.mod

.PHONY: install
install: devcage.pp
	semanage boolean -m --on container_manage_cgroup
	semanage boolean -m --on virt_sandbox_use_netlink
	semodule -i $<

.PHONY: uninstall
uninstall:
	semanage boolean -m --off container_manage_cgroup
	semanage boolean -m --off virt_sandbox_use_netlink
	semodule -r devcage
