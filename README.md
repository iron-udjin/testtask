# testtask
Test task (two wordpress instances)

ТЗ:

<pre>Загрузить Тествое задание которое находится ниже на ресурс github.com

 Создать конфигурацию в docker-compose.yml для следующих сервисов:
  - nginx
  - certbot
  - php-fpm
  - phpmyadmin
  - mysql/mariadb


Произвести конфигурацию nginx для двух доменов, example-one.com и example-two.com которые будут отдавать два чистых сайта на Wordpress с редиректом на https и условными сертификатами от letsencrypt


Будет плюсом если вы добавите файл с правилами iptables закрывающие php-fpm phpmyadmin mysql от Мира.</pre>

Доменные имена заменены на реальные: __test1.iron.org.ua__ и __test2.iron.org.ua__

При запуске контейнеромв, init скрипт проверяет установлены ли вордпрессы. Если нет - устанавливает и настраивает.

Я не стал разворачивать уже устаровленный вордпресс, так как при этом теряется гибкость. К тому же, "развернутую" версию придется сразу же обновлять. В случае автоматической устаровки с ноля есть возможность доставить плагины/темы, залить готовый контент, проверить работоспособность/совместимость новой версии и т.д.

Генерация SSL сертификатов:
```
docker-compose run --rm certbot certonly --webroot --webroot-path /var/www/certbot/ -d test1.iron.org.ua
docker-compose run --rm certbot certonly --webroot --webroot-path /var/www/certbot/ -d test2.iron.org.ua
```
Контейнер __certbot__ при запуске проверяет сертификаты и при необходимости делает renew, после чего останавливается.


Сервисы настроены так, что не выставляют открытые порты наружу (nginx - исключение).
Если же порт мускуля торчит наружу, то закрываем вот так:
```
iptables -I DOCKER-USER -i enp0s5 -d 172.27.0.3 -p tcp --dport 3306 -j DROP
```

__Регультат:__

https://test1.iron.org.ua/

https://test2.iron.org.ua/
