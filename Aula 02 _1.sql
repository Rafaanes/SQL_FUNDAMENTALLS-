USE master;
GO

-- idempotente/idempotência (Executa mais de uma vez) para criar o banco de dados e a tabela Alunos

DROP DATABASE IF EXISTS Escola;
GO

CREATE DATABASE Escola;
GO

USE Escola;
GO


DROP TABLE IF EXISTS Alunos;
CREATE TABLE Alunos (
	id INT IDENTITY(1,1) PRIMARY KEY,
	Nome NVARCHAR(100) NOT NULL,
	Idade INT,
	Email NVARCHAR (100),
	DataMatricula DATE NOT NULL
	);

	INSERT INTO Alunos(Nome,Idade,Email,DataMatricula)
	VALUES 
	(N'Caio',38,N'kio199@gmail.com','2025-02-12'),
	(N'Diego',29,N'Diego@gmail.com','2023-07-15'),
	(N'Rafaélla',25,N'Rafa@gmail.com','2025-10-02'),
	(N'Juliana',27,N'Ju@gmail.com','2024-12-27'),
	(N'Marcela',18,N'marcela@gmail.com','2021-09-30');

SELECT * FROM Alunos;

-- mostrando alunso com idades menores que 26 anos
SELECT * FROM Alunos WHERE Idade<= 26;

-- mostra alunos mais novos primeiro
SELECT * FROM Alunos ORDER BY Idade ASC;

SELECT * FROM Alunos ORDER BY Nome ASC;

-- Atualizando os dados --
UPDATE Alunos
SET Email=N'rafaanes1@hotmail.com'
WHERE id=8;

SELECT id, Nome, Email FROM Alunos
WHERE id=8;

UPDATE Alunos 
SET Idade=Idade+1;

-- Remoção de dados --
DELETE FROM Alunos
WHERE id=8;

DELETE FROM Alunos
WHERE Idade<30;

-- Mostrar todos os alunos que começam com uma letra especifica --
-- coringa (%) --
SELECT * FROM Alunos
WHERE Nome LIKE N'D%';

-- Mostrar os 3 alunos mais novos e o mais velho (TOP)--
SELECT TOP 3 * FROM Alunos
ORDER BY Idade ASC;

SELECT TOP 1 * FROM Alunos
ORDER BY Idade DESC;

-- Contar quantos alunos tem na tabela (COUNT)--
SELECT COUNT(*) AS 'Total Alunos' FROM Alunos;

-- Calcular a media de idade dos alunos (AVG) --
SELECT AVG(Idade) AS 'Idade Media' FROM Alunos;







