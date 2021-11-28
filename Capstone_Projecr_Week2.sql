use recipe;DROP TABLE IF EXISTS Ingradients;
DROP TABLE IF EXISTS Pictures;
DROP TABLE IF EXISTS RecipeIngradients ;
DROP TABLE IF EXISTS Recipes;

CREATE TABLE Recipes (
  recipe_id int NOT NULL,
  recipe_name varchar(50) NOT NULL,
  recipe_price int NOT NULL,
  order_level varchar(50) default null,
  recipe_createdby varchar(50) DEFAULT NULL,
  PRIMARY KEY (recipe_id)
) ;
CREATE TABLE Ingradients (
  ingradients_id int  not null,
  ingradients_name varchar(50) default nulL,
  ingradients_createdby varchar(50) DEFAULT NULL,
  ingradients_amount varchar(50) NOT NULL,
  PRIMARY KEY (ingradients_id),
  foreign key(ingradients_id) references recipes(recipe_id)
) ;
CREATE TABLE RecipeIngradients (
  recipeingradients_id int NOT NULL,
  recipe_info varchar(50) default  NULL,
  calories int default null,
  recipe_cooktime varchar(10) default null,
  PRIMARY KEY (recipeingradients_id),
  foreign key(recipeingradients_id) references recipes(recipe_id)
) ;
CREATE TABLE Pictures(
  picture_id int NOT NULL,
  picture_createdby varchar(50) default  NULL,
  recipe_picture blob default null,
  PRIMARY KEY (picture_id ),
  foreign key(picture_id) references recipes(recipe_id)
) ;
desc Recipes;
desc ingradients;
desc recipeingradients;
desc pictures;

#------------------------------------ 1. Insert data sets ---------------------------------
insert  into Recipes(recipe_id ,recipe_name,   recipe_price ,order_level, recipe_createdby) values 
(101,    'Checken Rice',    5000,     	'Urgent',     'Mariyam'),
(102,    'Mutton Korma',  	2000,     	'Urgent',      'Moona'),
(103,    'Behari Kabab',   	5000,      	 NULL ,       'Mariyam'),
(104,    'Melai Boti',      1000,   	'Normal',     'Arbab'),
(105,    'White Chicken',   1000,   	'Urgent',     'Mariyam');

insert  into Ingradients(ingradients_id,ingradients_name,ingradients_createdby,ingradients_amount ) values 
(101,    'rice_water_sauce',     NULL, 		'1 Kg'),
(102,    'meat_water_sauce',    'Moona', 	'Half Kg'),
(103,    'meat_sauce',     ' 	Mariyam', 	'1 Kg'),
(104,    'chicken_sauce',     	'Arbab', 	'1Kg'),
(105,     null ,     			'Mariyam', 	'Half Kg');

insert  into RecipeIngradients(recipeingradients_id, recipe_info, calories,recipe_cooktime) values 
(101,   'Pakistani dish', 	500 , 	'40minutes'),
(102,   'Indian',    		1000,	'20minutes'),
(103,    null,     			2000,	'40minutes'),
(104,    'Italian',    		null,	'30minutes'),
(105,    'Turkish' ,     	1500,	'60minutes');

insert  into Pictures(picture_id,recipe_picture, picture_createdby) values 
(101, 	0001, 'john'),
(102,  	0010,  'Ola'),
(103,   0011,	null),
(104,   null,	'zig zig'),
(105,   0101,	'maeve');

#---------------------------- Tables exploration -----------------------------
select *
from recipes;

select *
from recipeingradients;

select *
from recipeingradients;

select *
from ingradients;

select *
from pictures;

#--------------------------------------2. Select Ingradients for a recipe-------------------------------
select *
from RecipeIngradients
where recipeingradients_id =(Select recipe_id as id
							from recipes
							where recipe_name  like '%Rice');
                            
#--------------------------------3. Select cooktime for a particular recipe---------------------------
select recipe_cooktime
from RecipeIngradients
where recipeingradients_id =(Select recipe_id as id
							from recipes
							where recipe_name  like '%Rice');

#----------------------------4. Make an update to cooktime of particular recipe-----------------------------
# First of all check the id number of particular recipe
# below im selecting recipe_id for any recipe which is including Rice 


#Before update
SELECT *
FROM RecipeIngradients;

#Updating cooktime for particular recipe which has been selected above
Update RecipeIngradients
set recipe_cooktime = '50min'
where recipeIngradients_id = (SELECT recipe_id
								FROM recipes 
								where recipe_name like '%Rice');

#After update
SELECT *
FROM RecipeIngradients;

#----------------------------5. Query that take less than 1 hour cooktime-----------------------------
select recipe_name
from recipes
where recipe_id = (SELECT recipeingradients_id
					FROM recipeingradients
					where recipe_cooktime like '60%');

#--------------------------------------6. Average time-----------------------------------------------
select avg(recipe_cooktime)  as Average_Time
from recipeingradients;
#----------------------------7. Recipe Ingradients and picture-----------------------------
select *
from recipeingradients
where recipeingradients_id = (SELECT recipe_id
								FROM recipes
								where recipe_name regexp 'Boti$');

select recipe_picture as Picture
from Pictures
where picture_id = (SELECT recipe_id
					FROM recipes
					where recipe_name like '%Boti');

#----------------------------8. Return those Recipe's name and cook time which has greater cooktime of Rice-----------------------------

select recipe_name 
from Recipes
where recipe_id in (Select recipeingradients_id
							from recipeingradients
							where recipe_cooktime > (select recipe_cooktime
													from RecipeIngradients
													where recipeingradients_id =(Select recipe_id as id
																				from recipes
																				where recipe_name  like '%Rice')));

select recipe_cooktime 
from recipeingradients
where recipe_cooktime >  (select recipe_cooktime
							from RecipeIngradients
							where recipeingradients_id =(Select recipe_id as id
														from recipes
														where recipe_name  like '%Rice'));


#----------------------------9.Recipe name that have picture-----------------------------
select recipe_name
from recipes
where recipe_id in ( select picture_id 
					from pictures
                    where recipe_picture is not null);
                    
#----------------------------10.Recipe having same cooktime-----------------------------
#check how many rows having same cooktime in recipeingradients table
SELECT *
FROM recipeingradients 
WHERE recipe_cooktime IN (SELECT *
							FROM (SELECT recipe_cooktime
									FROM recipeingradients
									GROUP BY recipe_cooktime
									HAVING COUNT(recipe_cooktime) > 1)
									AS a);
#recipe name having same cook time
select recipe_name as Recipe from recipes
where recipe_id in (
					(SELECT recipeingradients_id
					FROM recipeingradients 
					WHERE recipe_cooktime IN (SELECT *
											FROM (SELECT recipe_cooktime
											FROM recipeingradients
											GROUP BY recipe_cooktime
											HAVING COUNT(recipe_cooktime) > 1)
											AS a)));