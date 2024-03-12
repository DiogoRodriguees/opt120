--create database opt120
--drop table if exists usuario_atividade, atividades, usuarios;


create table usuarios (
	id serial not null,
	nome varchar(50) not null,
	email varchar(50) not null,
	senha varchar(100) not null,
	
	created_at timestamp not null default current_timestamp,
	updated_at timestamp ,
	deleted_At timestamp,
	
	constraint pk_usuario_id primary key (id)
);

create table atividades (
	id serial  not null,
	titulo varchar(50) not null,
	descricao varchar(90),
	date timestamp,
	
	created_at timestamp not null default current_timestamp,
	updated_at timestamp,
	deleted_At timestamp,
	
	constraint pk_atividade_id primary key (id)
);

create table usuario_atividade (
	usuario_id integer not null,
	atividade_id integer not null,
	data_entrega timestamp,
	nota float,
	
	constraint pk_usuario_atividade_id primary key (usuario_id, atividade_id),
	constraint fk_usuario foreign key (usuario_id) references usuarios(id),
	constraint fk_atividade foreign key (atividade_id) references atividades(id)
);

--insert into usuarios(nome, email, senha) values ('diogo', 'diogo@email.com', '@Senha123');
--insert into usuarios(nome, email, senha) values ('iago', 'iago@email.com', '@Senha123');
--insert into usuarios(nome, email, senha) values ('marcos', 'marcos@email.com', '@Senha123');
--insert into usuarios(nome, email, senha) values ('tiago', 'tiago@email.com', '@Senha123');
--
--insert into atividades(titulo, descricao, date) values('bd2', 'revisao de bd1', current_timestamp);
--insert into atividades(titulo, descricao, date) values('desenv movel', 'scripts sql', current_timestamp);
--insert into atividades(titulo, descricao, date) values('sd', 'caracterização de SDs', current_timestamp);




