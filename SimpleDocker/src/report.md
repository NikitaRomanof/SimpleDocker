# Отчет по выполненным задачам Simple Docker

## Part 1. Готовый докер


- Взять официальный докер образ с nginx (на сайте https://hub.docker.com/_/nginx) 
и выкачать его при помощи `docker pull nginx`
![Image](img/1.png)
*<p align="center">Рис 1.1 Скачиваем официальный докер образ с nginx<p>*

- Проверить наличие докер образа, при помощи команды `docker images`
![Image](img/2.png)
*<p align="center">Рис 1.2 Проверка наличия докер образа<p>*

- Запустить докер образ через `docker run -d [image_id]`
![Image](img/3.png)
*<p align="center">Рис 1.3 Запуск докер образ<p>*

- Проверить, что образ запустился через `docker ps`
![Image](img/4.png )
*<p align="center">Рис 1.4 Проверка того, что образ запустился<p>*

* Посмотреть информацию о контейнере через `docker inspect [container_id]`
![Image](img/5.png)
![Image](img/5_5.png)
*<p align="center">Рис 1.5 информация о контейнере<p>*

По выводу команды определить:
1) размер контейнера `141522805`
2) список замапленных портов `80/tcp`
3) ip контейнера `172.17.0.2`

- Остановить докер образ через `docker stop [container_id]`
![Image](img/6.png)
*<p align="center">Рис 1.6 Остановка докер образа<p>*

- Проверить, что образ остановился через `docker ps`
![Image](img/7.png)
*<p align="center">Рис 1.7 Образ остановлен<p>*

- Запустить докер с замапленными портами 80 и 443 на локальную машину через команду run
`docker run -d -p 80:80 -p 443:443 nginx`
![Image](img/8.png)
*<p align="center">Рис 1.8 Команда run<p>*

- Проверить, что в браузере по адресу `localhost:80` доступна стартовая страница nginx
![Image](img/9.png)
*<p align="center">Рис 1.9 Стартовая страница nginx<p>*

- Перезапустить докер образ. Проверить любым способом, что контейнер запустился.  \
`docker restart 726ddb5ee6b3`
![Image](img/10.png)
*<p align="center">Рис 1.10 Перезапустить докер образ<p>*


## Part 2. Операции с контейнером

- Прочитать конфигурационный файл *nginx.conf* внутри докер образа через команду *exec*.  \
`sudo docker exec -it 12d00a7b06b4 cat /etc/nginx/nginx.conf`
![Image](img/11.png)
*<p align="center">Рис 2.1 Вывод конфигурационного файла<p>*

- Создать на локальной машине файл *nginx.conf*  \
`sudo touch nginx.conf`  \

- Настроить в нем по пути */status* отдачу страницы статуса сервера **nginx**.  \
Строка `listen [::]:80` указываем, какой порт слушать для IPv6 адресов.
![Image](img/12.png)
*<p align="center">Рис 2.2 Настройка конфигурационного файла<p>*

- Скопировать созданный файл *nginx.conf* внутрь докер образа через команду:  \
`sudo docker cp nginx.conf a4f875e5f1f9:/etc/nginx/`
![Image](img/13.png)
*<p align="center">Рис 2.3 Копирование конфигурационного файла внутрь докера<p>*

- Перезапустить **nginx** внутри докер образа через команду:  \
`sudo docker exec -it a4f875e5f1f9 nginx -s reload`
![Image](img/14.png)
*<p align="center">Рис 2.4 Перезапуск **nginx** внутри докер образа<p>*

- Проверить, что по адресу *localhost:80/status* отдается страничка со статусом сервера **nginx**
![Image](img/15.png)
![Image](img/15_5.png)

*<p align="center">Рис 2.5 Страница со статусом сервера nginx <p>*

- Экспортировать контейнер в файл *my-nginx.tar* через команду *export* :  \
`docker export angry_gates > my-nginx.tar`
![Image](img/16.png)
*<p align="center">Рис 2.6 Экспорт контейнера<p>*

- Остановить контейнер  \
`docker stop angry_gates`
![Image](img/17.png)
*<p align="center">Рис 2.7 Остановка контейнера<p>*

- Удалить образ через `docker rmi [image_id|repository]`, не удаляя перед этим контейнеры
![Image](img/18.png)
*<p align="center">Рис 2.8 Удалить образ<p>*

