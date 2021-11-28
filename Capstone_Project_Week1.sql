-- CREATE DATABASE db_employee;
CREATE TABLE Departments(Dept_id INT NOT NULL,
						Dept_name VARCHAR(35) NOT NULL,
						Description_ VARCHAR(100)  DEFAULT NULL,
                        PRIMARY KEY(Dept_id)                     
                        )
                        
CREATE TABLE Jobs(Job_id INT NOT NULL,
				  Job_title VARCHAR(35) NOT NULL ,
				  min_salary_ DECIMAL(6,0)  DEFAULT NULL,
				  max_salary DECIMAL(6,0) ,
                  PRIMARY KEY(Job_id)                            
                  )
                  
-- I just make the data type of employees' every column  according to my view----------------------------------
CREATE TABLE employees(employee_id INT NOT NULL,
						first_name VARCHAR(35) NOT NULL ,
						last_name VARCHAR(35)  NOT NULL,
						email VARCHAR(35) NOT NULL,
						phone_number INT DEFAULT NULL,
						hire_date VARCHAR(35) NOT NULL,
						Job_id INT NOT NULL,
						salary INT NOT NULL, 
                        commision INT DEFAULT NULL,
						Dept_id  INT NOT NULL,
                        FOREIGN KEY (Dept_id) REFERENCES Departments(Dept_id),
						FOREIGN KEY (Job_id) REFERENCES Jobs(Job_id)            
                        )
                        
DESC Departments;
DESC Jobs;
DESC employees;

select * 
from recipes
where recipe_id in (
					(SELECT recipeingradients_id
					FROM recipeingradients 
					WHERE recipe_cooktime IN (SELECT *
											FROM (SELECT recipe_cooktime
											FROM recipeingradients
											GROUP BY recipe_cooktime
											HAVING COUNT(recipe_cooktime) > 1)
											AS a))
                                            );
                                            
                                            