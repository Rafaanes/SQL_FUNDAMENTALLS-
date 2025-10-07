-- Criar comentário
/*comentario
de varias
linhas*/
-- PascalCase snake_case camelCase --
CREATE DATABASE db0610_Cadastro;

USE db0610_Cadastro;

-- criando uma tabela de pessoas!

CREATE TABLE tb_alunos(
	id_aluno INT IDENTITY(1,1) PRIMARY KEY,
	nome VARCHAR(50) NOT NULL, 
	idade VARCHAR (3),
	uf CHAR(2) NOT NULL
	);

-- Inserir alguns dados na tabela

INSERT INTO tb_alunos (nome, idade, uf)
VALUES ('Caio',38,'SP');

SELECT * FROM tb_alunos; -- Não é necessário adicionar o select novamente, pode apenas executar o já criado

INSERT INTO tb_alunos (nome, idade, uf)
VALUES ('Rafaélla',28,'SP');

SELECT * FROM tb_alunos;

-- Adicionando uma coluna de cidade
ALTER TABLE tb_alunos ADD cidade VARCHAR(30);

ALTER TABLE tb_alunos DROP COLUMN cidade

-- Selecionar apenas nome e idade
SELECT nome,idade FROM tb_alunos;

-- Mostra apenas pessoas de SP
SELECT * FROM tb_alunos WHERE uf = 'SP';

-- Mostra apenas pessoas com idade maior que 30
SELECT * FROM tb_alunos WHERE idade >= 30;

/*
>= maior ou igual
<= menor ou igual
< menor
> maior
*/

