# query_formulator

***How to set the system***

-Download XAMPP (https://www.apachefriends.org/index.html)  
-Next dl the project files(all except the tests) and paste them
in the XAMPP htdocs folder.  
-Start Apache web server and mysql from XAMPP app.  
-In the sql server create a database named "ccc" that will be used
for the testing of this project and initialise it with a few entries.  
-Open a new browser tab and type "127.0.0.1/index.html".  
This should open the following screen.  
https://github.com/EmmTzanakis/query_formulator/blob/master/main_menu.png  
-Fill the bracket with the query in natural language to see how it will
be formulated in sql by programm and then will run on the database 
you previously created.  

***How this system works***

  This system is able to translate (compile) "simple(syntax-wise) selective queries" 
made in natural language into sql queries and run them into a pre-set DB.
More specifically the query must refer to single attributes from one table.
For example queries like the following one are to complex for this system and
won't be addressed.  
 “Return the expiration date of the client account who took part in the transaction
with the highest sum.”  
Thus use of this system will also require basic knowledge of the DB schema.


-However the system is able to answer conditional selection questions
that contain quantifiers and operators.  
eg "Return all employees with cid CompanyID"  
 "Show all the merchants with credit greater than 10000"

-Entity references andattributes must be made using strictly 
the reference names them as they are in the shape of the base.  
Figure 1: Interface
16  
 eg "Return all employees of the company CompID"  
In this example the system will not be able to recognize that word
"Company" refers to the cid attribute of the entity "Employee".

-The system can also make use of the min, max, count and average functions.
We can access them through the key-words min, max, count and avg
respectively.   
eg "Return the avg sum of the Transactions with clientname Rob"

Below is a more detailed demonstration of the syntactic requirements that 
have to be followed by the user.

We begin the question with a word corresponding to "select" from
the following list: show, return, retrieve, get.

Then the name of the entity's attribute should be entered
which will be the object of choice. If we wish to
declare quantity the corresponding quotient should be declared
at this point before the feature.  
If all is done properly a screen like tha following one should dispaly the results  
https://github.com/EmmTzanakis/query_formulator/blob/master/Query_result.png
