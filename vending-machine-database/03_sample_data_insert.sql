-- ================================================
-- VENDING MACHINE DATABASE - SAMPLE DATA
-- ================================================
-- This script populates the database with
-- sample data for testing and demonstration
-- ================================================

USE Proj_Final_GAD;

-- ================================================
-- INSERT: Local (Locations)
-- ================================================
INSERT INTO Local (id, nome) VALUES
(1, 'Centro Comercial'),
(2, 'Estação de Comboios'),
(3, 'Campus Universitário');

-- ================================================
-- INSERT: Maquina (Vending Machines)
-- ================================================
INSERT INTO Maquina (codigo, idLocal, dataUltimaManut) VALUES
(1001, 1, '2025-01-01'),
(1002, 2, '2025-01-15'),
(1003, 3, '2024-12-25');

-- ================================================
-- INSERT: TipoProduto (Product Types)
-- ================================================
INSERT INTO TipoProduto (id, nome) VALUES
(1, 'Bebidas'),
(2, 'Snacks'),
(3, 'Doces');

-- ================================================
-- INSERT: Produto (Products)
-- ================================================
INSERT INTO Produto (id, nome, idTipo, refrigerado, valorPredefinido) VALUES
(1, 'Refrigerante', 1, TRUE, 2.50),
(2, 'Batatas Fritas', 2, FALSE, 1.75),
(3, 'Chocolate', 3, FALSE, 2.00);

-- ================================================
-- INSERT: Maquina_Produto (Inventory)
-- ================================================
INSERT INTO Maquina_Produto (codMaquina, idProduto, valorUnidade, stock) VALUES
(1001, 1, 2.50, 20),
(1001, 2, 1.75, 15),
(1002, 3, 2.00, 10);

-- ================================================
-- INSERT: MetodoDePagamento (Payment Methods)
-- ================================================
INSERT INTO MetodoDePagamento (id, nome) VALUES
(1, 'Cartão de Crédito'),
(2, 'Dinheiro'),
(3, 'MB Way');

-- ================================================
-- INSERT: Venda (Sales Transactions)
-- ================================================
INSERT INTO Venda (codMaquina, idProduto, dataHora, valor, idMetodoPagamento) VALUES
(1001, 1, '2025-01-20 10:00:00', 2.50, 1),
(1001, 2, '2025-01-20 11:00:00', 1.75, 2),
(1002, 3, '2025-01-21 15:30:00', 2.00, 3);
