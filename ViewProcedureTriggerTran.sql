-- Liberando Updates
SET SQL_SAFE_UPDATES=0;

/* Exercício 1
Crie uma view que retorne os dados dos livros e seus respectivos autores (código e nome dos livros e código e nomes dos autores);*/
CREATE VIEW vwLivroAutor AS
SELECT L.ISBN, L.ASSUNTO, A.AUTOR, A.LIVRO_ISBN
FROM LIVRO AS L
INNER JOIN AUTOR AS A
ON L.ISBN = A.LIVRO_ISBN;
-- Utilizando a View
SELECT * FROM vwLivroAutor;

/*Exercício 2
Crie uma trigger que atualize a quantidade de livros em estoque a cada venda e a cada compra, 
ou seja, a cada venda ou compra realizada, deve ser decrementada ou incrementada a quantidade de livros em estoque*/
DELIMITER $
CREATE TRIGGER trAtualizaEstoque AFTER INSERT
ON CLIENTE_LIVRO
FOR EACH ROW
BEGIN
  UPDATE LIVRO SET QUANTIDADE = QUANTIDADE - 1
  WHERE LIVRO.ISBN = NEW.LIVRO_ISBN;
END $
DELIMITER ;
-- Testando Trigger
SELECT * FROM CLIENTE_LIVRO;
SELECT * FROM LIVRO;
INSERT INTO CLIENTE_LIVRO(CODIGO_CLIENTE, LIVRO_ISBN, DATA) VALUES (2, 912218989, '2022-06-29');

/*Exercício 3
Crie uma procedure com consulta na base de dados, a partir de parâmetros de entrada para filtragem dos dados. 
É necessário que exista o retorno de dados pertencentes a tabelas diferentes na criação destes comandos das procedures;*/
DELIMITER $
CREATE PROCEDURE prcAutoresLivro(IN codigoISBN INT, OUT qtdAutores VARCHAR(150))
BEGIN
  -- SELECT L.ASSUNTO, COUNT(*) INTO qtdAutores
  SELECT CONCAT(L.ASSUNTO, ' - ', COUNT(*)) INTO qtdAutores 
  FROM AUTOR A
  INNER JOIN LIVRO L
  ON L.ISBN = A.LIVRO_ISBN
  WHERE LIVRO_ISBN = codigoISBN
  GROUP BY L.ASSUNTO;
END $
DELIMITER ;
-- Teste Procedure
CALL prcAutoresLivro(912218989, @qtdAutores);
SELECT @qtdAutores;
CALL prcAutoresLivro(923215885, @qtdAutores);
SELECT @qtdAutores;

select * from LIVRO;

/* Exercício 4
Crie uma procedure que receba por parâmetro o código do cliente e retorne todos os 
livros (código, nome do livro, data da venda e quantidade de livros) que já comprou;*/
DELIMITER $
CREATE PROCEDURE prcClienteLivros(IN codigoCliente INT)
BEGIN
  SELECT L.ISBN, L.ASSUNTO, C.DATA AS 'DATA_VENDA', L.QUANTIDADE
  FROM CLIENTE_LIVRO AS C
  INNER JOIN LIVRO AS L
  ON C.LIVRO_ISBN = L.ISBN
  WHERE C.CODIGO_CLIENTE = codigoCliente;
END $
DELIMITER ;
-- Teste Procedure
CALL prcClienteLivros(2);
CALL prcClienteLivros(1);