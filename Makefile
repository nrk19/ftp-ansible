deploy:
	vagrant up
	ansible-playbook ansible/site.yml
