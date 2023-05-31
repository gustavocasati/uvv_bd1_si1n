--Aluno: Gustavo Casati
--Turma: SI1N

DROP DATABASE uvv;

DROP ROLE gustavo_casati;

-- crio meu usuário com senha encriptada

CREATE USER gustavo_casati 
							WITH ENCRYPTED PASSWORD 'gus'
							CREATEROLE
							CREATEDB
							LOGIN;

-- crio o meu banco de dados me dando titularidade

CREATE DATABASE uvv
                    OWNER=gustavo_casati
                    ENCODING 'UTF8'
                    TEMPLATE template0
                    LC_CTYPE 'pt_BR.UTF-8'
                    LC_COLLATE 'pt_BR.UTF-8'
                    ALLOW_CONNECTIONS TRUE;


-- conecto ao banco de dados com meu usuário e senha

\c "dbname=uvv user=gustavo_casati password=gus";

-- crio o esquema me dando titularidade

CREATE SCHEMA lojas OWNER gustavo_casati;

-- configuro o esquema lojas como path principal

SET SEARCH_PATH TO lojas, "$user", public;

-- coloco meu usuário para alterar os comandos

ALTER USER gustavo_casati
SET SEARCH_PATH TO lojas, "$user", public;

-- criação da tabela produtos com as informações e dados de cada produto vendido.

CREATE TABLE produtos (
                produto_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                preco_unitario NUMERIC(10,2) NOT NULL,
                detalhes BYTEA NOT NULL,
                imagem BYTEA NOT NULL,
                imagem_mime_type VARCHAR(512) NOT NULL,
                imagem_arquivo VARCHAR(512) NOT NULL,
                imagem_charset VARCHAR(512) NOT NULL,
                imagem_ultima_atualizacao DATE NOT NULL,
                CONSTRAINT produto_id_pk PRIMARY KEY (produto_id)
);
COMMENT ON TABLE produtos IS 'tabela de produtos';
COMMENT ON COLUMN produtos.produto_id IS 'produto id';
COMMENT ON COLUMN produtos.nome IS 'nome do produto';
COMMENT ON COLUMN produtos.preco_unitario IS 'preco unitario';
COMMENT ON COLUMN produtos.detalhes IS 'detalhes';
COMMENT ON COLUMN produtos.imagem_mime_type IS 'imagem mime type';
COMMENT ON COLUMN produtos.imagem_arquivo IS 'arquivo da imagem';
COMMENT ON COLUMN produtos.imagem_charset IS 'charset da imagem';
COMMENT ON COLUMN produtos.imagem_ultima_atualizacao IS 'data ultima atualizacao da imagem do produto';

-- criação da tabela lojas com todos os dados informativos de cada loja do sistema

CREATE TABLE lojas (
                loja_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                endereco_web VARCHAR(100),
                endereco_fisico VARCHAR(512),
                latitude NUMERIC,
                longitude NUMERIC,
                logo BYTEA,
                logo_mime_type VARCHAR(512),
                logo_arquivo VARCHAR(512),
                logo_charset VARCHAR(512),
                logo_ultima_atualizacao DATE,
                CONSTRAINT loja_id_pk PRIMARY KEY (loja_id)
);
COMMENT ON TABLE lojas IS 'tabela das lojas registradas';
COMMENT ON COLUMN lojas.loja_id IS 'id da loja';
COMMENT ON COLUMN lojas.nome IS 'nome da loja';
COMMENT ON COLUMN lojas.endereco_web IS 'link da loja online';
COMMENT ON COLUMN lojas.endereco_fisico IS 'endereco fisico da loja';
COMMENT ON COLUMN lojas.latitude IS 'latitude da loja';
COMMENT ON COLUMN lojas.longitude IS 'longitude';
COMMENT ON COLUMN lojas.logo IS 'logo da loja';
COMMENT ON COLUMN lojas.logo_mime_type IS 'logo mime';
COMMENT ON COLUMN lojas.logo_arquivo IS 'arquivo da logo';
COMMENT ON COLUMN lojas.logo_charset IS 'charset da logo';
COMMENT ON COLUMN lojas.logo_ultima_atualizacao IS 'ultima atualização da logo';

-- criação da tabela estoques para controle dos produtos e quantidade dos mesmos

CREATE TABLE estoques (
                estoque_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                CONSTRAINT estoque_id_pk PRIMARY KEY (estoque_id)
);
COMMENT ON TABLE estoques IS 'tabela de controle dos estoques';
COMMENT ON COLUMN estoques.estoque_id IS 'id do estoque';
COMMENT ON COLUMN estoques.loja_id IS 'id da loja';
COMMENT ON COLUMN estoques.produto_id IS 'id do produto';
COMMENT ON COLUMN estoques.quantidade IS 'quantidade do produto em estoque';

