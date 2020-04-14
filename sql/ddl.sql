-- CRUD in the databse, account

-- Create a table (Create)
create table if not exists account
(
id VARCHAR(50) NOT NULL PRIMARY KEY,
name VARCHAR(70) NOT NULL,
balance DECIMAL(5, 2),
open TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create a table (Create)
create table if not exists history
(
id VARCHAR(50) NOT NULL,
deposit TIMESTAMP NULL,
withdrawal TIMESTAMP NULL,
transfer VARCHAR(100) NULL,
amount DECIMAL(5, 2),
balance DECIMAL(5, 2),
FOREIGN KEY (id) REFERENCES account(id)
);

-- Procedure to insert vaules to the table, account
DELIMITER ;;
create procedure create_account
(
a_id VARCHAR(50),
a_name VARCHAR(70),
a_deposit DECIMAL(5, 2)
)
BEGIN

START TRANSACTION;
IF (a_deposit = '' OR a_deposit IS NULL) THEN
ROLLBACK;
select "Fill the deposit" as message;
ELSE
INSERT INTO account (id, name, balance) VALUES (a_id, a_name, a_deposit);

INSERT INTO history (id, deposit, amount, balance) VALUES (a_id, CURRENT_TIMESTAMP, a_deposit, a_deposit);

COMMIT;
END IF;
END
;;
DELIMITER ;

-- Procedure for reading the data of the table (Read)
DELIMITER ;;
create procedure show_account()
BEGIN

select id, name, balance, DATE_FORMAT(open, '%Y-%m-%d %T') as open from account order by open asc;

END
;;
DELIMITER ;

-- Procedure for updating the data of the tables (Update)
DELIMITER ;;
create procedure deposit
(
d_id VARCHAR(50),
amount DECIMAL(5, 2)
)
BEGIN

UPDATE account SET balance = balance + amount
WHERE id = d_id;

INSERT INTO history (id, deposit, amount, balance) VALUES (d_id, CURRENT_TIMESTAMP, amount, (select balance from account as a where d_id=a.id));

END
;;
DELIMITER ;

-- Procedure for updating the data of the tables (Update)
DELIMITER ;;
create procedure withdrawal
(
w_id VARCHAR(50),
amount DECIMAL(5, 2)
)
BEGIN
START TRANSACTION;
IF (select balance from account where id = w_id) - amount < 0 THEN
ROLLBACK;
select "Amount on the account is not enough to make transaction." as message;
ELSE
UPDATE account SET balance = balance - amount
WHERE id = w_id;
INSERT INTO history (id, withdrawal, amount, balance) VALUES (w_id, CURRENT_TIMESTAMP, amount, (select balance from account as a where w_id=a.id));
COMMIT;
END IF;
END
;;
DELIMITER ;

-- Procedure for reading the data of the table (Read)
DELIMITER ;;
create procedure history
(
h_id VARCHAR(50)
)
BEGIN

select id, DATE_FORMAT(deposit, '%Y-%m-%d %T') as deposit, DATE_FORMAT(withdrawal, '%Y-%m-%d %T') as withdrawal, transfer, amount, balance from history WHERE id = h_id;

END
;;
DELIMITER ;

-- Procedure for reading the date of the table (Read)
DELIMITER ;;
create procedure select_id()
BEGIN

select id from account;

END
;;
DELIMITER ;

-- Procedure for reading the data of the table (Read)
DELIMITER ;;
create procedure id_balance
(
b_id VARCHAR(50)
)
BEGIN

select balance from account where id = b_id;

END
;;
DELIMITER ;

-- Procedure for updating the data of the table (Update)
DELIMITER ;;
create procedure transfer
(
t_id VARCHAR(50),
t_receiver VARCHAR(50),
t_amount DECIMAL (5, 2) 
)
BEGIN

START TRANSACTION;

IF (select balance from account where id = t_id) - t_amount < 0 THEN
ROLLBACK;
select "Amount on the account is not enough to make transaction." as message;
ELSE
UPDATE account SET balance = balance - t_amount WHERE id = t_id;
UPDATE account SET balance = balance + t_amount WHERE id = t_receiver;

INSERT INTO history (id, withdrawal, transfer, amount, balance) VALUES (t_id, CURRENT_TIMESTAMP, CONCAT(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y-%m-%d %T'), " (", t_id, "/", t_receiver, " )"), t_amount, (select balance from account where id = t_id));

INSERT INTO history (id, deposit, transfer, amount, balance) VALUES (t_receiver, CURRENT_TIMESTAMP, CONCAT(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y-%m-%d %T'), " (", t_id, "/", t_receiver, " )"), t_amount, (select balance from account where id = t_receiver)); 

COMMIT ;
END IF ;
END
;;
DELIMITER ;


-- Prodecure for deleting the data of the table (Delete)
DELIMITER ;;
create procedure close
(
d_id VARCHAR(50)
)
BEGIN

delete from history WHERE id = d_id;
delete from account WHERE id = d_id;

END
;;
DELIMITER ;

