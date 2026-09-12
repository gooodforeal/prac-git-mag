#!/bin/bash
set -euo pipefail

export ANSIBLE_CONFIG=/ansible/ansible.cfg
export ANSIBLE_HOST_KEY_CHECKING=False

HTML=/tmp/jenkins-app.html
cat > "$HTML" << EOF
<!DOCTYPE html>
<html lang="ru">
<head>
  <meta charset="UTF-8">
  <title>Jenkins Job</title>
</head>
<body>
  <h1>Собрано Jenkins</h1>
  <p>Простейший job передал файл на node1</p>
  <p>Время сборки: $(date)</p>
</body>
</html>
EOF

ansible web -i /ansible/inventory.ini -m apt -a "name=nginx state=present update_cache=yes"
ansible web -i /ansible/inventory.ini -m copy -a "src=${HTML} dest=/var/www/html/index.html"
ansible web -i /ansible/inventory.ini -m service -a "name=nginx state=started enabled=yes"

echo "Файл доставлен на node1"
