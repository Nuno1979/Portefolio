-- ================================================
-- VENDING MACHINE DATABASE - CREATION SCRIPT
-- ================================================
-- This script creates the database schema for a
-- vending machine management system
-- ================================================

CREATE DATABASE Proj_Final_GAD;
USE Proj_Final_GAD;

-- ================================================
-- TABLE: Local
-- Description: Locations where vending machines
--              are installed
-- ================================================
CREATE TABLE Local (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

-- ================================================
-- TABLE: TipoProduto
-- Description: Product categories
-- ================================================
CREATE TABLE TipoProduto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

-- ================================================
-- TABLE: Produto
-- Description: Products sold in vending machines
-- ================================================
CREATE TABLE Produto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    idTipo INT NOT NULL,
    refrigerado BOOLEAN NOT NULL,
    valorPredefinido DECIMAL(10, 2)
);

-- ================================================
-- TABLE: Maquina
-- Description: Individual vending machines
-- ================================================
CREATE TABLE Maquina (
    codigo INT AUTO_INCREMENT PRIMARY KEY,
    idLocal INT NOT NULL,
    dataUltimaManut DATE
);

-- ================================================
-- TABLE: MetodoDePagamento
-- Description: Available payment methods
-- ================================================
CREATE TABLE MetodoDePagamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

-- ================================================
-- TABLE: Maquina_Produto
-- Description: Bridge table for N:N relationship
--              Tracks inventory per machine
-- ================================================
CREATE TABLE Maquina_Produto (
    codMaquina INT NOT NULL,
    idProduto INT NOT NULL,
    valorUnidade DECIMAL(10, 2),
    stock INT,
    PRIMARY KEY (codMaquina, idProduto)
);

-- ================================================
-- TABLE: Venda
-- Description: Sales transactions
-- ================================================
CREATE TABLE Venda (
    codMaquina INT NOT NULL,
    idProduto INT NOT NULL,
    valor DECIMAL(10, 2),
    dataHora DATETIME NOT NULL,
    idMetodoPagamento INT NOT NULL
);
