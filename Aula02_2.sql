USE Escola;
GO

-- Excluir as tabelas caso ja existam (idempotencia) --
DROP TABLE IF EXISTS Cursos;
DROP TABLE IF EXISTS Matriculas;

CREATE TABLE Cursos (
	id INT PRIMARY KEY IDENTITY (1,1),
	NomeCurso NVARCHAR (100) NOT NULL,
	CargaHoraria INT NOT NULL
	);

INSERT INTO Cursos (NomeCurso,CargaHoraria)
VALUES
('SQL',		40),
('Python',	32),
('Power BI',70),
('Excel',	16),
('PHP',		80);

CREATE TABLE Matriculas (
	id INT PRIMARY KEY IDENTITY (1,1),
	AlunoId INT NOT NULL,
	CursoId INT NOT NULL,
	DataInscricao DATE NOT NULL,

	FOREIGN KEY (AlunoId) REFERENCES Alunos(id),
	FOREIGN KEY (CursoId) REFERENCES Cursos(id)
	);

INSERT INTO Matriculas (AlunoId, CursoId, DataInscricao)
VALUES
(6,1,'2025-09-11'),
(7,2,'2025-09-11'),
(11,3,'2024-11-12'),
(16,4,'2025-07-19'),
(17,5,'2025-04-25'),
(18,2,'2025-03-18');

SELECT * FROM Matriculas

--Inner Join--

SELECT a.Nome,a.Email,NomeCurso,m.DataInscricao
FROM Alunos a

INNER JOIN Matriculas m ON a.id=m.AlunoId
INNER JOIN Cursos c ON c.id=m.CursoId

ORDER BY a.Nome

INSERT INTO Alunos (Nome, Idade, Email, DataMatricula)
VALUES
	(N'Thamires',32,'thamires@gmail.com','2025-02-12'),
	(N'Antonio',22,'antonio@gmail.com','2025-06-01');

-- Left Join (mostrar todos os alunos mesmo sem matricula) --

SELECT a.Nome, c.NomeCurso,m.DataInscricao
FROM Alunos a

LEFT JOIN Matriculas m ON a.id=m.AlunoId
LEFT JOIN Cursos c ON c.id=m.CursoId

ORDER BY M.DataInscricao

--Tabela de professores--
DROP TABLE IF EXISTS Professores
CREATE TABLE Professores (
	id INT PRIMARY KEY IDENTITY (1,1),
	Nome NVARCHAR (100) NOT NULL,
	Email NVARCHAR (100) 
	);

INSERT INTO Professores (Nome,Email)
VALUES
	('Katia','katia@gmail.com'),
	('Ricardo','ricardo@gmail.com'),
	('Sibeli','sibeli@gmail.com');

SELECT * FROM Professores

-- Tabela de Notas --

DROP TABLE IF EXISTS Notas
CREATE TABLE Notas(
	id INT PRIMARY KEY IDENTITY (1,1),
	AlunoId INT NOT NULL,
	CursoId INT NOT NULL,
	NOTA INT NOT NULL,
	DataAvaliacao DATE NOT NULL

	FOREIGN KEY (AlunoId) REFERENCES Alunos(id),
	FOREIGN KEY (CursoId) REFERENCES Cursos(id)
	);

INSERT INTO Notas (AlunoId,CursoId,Nota,DataAvaliacao)
VALUES
	(6,2,8,'2025-12-14'),
	(7,1,5,'2025-08-02'),
	(11,5,2,'2025-05-17'),
	(18,5,5,'2025-05-16'),
	(20,3,9,'2025-03-17'),
	(17,4,10,'2025-06-22');

SELECT * FROM Notas;

--Tabela de Pagamentos--
DROP TABLE IF EXISTS Pagamentos
CREATE TABLE Pagamentos (
	id INT PRIMARY KEY IDENTITY (1,1),
	AlunoId INT NOT NULL,
	Valor INT NOT NULL,
	DataPagamento DATE NOT NULL,
	Situacao NVARCHAR(10) NOT NULL,

	FOREIGN KEY (AlunoId) REFERENCES Alunos(id)
	);

INSERT INTO Pagamentos (AlunoId,Valor,DataPagamento,Situacao)
VALUES
	(6,300,'2024-05-01','Pago'),
	(7,500,'2024-07-12','Atrasado'),
	(11,400,'2024-12-05','Atrasado'),
	(18,250,'2024-06-11','Pago'),
	(20,180,'2024-03-18','Atrasado'),
	(17,720,'2024-09-22','Pago'),
	(19,850,'2024-11-07','Pago'),
	(16,230,'2024-01-15','Atrasado');

SELECT * FROM Pagamentos;

-- Mostrar notas dos alunos em cada curso--
SELECT
	a.Nome AS Aluno,
	c.NomeCurso AS Curso,
	n.Nota,
	n.DataAvaliacao AS Data
FROM Notas n

INNER JOIN Alunos a ON a.id=n.AlunoId
INNER JOIN Cursos c ON c.id=n.CursoId

ORDER BY n.DataAvaliacao DESC

--Media de notas por curso--Agrupar cursos--

SELECT c.NomeCurso, AVG (n.Nota) AS 'Media de Notas'
FROM Notas n

INNER JOIN Cursos c ON c.id=n.CursoId
GROUP BY c.NomeCurso
ORDER BY 'Media de Notas' DESC;

--Visualizar a situação de pagamento por aluno--
SELECT a.Nome,p.Valor,p.DataPagamento,p.Situacao AS 'Situação do pagamento'
FROM Pagamentos p

INNER JOIN Alunos a ON a.id=p.AlunoId
ORDER BY p.DataPagamento DESC;

--Quantidade de alunos por situação de pagamento--
SELECT p.Situacao, COUNT(*) AS Quantidade
FROM Pagamentos p
GROUP BY p.situacao
ORDER BY Quantidade DESC;


