drop database if exists twitter;

create database twitter;

\c twitter;

create table tweets(content varchar(255));

insert into tweets values ('my first tweet');
insert into tweets values ('my second tweet');
