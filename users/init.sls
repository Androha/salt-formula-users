{% from "users/map.jinja" import users with context %}
{% set sudo_used = [] %}

{% for user, data in pillar.get('users', {}).items() %}
{% if 'sudouser' in data and data['sudouser'] %}
{% do sudo_used.append(1) %}
{% endif %}
{% endfor %}

{% if sudo_used %}
users_bash-package:
  pkg.installed:
    - name: {{ users.bash_package }}

users_{{ users.sudoers_dir }}:
  file.directory:
    - name: {{ users.sudoers_dir }}

users_sudo-package:
  pkg.installed:
    - name: {{ users.sudo_package }}
    - require:
      - file: {{ users.sudoers_dir }}

users_sudoer-defaults:
  file.append:
      - name: {{ users.sudoers_file }} 
      - require:
        - pkg: users_sudo-package
      - text:
        - Defaults   env_reset
        - Defaults   secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
        - '#includedir {{ users.sudoers_dir }}'
{% endif %}

{% for user, data in pillar.get('users', {}).items() %}

{% set homedir = data.get('home', "/home/%s" % user) %}

{% if 'prime_group' in data and 'name' in data['prime_group'] %}
{% set user_group = data.prime_group.name %}
{% else %}
{% set user_group = user %}
{% endif %}

{% for group in data.get('groups', []) %}
user_{{ user }}_group_{{ group }}:
  group.present:
    - name: {{ group }}
    {% if group == 'sudo' %}
    - system: True
    {% endif %}
{% endfor %}

user_{{ user }}:
  group.present:
    - name: {{ user_group }}
    {% if 'prime_group' in data and 'gid' in data['prime_group'] %}
    - gid: {{ data['prime_group']['gid'] }}
    {% elif 'uid' in data %}
    - gid: {{ data['uid'] }}
    {% endif %}
  {% if data.get('createhome', True) %}
  file.directory:
    - name: {{ homedir }}
    - user: {{ user }}
    - group: {{ user_group }}
    - dir_mode: 0750
    - makedirs: True
    - require:
      - user: user_{{ user }}
      - group: {{ user_group }}
  {% endif %}
  user.present:
    - name: {{ user }}
    - home: {{ homedir }}
    {% if 'uid' in data %}
    - uid: {{ data['uid'] }}
    {% endif %}
    {% if not data.get('createhome', True) %}
    - createhome: False
    {% endif %}
    - groups:
      - {{ user_group }}
      {% for group in data.get('groups', []) %}
      - {{ group }}
      {% endfor %}
    - require:
      - group: {{ user_group }}
      {% for group in data.get('groups', []) %}
      - group: {{ group }}
      {% endfor %}

{% if 'ssh_keys' in data or 'ssh_key_folder' in data or 'ssh_auth' in data %}
{{ user }}_keydir:
  file.directory:
    - name: {{ homedir }}/.ssh
    - user: {{ user }}
    - group: {{ user_group }}
    - dir_mode: 0700
    - makedirs: True
    - require:
      - user: {{ user }}
      - group: {{ user_group }}
{% endif %}

{% if 'ssh_prv_key' in data %}
{{ user }}_prv_key_{{ ssh_prv_key }}:
  file.managed:
    - name: {{ homedir }}/.ssh/key.pem
    - source: {{ ssh_prv_key }}
    - user: {{ user }}
    - group: {{ user_group }}
    - mode: 600
{% endif %}

{% if 'ssh_keys' in data %}
  {% for key_name in data.ssh_keys.keys() %}
{{ user }}_key_{{ key_name }}:
  file.managed:
    - name: {{ homedir }}/.ssh/{{ key_name }}
    - user: {{ user }}
    - group: {{ user_group }}
    {% if key_name.endswith(".pub") %}
    - mode: 644
    {% else %}
    - mode: 600
    {% endif %}
    - show_diff: False
    - contents_pillar: users:{{ user }}:ssh_keys:{{ key_name }}
  {% endfor %}
{% endif %}

{% if 'ssh_auth' in data %}
  {% for auth_key in data['ssh_auth'] %}
ssh_auth_{{ user }}_{{ loop.index0 }}:
  ssh_auth.present:
    - user: {{ user }}
    - name: {{ auth_key }}
  {% endfor %}
{% endif %}

{% set sudoers_filename = user|replace('.','_') %}
{% if 'sudouser' in data and data['sudouser'] %}
users_sudoer_{{ user }}:
  file.managed:
    - replace: False
    - name: {{ users.sudoers_dir }}/{{ sudoers_filename }}
    - user: root
    - group: {{ users.root_group }}
    - mode: '0440'
{% else %}
users_sudoer_absent_{{ user }}:
  file.absent:
    - name: {{ users.sudoers_dir }}/{{ sudoers_filename }}
{% endif %}

{% endfor %}

{% for user in pillar.get('delete_users', []) %}
user_absent_{{ user }}:
  user.absent:
    - name: {{ user }}
{% endfor %}
