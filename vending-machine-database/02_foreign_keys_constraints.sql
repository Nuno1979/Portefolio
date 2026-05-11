-- ================================================
-- VENDING MACHINE DATABASE - FOREIGN KEYS
-- ================================================
-- This script adds all foreign key constraints
-- to establish relationships between tables
-- ================================================

USE Proj_Final_GAD;

-- ================================================
-- CONSTRAINT: FK_Produto_TipoProduto
-- Description: Each product belongs to a type
-- ================================================
ALTER TABLE Produto
ADD CONSTRAINT FK_Produto_TipoProduto
FOREIGN KEY (idTipo) REFERENCES TipoProduto(id);

-- ================================================
-- CONSTRAINT: FK_Maquina_Local
-- Description: Each machine is located at a site
-- ================================================
ALTER TABLE Maquina
ADD CONSTRAINT FK_Maquina_Local
FOREIGN KEY (idLocal) REFERENCES Local(id);

-- ================================================
-- CONSTRAINT: FK_MaquinaProduto_Maquina
-- Description: Inventory links to machines
-- ================================================
ALTER TABLE Maquina_Produto
ADD CONSTRAINT FK_MaquinaProduto_Maquina
FOREIGN KEY (codMaquina) REFERENCES Maquina(codigo);

-- ================================================
-- CONSTRAINT: FK_MaquinaProduto_Produto
-- Description: Inventory links to products
-- ================================================
ALTER TABLE Maquina_Produto
ADD CONSTRAINT FK_MaquinaProduto_Produto
FOREIGN KEY (idProduto) REFERENCES Produto(id);

-- ================================================
-- CONSTRAINT: FK_Venda_Maquina
-- Description: Sales transactions reference machine
-- ================================================
ALTER TABLE Venda
ADD CONSTRAINT FK_Venda_Maquina
FOREIGN KEY (codMaquina) REFERENCES Maquina_Produto(codMaquina);

-- ================================================
-- CONSTRAINT: FK_Venda_Produto
-- Description: Sales transactions reference product
-- ================================================
ALTER TABLE Venda
ADD CONSTRAINT FK_Venda_Produto
FOREIGN KEY (idProduto) REFERENCES Maquina_Produto(idProduto);

-- ================================================
-- CONSTRAINT: FK_Venda_MetodoDePagamento
-- Description: Sales transactions link to payment method
-- ================================================
ALTER TABLE Venda
ADD CONSTRAINT FK_Venda_MetodoDePagamento
FOREIGN KEY (idMetodoPagamento) REFERENCES MetodoDePagamento(id);
