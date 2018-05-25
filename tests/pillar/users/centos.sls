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
    ssh_auth:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCiaweE10fpWkfHkkKnUrc37rmxMFIiTj7UmDn3wkvR4TFBa/FT+mihuGzkAb+zwoHPcKabZYpzeQxm0IaormzQTkJ2wuDk3d9x0inG7FSeYb/BrxvAW2Uu3nblCyVKjmsyA9afd8FnqhaJhjSUjI4NGy0UNK1FRH/WuRIF0RPIY8mVvdN+9p8mPNeX0C2fR9o/BH3VhXKd19LP4dUUS9xXuHEOiV7//91D6vGlRfeW/7nAYmTXb96cQ0GIWdKmbum4Uq0qjJY0jQ2JNIaf5GL+bb0FCwRnZwA+Th6dRWGcIG6vP5KivW5ZQ7aRDDitcBnREa4L485KByOyWZdD7KoV root@adm
    ssh_key_folder: salt://test/centos.pem
    ssh_keys:
      test_key_name: test_key_value
      test_key_name.pub: test_key_value

delete_users:
  - canonical
