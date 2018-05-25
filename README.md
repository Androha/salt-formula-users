# Users-formula
### Formula to configure users using pillar.
## Example of the pillar:

users_formula_defaults: \# Overwrite the defaults from map.jinja\
  sudoers_dir: /etc/sudoers.d\
  sudoers_file: /etc/sudoers\
  root_group: root\
  bash_package: bash\
  sudo_package: sudo\
\
users:\
  user1: \# The name of the user\
    home: /home/user1\
    createhome: True\
    uid: 10000\
    prime_group:\
      name: prime_group_name\
      gid: 1000\
    groups:\
      \- group1\
      \- sudo\
    sudouser: True\
    ssh_auth:
      - PUBLIC_KEY \# The list of authorized public keys\
    ssh_key_folder: salt://SSH_DIR \# Files from this directory will be copied into .SSH/ directory of the user\
    ssh_keys: \# Keyname is used as a file name in .SSH/ directory\
      key1: your_private_key\
      key2.pub: your_public_key \# Make sure your public key names end with .pub\
\
delete_users: \# Users to be deleted\
  \- user2\
  \- user3
