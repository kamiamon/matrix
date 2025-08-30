## Развертывание для Ubuntu 22/24

### Подготовка
* Создайте записи A и AAAA для доменного имени сервера
* Установите [docker](https://docs.docker.com/engine/install/ubuntu/) и [docker-compose](https://docs.docker.com/compose/install/linux/)
* Создайте сертификаты
  ```
  sudo apt install certbot -y
  certbot certonly --rsa-key-size 2048 --standalone --agree-tos --no-eff-email --email email@email.com -d EXAMPLE.ORG
  ```
  
### Synapse server install
* Создайте каталог /etc/synapse
* Скопируйте из репозитория файл docker-compose.yml
* Сгенерируйте конфигурацию как [здесь](https://github.com/matrix-org/synapse/tree/develop/contrib/docker)
  ```angular2html
  /etc/synapse# docker compose run --rm -e SYNAPSE_SERVER_NAME=EXAMPLE.ORG -e SYNAPSE_REPORT_STATS=yes synapse generate
  ```
  Конфигурация должна быть сгенерирована в /var/synapse/data/homeserver.yaml

### Настройка Postgres
* Измените секцию database в /var/synapse/data/homeserver.yaml как в примере
  ```
  database:
  name: psycopg2
  args:
    user: synapse
    password: pass
    dbname: synapse
    host: db
    cp_min: 5
    cp_max: 10
  ```
* Имените пароль от пользователя базы данных в docker-compose.yml и homeserver.yaml
  
### Добавление TURN-сервера
* Скопируйте директивы turn_ из примера homeserver.yaml
  ```
  turn_uris: ["turn:EXAMPLE.ORG:3478?transport=udp", "turn:EXAMPLE.ORG:3478?transport=tcp"]
  turn_shared_secret: "SECRET"
  turn_user_lifetime: 86400000  # 24 hours
  turn_allow_guests: True
  ```

### Установка Nginx
* Создайте каталог /etc/nginx/docker-config и скопируйте туда конфиг nginx EXAMPLE.ORG.conf
* Измените server_name и пути к сертификатам в конфигурации
* Запустите сервер и проверьте HTTPS через nginx https://EXAMPLE.ORG/_matrix/static/

### Создание пользователя-администратора
* Зайдите в Docker-контейнер с сервером synapse и используйте [register_new_matrix_user](https://manpages.debian.org/testing/matrix-synapse/register_new_matrix_user.1.en.html)
  ```angular2html
  docker exec -it synapse_synapse_1 bash
  register_new_matrix_user -u admin -p admin -a -c /data/homeserver.yaml
  ```
* По адресу https://EXAMPLE.ORG/admin-url/ будет досупна панель управления synapse

## Дополнительно
### Добавление reCAPTCHA
* Создайте новый сайт на https://www.google.com/recaptcha/admin/create
* Выберите тип reCAPTCHA v2 "Я не робот"
* Добавьте домен
* Скопируйте открытый и закрытый ключи и добавьте в /var/synapse/data/homeserver.yaml
```
  enable_registration_captcha: true
  recaptcha_public_key: YOUR_SITE_KEY
  recaptcha_private_key: YOUR_SECRET_KEY
```
