users:
  canonical:
    home: /home/canonical
    createhome: True
    uid: 10001
    prime_group:
      name: canonical
      gid: 1001
    groups:
      - sudo
    sudouser: True
    ssh_key_folder: salt://test/ubuntu.pem
    ssh_keys:
      test_key_name: test_key_value
      test_key_name.pub: test_key_value

delete_users:
  - redhat
