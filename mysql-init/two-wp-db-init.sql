create database wp1;
grant all privileges on wp1.* to wp1@'%' identified by 'wp1pass';
create database wp2;
grant all privileges on wp2.* to wp2@'%' identified by 'wp2pass';
flush privileges;
