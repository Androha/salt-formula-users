users:
  redhat:
    home: /home/redhat
    createhome: True
    uid: 10000
    prime_group:
      name: redhat
      gid: 1000
    groups:
      - sudo
    sudouser: True
    ssh_key_folder: salt://test/centos.pem
    ssh_keys:
      test_key_name: test_key_value
      test_key_name.pub: test_key_value

delete_users:
  - canonical