- Импортировать контейнер обратно через команду import: `docker import - imported_container < my-nginx.tar`
![Image](img/19.png)
*<p align="center">Рис 2.9 Импортировать контейнер<p>*

- Запустить импортированный контейнер `docker run -d -it imported_container bash`
![Image](img/20.png )
*<p align="center">Рис 2.10 Запустить импортированный контейнер<p>*


## Part 3. Мини веб-сервер

- Написать мини сервер на **C** и **FastCgi**, который будет возвращать простейшую страничку с надписью `Hello World!`.  \
Создадим в src папку server, в котрой создадим файл hello.c.  \
Для написаия минисервера с **FastCgi** понадобится библиотека **libfcgi**.  \
Рассмотрим основные функции библиотеки:  \
  - int FCGX_Init() - инициализация библиотеки. Эту функцию нужно вызывать перед любыми другими функциями этой библиотеки и только один раз.
  - int FCGX_InitRequest(FCGX_Request *request, int sock, int flags) - request — указатель на структуру данных, которую нужно инициализировать
  sock — дескриптор сокета, который мы получили после вызова функции FCGX_OpenSocket. Хочется отметить, что вместо уже готового дескриптора можно передать 0 (нуль) и получить сокет с настройками по умолчанию. flags — флаги. Собственно, в эту функцию можно передать только один флаг — FCGI_FAIL_ACCEPT_ON_INTR — не вызывать FCGX_Accept_r при разрыве.
  - int FCGX_Accept_r(FCGX_Request *request) - получить новый запрос. В неё нужно передать уже инициализированную на прошлом этапе структуру    request. Собственно, эта функция выполняет всю работу по работе с сокетами: сначала она отправляет ответ веб-серверу на предыдущий запрос  (если таковой был), закрывает предыдущий канал передачи данных и освобождает все связанные с ним ресурсы (в том числе — переменные структуры request), потом получает новый запрос, открывает новый канал передачи данных и подготавливает новые данные в структуре request для их последующей обработки. В случае ошибки получения нового запроса функция возвращает код ошибки, меньший нуля.

- Скачаем новый докер образ - `docker pull nginx`.
- Создадим контейнер с именем s21_server для мини веб-сервера c замапленным пором 81 - `docker run --name s21_server -d -p 81:81 nginx`.
- Создадим в контейнере папку `/s21_server` при помощи команды - `docker exec -it s21_server mkdir /s21_server`
- Обновляем контейнер и устанавливаем в него **libfcgi**, **spawn-fcgi**, **gcc**, **make**, **nano**,  при помощи команды -  \
`docker exec -it s21_server bash -c 'apt update ; apt install -y gcc libfcgi-dev spawn-fcgi make nano'`.
- Написать свой nginx.conf, который будет проксировать все запросы с 81 порта на 127.0.0.1:8080  \
![Image](img/21.png )
*<p align="center">Рис 3.1 Написать свой nginx.conf<p>*
- Копируем файл hello.c в контейнер в папку /s21_server и файл nginx.conf в контейнер в папку /etc/nginx/nginx.conf.  \
`docker cp hello.c s21_server:/s21_server`  \
`docker cp nginx.conf s21_server:/etc/nginx/`
- Перезапустить **nginx** внутри докер образа через команду:  \
`sudo docker exec -it s21_server nginx -s reload`
- Компилируем файл hello.c в контейнере с помощью команды:  \
`docker exec -it s21_server bash -c 'gcc /s21_server/hello.c -lfcgi -o /s21_server/hello'`
![Image](img/22.png )
*<p align="center">Рис 3.2 Компилируем файл hello.c в контейнере<p>*
- Запустить написанный мини сервер через **spawn-cgi** на порту 8080  \
`docker exec -it s21_server bash -c 'spawn-fcgi -p8080 /s21_server/hello'`
![Image](img/23.png )
*<p align="center">Рис 3.3 Запуск мини серера в контейнере<p>*
- Перезапустим nginx внутри докер образа через команду `docker exec -it s21_server bash -c 'nginx -s reload'`.
- Проверка, что в браузере по localhost:80 отдается написанная нами страничка с надписью Hello World!.
![Image](img/24.png )
![Image](img/24_4.png )
*<p align="center">Рис 3.4 Проверка работоспособности мини сервера<p>*


## Part 4. Свой докер
**== Задание ==**

- ### Написать свой докер образ, который:
#### 1) собирает исходники мини сервера на FastCgi из [Части 3](#part-3-мини-веб-сервер)
#### 2) запускает его на 8080 порту
#### 3) копирует внутрь образа написанный *./nginx/nginx.conf*
#### 4) запускает **nginx**.

