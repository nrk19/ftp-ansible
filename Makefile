deploy:
	tar cvfz ftp-ansible.tgz --exclude=".vagrant" --exclude=".git" \
		Vagrantfile \
		files \
		ansible \
		ssh \
		README.md
