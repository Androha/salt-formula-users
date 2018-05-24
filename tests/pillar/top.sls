base:
  'os_family:Debian':
    - match: grain
    - users.ubuntu
  'os_family:RedHat':
    - match: grain
    - users.centos
