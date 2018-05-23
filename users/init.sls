{% for user, data in pillar.get('users', {}).items() %}

{% set homedir = user.get('home', "/home/%s" % user) %}

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
  {% if data.get('createhome', True) %}
  file.directory
    - name: {{ homedir }}
    - user: {{ user }}
    - group: {{ user_group }}
    - dir_mode: 0750
    - makedirs: True
    - require:
      - user: user_{{ user }}
      - group: {{ user_group }}
  {% endif %}
  group.present:
    - name: {{ user_group }}
    {% if 'prime_group' in data and 'gid' in data['prime_group'] %}
    - gid: {{ data['prime_group']['gid'] }}
    {% elif 'uid' in data %}
    - gid: {{ data['uid'] }}
    {% endif %}
  user.present:
    - name: {{ user }}
    - home: {{ homedir }}
    {% if 'uid' in data %}
    - uid: {{ data['uid'] }}
    {% endif %}
    - groups:
      - {{ user_group }}
      {% for group in data.get('groups', []) %}
      - group: {{ group }}
      {% endfor %}
    - require:
      - group: {{ user_group }}
      {% for group in data.get('groups', []) %}
      - group: {{ group }}
      {% endfor %}

{% if 'ssh_keys' in data %}
{{ user }}_keydir:
  file.directory:
    - name: {{ homedir }}/.ssh
    - user: {{ user }}
    - user: {{ user_group }}
    - dir_mode 0700
    - makedirs: True
        - require:
      - user: {{ user }}
      - group: {{ user_group }}
      {% for group in data.get('groups', []) %}
      - group: {{ group }}
      {% endfor %}

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

{% endfor %}

{% for user in pillar.get('delete_users', []) %}
user_absent_{{ user }}:
  user.absent:
    - name: {{ user }}
{% endfor %}
