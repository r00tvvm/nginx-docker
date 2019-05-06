
# Ansible role for Docker nxinx
This is a Ansible role for Docker nxinx
## Prerequisites
Installed and configured Ansible 
Add *hosts* file into same directory and usew role with -i hosts
```
Example: 
 > cat hosts
  [web-debian]
  ip1
  ip2

  [web-centos]
  ip3

  [web:children]
  web-debian
  web-centos
```

## Usage
* Clone and install requirements
```
 > git clone https://github.com/r00tvvm/nginx-docker.git && cd nginx-docker
 > ansible-galaxy install -r requirements.yml
```
* Run Docker containers
```
 > ansible-playbook -i hosts site.yml
```
* Run Docker commit running containers
```
 > ansible-playbook -i hosts site.yml -t commit
```
* Run Docker stop running containers
```
 > ansible-playbook -i hosts site.yml -t stop
```
* Install Nginx server to inventory hosts
```
 > ansible-playbook -i hosts site.yml -t nginx
```
