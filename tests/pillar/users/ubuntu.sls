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
    ssh_auth:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCtyp5d65jnZvN4dozjO1y/cA2Wmrg/hUeXtqeEh5RKPkA10ucWO6q5zIu6pAjB9zwYQYC1rgXs79ieetiBcUYiwMV3RcsociwJSofjP0KlgIeIfFBr+RJjIvpT6jkFKBAavnfgQlr/rReMGUL04EtYAA/rFIhyQBQsNCtItmhReVAmzD3xI3+5QupbOjO1UuK1lukl7CvbsI6FC1POpKDUkFJAy78waZXT/kCnYF1r71L4L2zHfns5r86/y5rzFLJxBIZ8iAzdRxUMps249s4KfT3pyDnXGazPWWuRjUN66wfclkZjoqN8j7rb4hSQAi0SDEoG7t9oL9gOJEmv2qBl root@adm
    ssh_key_folder: salt://test/ubuntu.pem
    ssh_keys:
      test_key_name: test_key_value
      test_key_name.pub: test_key_value

delete_users:
  - redhat