-- criação tabela clientes com todos os dados de contato de cada cliente registrado no sistema

CREATE TABLE clientes (
                cliente_id NUMERIC(38) NOT NULL,
                email VARCHAR(255) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                telefone1 VARCHAR(20),
                telefone2 VARCHAR(20),
                telefone3 VARCHAR(20),
                CONSTRAINT cliente_id_pk PRIMARY KEY (cliente_id)
);
COMMENT ON COLUMN clientes.cliente_id IS 'registro dos clientes';
COMMENT ON COLUMN clientes.email IS 'email do cliente';
COMMENT ON COLUMN clientes.nome IS 'nome do cliente';
COMMENT ON COLUMN clientes.telefone1 IS 'telefone primário';
COMMENT ON COLUMN clientes.telefone2 IS 'telefone secundário';
COMMENT ON COLUMN clientes.telefone3 IS 'terceiro telefone';

-- criação tabela envio, para controle de todos os envios realizados

CREATE TABLE envio (
                envio_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                endereco_entrega VARCHAR(512) NOT NULL,
                status VARCHAR(15) NOT NULL,
                CONSTRAINT envio_id_pk PRIMARY KEY (envio_id)
);
COMMENT ON TABLE envio IS 'registro dos envios';
COMMENT ON COLUMN envio.envio_id IS 'id do envio';
COMMENT ON COLUMN envio.loja_id IS 'id da loja vendedora';
COMMENT ON COLUMN envio.cliente_id IS 'registro dos clientes';
COMMENT ON COLUMN envio.endereco_entrega IS 'endereco de entrega';
COMMENT ON COLUMN envio.status IS 'status do envio';

-- criação da tabela pedidos para ter controle de todos os pedidos do sistema

CREATE TABLE pedidos (
                pedido_id NUMERIC(38) NOT NULL,
                data_hora TIMESTAMP NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                status VARCHAR(15) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                CONSTRAINT pedido_id_pk PRIMARY KEY (pedido_id)
);
COMMENT ON TABLE pedidos IS 'tabela que armazena os pedidos';
COMMENT ON COLUMN pedidos.pedido_id IS 'id do pedido';
COMMENT ON COLUMN pedidos.data_hora IS 'data e hora do pedido';
COMMENT ON COLUMN pedidos.cliente_id IS 'id do cliente';
COMMENT ON COLUMN pedidos.status IS 'status do pedido';
COMMENT ON COLUMN pedidos.loja_id IS 'id da loja';

-- criação da tabela para ter controle de todos os itens presentes no pedido do cliente.

CREATE TABLE pedidos_itens (
                pedido_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                numero_da_linha NUMERIC(38) NOT NULL,
                preco_unitario NUMERIC(10,2) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                envio_id VARCHAR(38) NOT NULL,
                envio_envio_id NUMERIC(38) NOT NULL,
                CONSTRAINT pedidos_itens_pk PRIMARY KEY (pedido_id, produto_id)
);
COMMENT ON COLUMN pedidos_itens.pedido_id IS 'id do pedido';
COMMENT ON COLUMN pedidos_itens.produto_id IS 'produto id';
COMMENT ON COLUMN pedidos_itens.numero_da_linha IS 'numero da linha';
COMMENT ON COLUMN pedidos_itens.preco_unitario IS 'preco unitario';
COMMENT ON COLUMN pedidos_itens.quantidade IS 'quantidade no pedido';
COMMENT ON COLUMN pedidos_itens.envio_envio_id IS 'id do envio';

--criação das constraints de checagem
ALTER TABLE pedidos 
ADD CONSTRAINT verificacao_pedidos
CHECK (status IN ('COMPLETO', 'ABERTO', 'CANCELADO', 'PAGO', 'ENVIADO', 'REEMBOLSADO'));

ALTER TABLE envio
ADD CONSTRAINT verificacao_envios
CHECK (status IN ('ENTREGUE', 'CRIADO', 'TRANSITO', 'ENVIADO'));

ALTER TABLE lojas
ADD CONSTRAINT verificacao_enderecos
CHECK ((endereco_fisico IS NOT NULL AND endereco_web IS NULL) OR
       (endereco_fisico IS NULL AND endereco_web IS NOT NULL));

-- configuração das FK e PK

ALTER TABLE pedidos_itens ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE envio ADD CONSTRAINT lojas_envio_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE envio ADD CONSTRAINT clientes_envio_fk
FOREIGN KEY (cliente_id)
REFERENCES clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pedidos_itens ADD CONSTRAINT envio_pedidos_itens_fk
FOREIGN KEY (envio_envio_id)
REFERENCES envio (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pedidos_itens ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;