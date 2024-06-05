[DebianCloud]
%{ for hostName , instance in ips ~}
${ hostName } ansible_host=${ instance.ip }
%{ endfor ~}

[all:vars]
ansible_strict_host_key_checking=False
ansible_user_known_hosts_file=/dev/null
