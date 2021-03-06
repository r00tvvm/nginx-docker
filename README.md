
# Ansible role for Docker nxinx
This is a Ansible role for Docker nxinx
## Prerequisites
Installed and configured Ansible 
```
  pip install docker
  pip install 'docker-compose>=1.7.0'
```
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
* Clone and install dependent role
```
 > git clone https://github.com/r00tvvm/nginx-docker.git && cd nginx-docker
 > chmod +x ./playbook.sh
 > ansible-galaxy install -r requirements.yml -f
```
* Run Docker containers
```
 > ansible-playbook -i hosts site.yml -t docker
```
* Run Docker commit running containers
```
 > ansible-playbook -i hosts site.yml -t commit
```
* Run Docker stop running containers
```
 > ansible-playbook -i hosts site.yml -t stop
```
* Install/remove Nginx server to inventory hosts
```
 > ansible-playbook -i hosts site.yml -t nginx
 > ansible-playbook -i hosts site.yml -t remove
```
## Script usage
```
 >  ./playbook.sh -h
 > ./playbook.sh -i hosts
```