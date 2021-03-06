#### Поддерживается
- ansible 2
- Debian 8 jessie

#### Использование

- Указать ключи AWS
- Установить зависимости из galaxy
```
ansible-galaxy install -r requirements.yml -p ./common
```
- Настроить параметры приложения в vars/
- Запустить облако

```
ansible-playbook  -i ec2.py  site.yml
```
- Запустить настройку инстансов вручную поочередно

```
ansible-playbook  -i ec2.py  playbook_proxy.yml
ansible-playbook  -i ec2.py  playbook_blog.yml
ansible-playbook  -i ec2.py  playbook_admin.yml
ansible-playbook  -i ec2.py  playbook_redis.yml
ansible-playbook  -i ec2.py  playbook_monitoring.yml
ansible-playbook  -i ec2.py  playbook_autoreg.yml
ansible-playbook  -i ec2.py  playbook_agent.yml
```
- Запустить настройку инстансов автоматически в нужном порядке
```
ansible-playbook  -i ec2.py main.yml
```

![pic](/pic.png)

#### Пояснение
	Представлена схема сервиса, предоставляющего хостинг блогов.
	Пользователи (Users)  и администратор (Administrator) могут заходить в блог (Blog Application). Для администратора доступны панель администрирования (Admin Application) и сервер мониторинга (Monitoring Server). На каждый сервер должен быть доступ по SSH. Блог и панель администрирования должны быть доступны через один домен (или IP-адрес) - т.е. эти компоненты принимают запросы через прокси-сервер (Proxy Server). Сервер мониторинга доступен напрямую (аутентификация, как правило, реализуется через средства ПО на самом сервере).

	Приложения для блога и панель администрирования делят между собой удаленную базу данных (Database) и хранилище Redis (Redis Server).

	Данные из RDS PostgreSQL должны попадать в RedShift для дальнейшей обработки.

	Важное замечание - RDS должна быть только PostgreSQL.

### Что нужно выполнить
	1. Написать скрипт, который устанавливает стек на Amazon Web Services с нуля - т.е. этому скрипту необходимо лишь знать ключи доступа к аккаунту (credentials).
	      -  Создание инстанца для каждого компонента (AWS RDS - для базы данных, EC2 - для остальных компонентов)
	      -  На каждый компонент установить [Security groups](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html) - на схеме однонаправленые стрелки обозначают: для инстанца, где лежит начало стрелки должен быть доступен тот инстанц, где лежит конец стрелки; открыть доступ по SSH для всех инстанцов.
	            -  Возможность динамического определения хоста для каждого компонента для скриптов в дальнейшем. Например: как реализовано в [Ansible для AWS](http://docs.ansible.com/intro_dynamic_inventory.html#example-aws-ec2-external-inventory-script).
		    2. Написать скрипт, который устанавливает все необходимое программное обеспечение на каждый EC2-инстанц (подробнее в "Описании компонентов стека")
		    3. Написать скрипт, который устанавливает мониторинг для всех компонентов. Обязательные параметры: загрузка памяти (диска и ОЗУ), загрузка CPU. Дополнительные параметры приветствуются. Мониторинг должен осуществлятся через отдельный сервер (Monitoring Server). Особенности реализации - на ваше усмотрение.
		    4. Вручную создать RedShift инстанс и реализовать переливку данных из RDS PostgreSQL в RedShift (Sqoop, Datapipeline, etc…).

### Описание компонентов стека
		        Proxy Server - как правило это веб-сервер (NGINX, Apache).
			    Admin Application, Blog Application - необоходимо установить ПО для установки веб-фреймворка (Django, Rails или др.)
	    Redis Server - говорит само за себя
	        Database  - нет необходимости устанавливать что-либо. (в RDS PostgreSQL  уже все необходимое есть)
	    RedShift - говорит само за себя
