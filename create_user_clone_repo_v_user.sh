
#!/bin/bash

# Установка пароля
password="Test123321"

# Устанавливаем настройки SSH
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config.d/50-cloud-init.conf
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config

# Перезагружаем службу SSH
sudo service ssh restart

# Создание пользователей
for i in {1..15}
do
  username="student$i"

  # Проверяем, существует ли уже пользователь
  if id -u $username >/dev/null 2>&1; then
    echo "User $username exists"
  else
    # Создаем пользователя
    sudo useradd -m $username

    # Устанавливаем пароль
    echo "$username:$password" | sudo chpasswd
  fi

  # Проверяем, существует ли домашний каталог пользователя
  if [ ! -d "/home/$username" ]; then
    # Создаем домашний каталог
    sudo mkdir /home/$username
    sudo chown $username: /home/$username
  fi

  # Клонируем репозиторий git
  sudo -u $username git clone https://bitbucket.org/ /home/$username/kf20
done
