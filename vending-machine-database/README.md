# 🛒 Vending Machine Database System (MySQL)

## 📊 Project Overview

This project involves designing and implementing a complete **database system for a vending machine network**. The system tracks inventory, sales transactions, machines, products, and payment methods across multiple locations.

This demonstrates core **database design skills** including:
- ER modeling
- Normalization (3NF)
- Foreign key relationships
- Data integrity constraints
- SQL queries for business analysis

## 🎯 Objective

Create a robust database to manage:
- Multiple vending machines across different locations
- Product inventory and stock management
- Sales transactions with payment methods
- Maintenance tracking
- Revenue analysis

## 🛠 Tools Used

- **Database**: MySQL
- **Skills**: SQL, Database Design, ER Modeling, Query Optimization
- **Concepts**: Normalization, Foreign Keys, Data Constraints, Joins

## 📁 Project Structure

```
vending-machine-database/
├── README.md (this file)
├── 01_database_creation.sql (CREATE TABLE statements)
├── 02_foreign_keys_constraints.sql (Relationships & constraints)
├── 03_sample_data_insert.sql (Test data)
└── 04_sample_queries.sql (Sample queries & reports)
```

---

## 📊 Database Schema

### **Tables Overview**

| Table | Purpose | Key Fields |
|-------|---------|-----------|
| **Local** | Locations where machines are installed | id, nome |
| **Maquina** | Individual vending machines | codigo, idLocal, dataUltimaManut |
| **Produto** | Products sold in machines | id, nome, idTipo, refrigerado, valorPredefinido |
| **TipoProduto** | Product categories | id, nome |
| **Maquina_Produto** | Inventory per machine | codMaquina, idProduto, valorUnidade, stock |
| **Venda** | Sales transactions | codMaquina, idProduto, valor, dataHora, idMetodoPagamento |
| **MetodoDePagamento** | Payment methods | id, nome |

### **ER Diagram**

```
┌─────────────────┐
│     Local       │
│   id (PK)       │
│   nome          │
└────────┬────────┘
         │
         │ (1:N)
         │
┌────────▼──────────────┐
│      Maquina          │
│   codigo (PK)         │
│   idLocal (FK)        │
│   dataUltimaManut     │
└────────┬──────────────┘
         │
         │ (N:N through Maquina_Produto)
         │
┌────────▼──────────────────────┐
│   Maquina_Produto (Bridge)    │
│   codMaquina (FK, PK)         │
│   idProduto (FK, PK)          │
│   valorUnidade                │
│   stock                       │
└────────┬──────────────────────┘
         │
         │ (N:1)
         │
┌────────▼──────────────┐
│      Produto          │
│   id (PK)             │
│   nome                │
│   idTipo (FK)         │
│   refrigerado         │
│   valorPredefinido    │
└──────────────────────┘
         ▲
         │ (1:N)
         │
┌────────┴──────────────┐
│   TipoProduto         │
│   id (PK)             │
│   nome                │
└───────────────────────┘
```

---

## 🔑 Key Features

✅ **Proper Normalization** - Database designed in Third Normal Form (3NF)

✅ **Data Integrity** - Foreign key constraints ensure referential integrity

✅ **Inventory Management** - Track stock levels per machine and product

✅ **Sales Tracking** - Record every transaction with timestamp and payment method

✅ **Location Management** - Support for multiple vending machine locations

✅ **Maintenance Tracking** - Record maintenance dates for each machine

✅ **Payment Methods** - Support multiple payment types (Credit Card, Cash, MB Way, etc.)

---

## 📈 Sample Data

### **Locations**
- Centro Comercial (Shopping Center)
- Estação de Comboios (Train Station)
- Campus Universitário (University Campus)

### **Products**
- Bebidas (Drinks): Refrigerante
- Snacks: Batatas Fritas
- Doces (Sweets): Chocolate

### **Payment Methods**
- Cartão de Crédito (Credit Card)
- Dinheiro (Cash)
- MB Way (Mobile Payment)

### **Machines**
- 3 machines deployed across locations
- Different inventory per machine
- Maintenance dates tracked

---

## 📝 How to Use

### **1. Create the Database**
```bash
mysql -u root -p < 01_database_creation.sql
```

### **2. Add Foreign Keys & Constraints**
```bash
mysql -u root -p Proj_Final_GAD < 02_foreign_keys_constraints.sql
```

### **3. Insert Sample Data**
```bash
mysql -u root -p Proj_Final_GAD < 03_sample_data_insert.sql
```

### **4. Run Sample Queries**
```bash
mysql -u root -p Proj_Final_GAD < 04_sample_queries.sql
```

---

## 📊 Sample Queries Included

The project includes 10 useful queries:

1. **View All Locations** - List all machine locations
2. **View All Machines** - Machine details with location
3. **Check Inventory** - Product stock per machine
4. **Payment Methods** - Available payment options
5. **Product Catalog** - All products with types
6. **Sales Report** - All transactions with details
7. **Top Products** - Best-selling products
8. **Revenue by Location** - Sales per location
9. **Stock Status** - Low stock alerts
10. **Transaction History** - Detailed sales history

---

## 🎓 Learning Outcomes

This project demonstrates proficiency in:
- ✅ Database schema design
- ✅ Entity-Relationship modeling
- ✅ SQL DDL (Data Definition Language)
- ✅ Normalization principles
- ✅ Constraint management
- ✅ Data insertion and querying
- ✅ JOIN operations for complex queries
- ✅ Business logic in SQL

---

## 📌 Status

✅ **Complete** - Database fully functional with sample data and queries

---