- Создаём Dockerfile.  \
![Image](img/25.png )
*<p align="center">Рис 4.1 Dockerfile<p>*
- Создаём скрипт ss.sh, который компилирует мини сервер в докере, запускает его, выключает демон nginx (для того что бы применить новый конфиг), перезапускает nginx.  \
![Image](img/26.png )
*<p align="center">Рис 4.2 Скрипт ss.sh<p>*
- Собираем докер образ и сразу проверяем, что образ собран  \
`docker build -t wsulu_nginx:v1 .`
![Image](img/27.png )
*<p align="center">Рис 4.3 Собираем образ<p>*
- Запускаем собранный образ с маппингом 81 порта на 80 на локальной машине и маппингом папки *./nginx* внутрь контейнера по адресу, где лежат конфигурационные файлы **nginx**.  \
`docker run --mount type=bind,source="$(pwd)"/server/nginx/nginx.conf,target=/etc/nginx/nginx.conf -i -t -p 80:81 --name wsulu wsulu_nginx:v1`
![Image](img/28.png )
*<p align="center">Рис 4.4 Запускаем контейнер<p>*
- Проверяем, что по localhost:80 доступна страничка написанного мини сервера
![Image](img/29.png )
![Image](img/29_2.png )
*<p align="center">Рис 4.4 Проверяем доступ к localhost:80<p>*
- Допишем в файл nginx.conf на локальной машине проксирование странички */status*, по которой надо отдавать статус сервера **nginx**, перезапустим контейнер и проверем статут.  \
![Image](img/30.png )
![Image](img/30_2.png )
![Image](img/30_3.png )
*<p align="center">Рис 4.5 Проверяем доступ к localhost:80<p>*


## Part 5. **Dockle**

- Устанавливаем **Dockle** на виртуальную машину и проверяем ошибки  \
`VERSION=0.3.11 && curl -L -o dockle.deb https://github.com/goodwithtech/dockle/releases/download/v${VERSION}/dockle_${VERSION}_Linux-64bit.deb`
`sudo dpkg -i dockle.deb && rm dockle.deb`
![Image](img/31.png )
*<p align="center">Рис 5.1 Запуск Dockle <p>*

- Изменяем Dockerfile.  \
`chmod u-s file` - запрещаем пользователям запускать исполняемые файлы с правами владельца исполняемого файла.  \
`chmod g-s file` - запрещаем пользователям запускать исполняемые файлы с правами группы исполняемого файла.  \
`chown -R nginx:nginx /var/cache/nginx/` - меняем владельца и группу у каталога и -R ко всем подкаталогам.  \
`Healthcheck` - проверка состояния контейнера.  \
![Image](img/32.png )
*<p align="center">Рис 5.2 Dockerfile new<p>*

- Собираем образ и проверяем через **Dockle**  \
![Image](img/33.png )
*<p align="center">Рис 5.3 Проверяем собранный образ<p>*

- Запускаем контейнер и проверяем работоспособность  \
![Image](img/34.png )
![Image](img/34_2.png )
![Image](img/34_3.png )
*<p align="center">Рис 5.3 Проверка работоспособности контейнера<p>*


## Part 6. Базовый **Docker Compose**

##### Написать файл *docker-compose.yml*, с помощью которого:
##### 1) Поднять докер контейнер из [Части 5](#part-5-инструмент-dockle) _(он должен работать в локальной сети, т.е. не нужно использовать инструкцию **EXPOSE** и мапить порты на локальную машину)_
##### 2) Поднять докер контейнер с **nginx**, который будет проксировать все запросы с 8080 порта на 81 порт первого контейнера
##### Замапить 8080 порт второго контейнера на 80 порт локальной машины

- Создаем файл **docker-compose.yml**  \
![Image](img/35.png )
*<p align="center">Рис 6.1 docker-compose.yml<p>*

- Создадим Dockerfile для proxy.  \
![Image](img/36.png )
*<p align="center">Рис 6.2 Dockerfile для proxy<p>*

- Собираем и запускаем проект  \
`docker-compose build`  \
`docker-compose up`
![Image](img/37.png )
*<p align="center">Рис 6.3 Запускаем проект <p>*

- Запускаем браузер и проверяем localhost.  \
![Image](img/38.png )
*<p align="center">Рис 6.4 Проверяем работоспособность <p>*
