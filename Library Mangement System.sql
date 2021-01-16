
Create database LMS;

use LMS;

--------------------------------------------Table Creation----------------------------------------------------- 
--- Create Address Table

create table Address_tbl ( L_ID int identity (1000 ,1) not null , Province varchar(20) default 'Punjab' not null , 
 City varchar (20) default 'Lahore' not null ,
 PostalCode int default 6200 , Area varchar(20) not null , StreetNumber varchar ( 10 ) ,
 BulidingNumber varchar (20) not null , UpdatedOn smalldatetime 
 constraint PK_address primary key (L_ID) 
 );


 ---------------------------------------------------------------------------------------------------------------------
 
 ---Create Employee Table
 create table Employees_tbl (
		E_Id varchar(10) not null , FirstName varchar (20) not null , LastName varchar (20) , 
		Salary int not null , Contact varchar (15) not null , Email varchar(max) not null , 
		Designation varchar(20) not null ,
		Gender varchar(20) default 'Male' ,
        AddressID int not null, 
		HireDate Date not null , DoB date ,
		 constraint PK_Employee_ID primary key (E_id) ,
		 constraint FK_Employee_Address foreign key (AddressID) references  Address_tbl(L_ID)
		 , check(E_id like ('[a-z][a-z][0-9][0-9][0-9]'))  , check(Salary >= 0)
		 );

-------------------------------------------------------------------------------------------------------------------------
---Create Member Table
 

 create table Member_tbl (
	     M_ID varchar(10) not null , FirstName varchar (20) not null , LastName varchar (20) , 
		 Contact varchar(15) not null , Email varchar(max) not null  ,
		 MemberShipIssuedDate Date not null default getdate() , MemberShipExpireDate Date
		  Default dateadd(year,1, getdate()) , DoB date , 
		 Gender varchar(20) default 'Male' , MemberStatus varchar(20) default 'Active', AddressID int not null,  
		 constraint PK_Member_ID primary key (M_ID) , check(M_ID like ('[a-z][a-z][0-9][0-9][0-9]'))
		 ,constraint FK_Memeber_Address foreign key (AddressID) references  Address_tbl(L_ID)
		 );
----------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------
---Create Publisher Table

create table Publisher_tbl (
		P_ID varchar (10) not null , PublisherName varchar (max) not Null , 
	    Contact varchar(15) not null ,
		Email varchar(max) not null , AddressID int not null,
		constraint PK_Publisher_ID primary key (P_id) , check(P_ID like ('[a-z][a-z][0-9][0-9][0-9]'))
		,constraint FK_Employee_location foreign key (AddressID) references  Address_tbl(L_ID)
);

------------------------------------------------------------------------------------------------------------------

---Create Book Table

create table Book_tbl (
		B_ID varchar (10) not null , Tittle varchar (max) not null ,
		ISBN numeric(13 , 0) unique not null  , Edition varchar (20) default '1st', 
		Author varchar( max ) ,Price int not null,TotalCopies int default 1 not null,
		AvailableCopies int default 1 not null, Publisher varchar(10) not null ,
		Category varchar(max) default 'Unknown' ,Section varchar(max)  not null,
		Shelf varchar(max) default 1, 
		Rack varchar (max) default 1,
		constraint PK_Book_ID primary key (B_ID) , check(B_ID like ('[a-z][a-z][0-9][0-9][0-9]')) ,
		constraint FK_Publisher foreign key (Publisher) references Publisher_tbl(P_ID ), 
		check(Publisher like ('[a-z][a-z][0-9][0-9][0-9]')),
		check(Price >=0) , check (AvailableCopies >=0) , check (TotalCopies >=0)
);

---------------------------------------------------------------------------------------------------------
--Create Issue info Table

create table IssuedInfo_tbl(
	Issue_ID int identity( 001 ,1) not null , Book varchar (10) not null ,
	Member varchar (10) not null , 
	Employee varchar (10) not null ,
	Status varchar(20) default 'Issued' ,
	IssuedDate date not null default getdate()  , IssuedTime time default CONVERT(TIME,GETDATE()) , RetuenDate  
	date Default dateadd(month,1, getdate()) 
	constraint PK_Issue_ID primary key (Issue_ID) ,
	constraint FK_Book_ID foreign key (Book) references  Book_tbl(B_ID),
	constraint FK_Member_ID foreign key (Member) references  Member_tbl(M_ID),
	constraint FK_Employee_ID foreign key (Employee) references  Employees_tbl(E_ID),
);

------------------------------------------------------------------------------------------------------------------

--Create paymnet table

 create table Payment_tbl( 
	P_ID int identity ( 001 ,1) not null ,
	Member_ID varchar(10) not null , Amount int default 0 , 
	Payment_Status varchar(max) default 'Pending' , Payment_Date date default getdate(),
	constraint PK_Payment primary key (P_ID),
	constraint FK_Member foreign key (Member_ID) references Member_tbl ( M_ID) , 
	check(Member_ID like ('[a-z][a-z][0-9][0-9][0-9]')))


 -----------------------------------------------------------------------------------------------

-----------------------------------------------PROCEDURES---------------------------------------------------------


------------------------------------------------Data Insertion Procedure-------------------------------------


-------------------------- Add Address of Employee /  Member-------------------------

create procedure Insert_Address 
@prov varchar(25),
@city varchar(20),
@Pstl int,
@Area varchar(max) ,
@street varchar(10),
@bn varchar(max)

as
begin

insert into Address_tbl ( 
			Province , City ,  PostalCode , Area ,
			StreetNumber , BulidingNumber , UpdatedOn) 
			
			values (
					 @prov , @city ,  @pstl , @Area  , @Street , @bn , CURRENT_TIMESTAMP )
End;
-----------------------------------------END ADD ADDRESS----------- ---------------------



----------------------------------------------- ADD NEW EMPLOYEE ------------------------------------------------------
Create procedure Add_Employee 
@id varchar(6) ,
@fname varchar(20) ,
@lname varchar(20) ,
@salary int   , 
@contact varchar(15) , 
@email varchar(max) ,
@design varchar(20),
@DOB date, 
@prov varchar(15),
@city varchar(30),
@Pstl int,
@Area varchar(max) ,
@street varchar(10),
@bn varchar(max)

as 
begin

declare @ad_id int;

execute Insert_Address @prov,@city,@Pstl ,@Area,@street,@bn ;

select @ad_id = max(L_id) from address_tbl; 


 insert into Employees_tbl (
	 E_Id ,  Firstname  ,LastName ,  Salary ,  Contact ,   Email  , Designation , 
	 AddressID , HireDate , DoB ) 
	values(
			@id , @fname  , @lname , @salary , @contact , @email , @design,
			 @ad_id , GETDATE() , @DOB
  )

  end;
----------------------------------------END ADD EMPLOYEE---------------------------------------------------------------



-----------------------------------ADD NEW MEMBER -------------------------------------------------------------------

create procedure Add_Member 
@id varchar(6) ,
@fname varchar(20 ) ,
@lname varchar(20) ,
@contact varchar(15) , 
@email varchar(max) ,
@DOB date,
@Gender varchar(20),
@prov varchar(15),
@city varchar(20),
@Pstl int,
@Area varchar(max) ,
@street varchar(10),
@bn varchar(max)

as

begin

declare @ad_id int;

execute Insert_Address @prov,@city,@Pstl ,@Area,@street,@bn ;

select @ad_id = max(L_id) from address_tbl; 

insert into Member_tbl (
	 M_ID ,  FirstName , LastName , Contact ,   Email  , MemberShipIssuedDate ,MemberShipExpireDate , 
	 DoB  , Gender  ,   AddressID) 
	 values(

		@id , @fname ,@lname , @contact , @email , GETDATE()
		 , dateadd(year,1 , getdate() ) , @DOB , @Gender , @ad_id ) ;
  
end;

-----------------------------------------------END ADD NEW MEMBER-------------------------------------------- 

---------------------------------------ADD NEW BOOK------------------------------------------------
create procedure Add_Book

@B_ID varchar (10) ,
@Tittle varchar (max),
@ISBN numeric(13 , 0) , 
@Edition varchar (20),
@Author varchar( max ) ,
@Price int ,
@TotalCopies int , 
@AvailableCopies int,
@Publisher varchar(10),
@Category varchar(max),
@Section varchar(max) ,
@Shelf varchar(max) , 
@Rack varchar (max) 

as 
begin

insert into Book_tbl (
		B_ID , Tittle , ISBN , Edition , Author , Price ,
		TotalCopies , AvailableCopies , Publisher , Category , Section , Shelf , Rack) 
		 values (
				@B_ID , @Tittle , @ISBN , @Edition , @Author , @Price ,
				@TotalCopies , @AvailableCopies , @Publisher , @Category ,
				 @Section , @Shelf , @Rack);

 end;
-----------------------------------END ADD NEW BOOK----------------------------------------



-------------------------------ADD NEW PUBLISHER -----------
Create procedure Add_Puslisher 
@id varchar(10) ,
@pname varchar(max ) ,
@contact varchar(15) , 
@email varchar(max) ,
@prov varchar(15),
@city varchar(30),
@Pstl int,
@Area varchar(max) ,
@street varchar(10),
@bn varchar(max)

as

begin

declare @ad_id int;

execute Insert_Address @prov,@city,@Pstl ,@Area,@street,@bn ;

select @ad_id = max(L_id) from address_tbl; 

insert into Publisher_tbl  ( 
			P_ID , PublisherName , Contact , email , AddressID)
			 values (
				 @id , @pname ,  @contact, @email , @ad_id )

end;

-----------------------------------------END ADD NEW PUBLISHER----------------------


-------------------------------- MAKE PAYMENT --------------------------------

create procedure  Member_Payment 
 @M_id varchar(10),
 @Amount int ,
 @p_Status varchar(max)

 as 
 begin

insert into payment_tbl( Member_ID  , Amount, 
 Payment_Status , Payment_Date ) values ( @M_id , @Amount , @p_status  , getdate())

end;

------------------------------------------------END MAKE PAYMENT--------------------------------

---------------------------------------------------------ISSUE A BOOK-----------------------------

Create Procedure Issue_Book
@Book varchar(10),
@Member varchar (10),
@Employee varchar(10)

as 

begin

declare 
@acopy int;
select @acopy = b.AvailableCopies from Book_tbl b where b.B_ID = @Book
if(@acopy<2 )

	begin

  print('No book is Availible For issue...!!!')
	
	end;

else
 
 begin

insert into  IssuedInfo_tbl 
			 ( Book , Member , Employee , IssuedDate , IssuedTime  , RetuenDate  )
	values 
			( @Book , @Member , @Employee , GETDATE()  ,
					CONVERT(TIME,GETDATE()),  DATEADD(MONTH , 1 , getdate()) );

set @acopy = @acopy-1
update Book_tbl 
		 set AvailableCopies = @acopy where B_ID = @Book
print('Book Successfully Issued...!!!')


end;

end;

------------------------------------------------------ISSUE A BOOK-----------------------------

---------------------------------------------DISPLAY PROCEDURES----------------------------------------

--------------------------------- Display Addresses ------------------------------------------------
create procedure Display_Address 
as 
begin

select *from Address_tbl

end;
-----------------------END DISPLAY ADDRESS-------------------------------
execute Employees_Details

---------------------DISPLAY EMPLOYEES DETAILS--------------------------------------
 create procedure Employees_Details 

 as 
 begin 

 Select 
		emp.E_Id as Employee_ID ,  emp.Firstname  , emp.LastName , 
		emp.Salary , emp.Contact ,   emp.Email , emp.Designation ,
		emp.Gender , emp.HireDate ,emp.DoB , Address_tbl.City as City ,
		Address_tbl.Area As Area , Address_tbl.StreetNumber,
		Address_tbl.BulidingNumber from Employees_tbl emp ,
		Address_tbl where emp.AddressID = Address_tbl.L_ID;
 
 end;

--------------------------------- END DISPLAY EMPLOYEE DETAILS----------------------------------------------------

-----------------------DISPLAY MEMBERS DETAILS------------------
 
create procedure Members_Details

as 

begin

SELECT * FROM Member_tbl INNER JOIN Address_tbl ON Member_tbl.AddressID = Address_tbl.L_ID

end;

---------------------------- END  DISPLAY MEMBERS DETAILS---------------------------------

-----------------------DISPLAY PUBLISHERS DETAILS------------------
 
create procedure Publishers_Details

as 

begin

SELECT * FROM Publisher_tbl INNER JOIN Address_tbl ON Publisher_tbl.AddressID = Address_tbl.L_ID

end;

---------------------------- END  DISPLAY PUBLISHER DETAILS---------------------------------

----------------------------- DISPLAY ISSUED BOOKS DETAILS
execute Issued_Details

create procedure Issued_Details

as 

begin

SELECT 
	  i.Issue_ID as Issue_ID , b.Tittle as Book_Tittle , b.Edition as Edition,
      b.Author , m.M_ID as Member_ID , m.FirstName as Member_Name ,  e.FirstName as Issued_By ,
	    i.Status as Status , i.IssuedDate , 
		i.RetuenDate  , b.Price 
         from IssuedInfo_tbl as i , Book_tbl as b , Member_tbl as m , Employees_tbl e 
                         where i.Book = b.B_ID and i.Member=m.M_ID and i.Employee=e.E_Id 

end;

---------------------------------------------END ISSUE DETAILS -----------------------
select *  from IssuedInfo_tbl
---------------------------------------REISSUE BOOK------------------------------------

create procedure Reissue_Book 
@issue_id int

as 
begin
 
  
 update IssuedInfo_tbl 
		 set RetuenDate = DATEADD(MONTH , 1 , getdate()) where  Issue_ID = @issue_id;

update IssuedInfo_tbl 
		 set Status = 'Reissued' where  Issue_ID = @issue_id;


print('Book Successfully ReIssued.....!!!');

-------calculate fine
declare 
@diff int;
select @diff = DATEDIFF(day , GETDATE() , (select tbl.RetuenDate from IssuedInfo_tbl tbl where  Issue_ID = @issue_id))

if(@diff>0)

begin

set @diff = @diff * 10 ;

declare @m_id varchar(max)

select @m_id= tbl.Member from IssuedInfo_tbl tbl where  Issue_ID = @issue_id

execute Member_Payment @m_id , @diff , 'Pending'

print('Fine Calculated');

end
----end calculate fine

end;

----------------------------END REISSUE BOOK--------------------------------

-----------------------------Search a book by name -------------------------------------


 Create Procedure Search_book
@name varchar(max)
as 
begin

 select 
		b.B_ID As Book_ID , b.Tittle , b.Edition , b.ISBN , b.Author ,
		 b.AvailableCopies , b.Section , b.Rack , b.Shelf 
		 from 
				Book_tbl as b where  b.Tittle like '%' + @name + '%' ;

 end;


----------------------------- End Search a book by name -------------------------------------
---------------------------------------Return BOOK------------------------------------

create procedure Return_Book 
@issue_id int

as 
begin
declare
@status varchar(max)
 
 select @status = tbl.Status from IssuedInfo_tbl tbl where  Issue_ID = @issue_id;

if(@status <> 'Returned')

begin

-------calculate fine
declare 
@diff int;
select @diff = DATEDIFF(day , GETDATE() , (select tbl.RetuenDate from IssuedInfo_tbl tbl where  Issue_ID = @issue_id))

if(@diff>0)

begin

set @diff = @diff * 10 ;

declare @m_id varchar(max)

select @m_id= tbl.Member from IssuedInfo_tbl tbl where  Issue_ID = @issue_id

execute Member_Payment @m_id , @diff , 'Pending'
print('Fine Calculated');

end
----end calculate fine

 update IssuedInfo_tbl 
		 set Status = 'Returned' where  Issue_ID = @issue_id;

 update IssuedInfo_tbl 
		 set RetuenDate = getdate() where  Issue_ID = @issue_id;
		 
declare 
@acopy int;

select @acopy = b.AvailableCopies from Book_tbl b where b.B_ID =
													      (select itbl.Book from IssuedInfo_tbl itbl where itbl.Issue_ID = @issue_id )

set @acopy = @acopy+1

update Book_tbl 
			 set AvailableCopies = @acopy where B_ID = 
												 (select itbl.Book from IssuedInfo_tbl itbl where itbl.Issue_ID = @issue_id )

print('Book Successfully Returned.....!!!');

end; 

else

begin

print('Book Already Returned.....!!!');

end;

end;
----------------------------END RETURNED BOOK--------------------------------

---------------------------Quries --------------------------

----display total number of issued to a specific person

 select i.Member ,  count(i.Member)  As Issued_Count  from IssuedInfo_tbl as i group by i.Member ;
  
-----


--------------------------------------------------------DATA INSERTION--------------------------------

------MEMBERS

execute Add_Member 'SP101' , 'Abdul' , 'Rehman' , '03346445716' , 'SP19-BCS-101@CUILAHORE.EDU.PK'
, '2000-07-07' , 'Punjab' , 'Lahore' , 56000 , 'Architect' , 'Block-F st4' ,'61'


execute Add_Member 'SP148' , 'zaighum' , 'Murtaza' , '03356757787' , 'SP19-BCS-148@CUILAHORE.EDU.PK'
, '2000-11-11' , 'Punjab' , 'Lahore' , 56000 , 'Muridka' , 'st34' ,'354'

execute Add_Member 'SP002' , 'Armughan' , 'Ahmed' , '03084540799' , 'SP19-BCS-002@CUILAHORE.EDU.PK'
, '2000-11-21' , 'Punjab' , 'Lahore' , 56000 , 'Tariq Gardens' , 'st-6' ,'97'

execute Add_Member 'SP089' , 'Muhammad' , 'Abuzar' , '0333589787' , 'SP19-BCS-089@CUILAHORE.EDU.PK'
, '2000-01-01' , 'Punjab' , 'Lahore' , 56000 , 'Datasab' , 'st54' ,'43'



---Employee

	execute Employees_Details

    execute Add_Employee 'EP565' , 'Uzair' , 'Sufian' , 25000 , '03335467231', 'Uzair@gmail.com' , 'Manager' , '2000-11-04' , 'Punjab' , 'Okara' , '4200' , 'Nazampura' , 'ST4' , '45'
   
    execute Add_Employee 'EP566' , 'Azam' , 'Iqbal' , 15000 , '0303545337', 'azam@gmail.com' , 'Assistant Manager' , '1990-02-04' , 'Punjab' , 'Gujranwala' , '42000' , 'Nazampura' , 'ST6' , '44'

    execute Add_Employee 'EP567' , 'Zaroon' , 'Sufian' , 25000 , '0333523236', 'Zaroon@gmail.com' , 'Attendant' , '1987-01-09' , 'Punjab' , 'Okara' , '5600' , 'Sharkpura' , 'ST34' , '456'

    execute Add_Employee 'EP568' , 'Ahsan' , 'Aslam' , 25000 , '0333546378', 'Ahsan@gmail.com' , 'Guard' , '1989-11-11' , 'Punjab' , 'Shaiwal' , '42000' , 'Chungi' , 'ST11' , '345'

	execute Add_Employee 'EP569' , 'Faiq' , 'Iqbal' ,100000 , '0300546651', 'faiq@gmail.com' , 'DataBase Manager' , '1997-10-14' , 'Punjab' , 'Bahawalnagar' , '2300' , 'Nazmabad' , 'ST66' , '675'



 ---Publisher
   execute Publishers_Details

   execute Add_Puslisher  'PB002' , 'Faisal Book Depot' ,  '056777790', 'FaisalBookDepot@info' , 'Sindh' , 'karachi' , '7200' , 'North Karachi' , 'st33' , '345'

   execute Add_Puslisher  'PB006' , 'Urdu Book Depot' ,  '05687790', 'UrduBookDepot@info' , 'Sindh' , 'karachi' , '7200' , 'Each Karachi' , 'st33' , '365'
  
   execute Add_Puslisher  'PB003' , 'Haris Book Depot' ,  '05670990', 'HarisBookDepot@info' , 'Sindh' , 'karachi' , '7200' , 'South Karachi' , 'st33' , '335'	

   execute Add_Puslisher  'PB004' , 'Nazam Book Depot' ,  '05670990', 'NazamBookDepot@info' , 'Punjab' , 'Gujranwala' , '4900' , 'Model Town' , 'St3' , '102'

   execute Add_Puslisher  'PB005' , 'Model Book Depot' , '05681111', 'ModelBookDepot@info' , 'Punjab' , 'Gujranwala' , '4900' , 'Model Town' , 'St47' , '65'
   
   execute Add_Puslisher  'PB007' , 'Model Book Depot' , '042011191', 'ModelBookDepot@info' , 'Punjab' , 'Lahore' , '5600' , 'Faisal Town' , 'St15' , 'B-99'

----Books
select *  from Book_tbl

execute Add_Book  'BK002' , 'Database Systems: The Complete Book' , 9780144319951 , '1st' 
 , 'Héctor García-Molina, Jeffrey Ullman, and Jennifer Widom' , 8500 , 10 , 8 , 'PB002' 
 , 'DataBase' , 'CS' , '9' , '24'

 execute Add_Book  'BK004' , 'Data Structure : The Comple Book' , 1230144319951 , '9th' 
 , 'Héctor, Jeffrey Ullman' , 900 , 38 , 38 , 'PB003' 
 , 'DSA' , 'CS' , '15' , '25'

  execute Add_Book  'BK005' , 'Data Structure : The Comple Book' , 5230144312399 , '11th' 
 , 'Héctor, Jeffrey Ullman' , 900 , 38 , 38 , 'PB003' 
 , 'DSA' , 'CS' , '15' , '25'

----Payment 

execute Member_Payment 'SP101' , 60 , "Pending" 

execute Employees_Details


--Insert Address IN Address Table

 select * from Address_tbl

 insert into Address_tbl ( 
		Province , City ,  PostalCode , Area ,
			StreetNumber , BulidingNumber , UpdatedOn) 
			values (
					 'Punjab' , 'Lahore' ,  62300 , 'PCSIR'  , 'St4' , '4' , CURRENT_TIMESTAMP )
 insert into Address_tbl ( 
		Province , City ,  PostalCode , Area ,
			StreetNumber , BulidingNumber , UpdatedOn) 
			values (
					 'Punjab' , 'BahawalNagar' ,  62300 , 'Baldiya Road'  , '6' , '45' , CURRENT_TIMESTAMP )

insert into Address_tbl ( 
		Province , City ,  PostalCode , Area ,
			StreetNumber , BulidingNumber , UpdatedOn) 
			values (
					 'Punjab' , 'Lahore' ,  5400, 'Johar Town'  , 'F7' , '8' , CURRENT_TIMESTAMP )  

insert into Address_tbl ( 
		Province , City ,  PostalCode , Area ,
			 BulidingNumber , UpdatedOn) 
			values (
					 'Sindh' , 'Karachi' ,  5400, 'NORTH NAZIMABAD'   , '356' , CURRENT_TIMESTAMP ) 


-- insert member table

insert into Member_tbl (
  M_Id ,  FirstName , LastName , Contact ,   Email  , MemberShipIssuedDate ,MemberShipExpireDate , 
    DoB  , Gender  ,   AddressID) values
  (
  'Em192' , 'Ayiza' , 'Asghar' , '03346342178' , 'SP19-BCS-080@CUILAHORE.EDU.PK' , GETDATE()
   ,'2021-12-22' , '2000-05-25' , 'Female' , 1005 );

   insert into Member_tbl (
  M_Id ,  FirstName , LastName , Contact ,   Email  , MemberShipIssuedDate ,MemberShipExpireDate , 
    DoB  , Gender  ,   AddressID) values
  (
  'EM193' , 'Fabiha' , 'Anjum' , '03006343134' , 'SP19-BCS-074@CUILAHORE.EDU.PK' , GETDATE()
   ,'2021-12-22' , '2000-05-25' , 'Female' , 1007 );

    --- Insert Employee Table

  select * from Employees_tbl

  insert into Employees_tbl (
  E_Id ,  FirstName , LastName ,  Salary ,  Contact ,   Email  , Designation , 
  AddressID , HireDate , DoB ) values
  (
  'EM001' , 'Taha' , 'Naveed' , 15000 , '0300231716' , 'Tahanaveed@gmail.com' , 'Security Guard'  ,
   1006 , GETDATE() , '1985-02-04'
  );

  -- Insert Book Table 
  insert into Book_tbl (B_ID , Tittle , ISBN , Edition , Author , Price ,
 TotalCopies , AvailableCopies , Publisher , Category , Section , Shelf , Rack
 )  values (
 'BK001' , 'Database Systems: The Complete Book' , 9780130319951 , '4th' 
 , 'Héctor García-Molina, Jeffrey Ullman, and Jennifer Widom' , 8500 , 10 , 8 , 'PB001' 
 , 'DataBase' , 'CS' , '9' , '24'
);

select * from Book_tbl;

select * from Publisher_tbl
--insert into Publisher Table
insert into Publisher_tbl  ( 
			P_ID , PublisherName , Contact , email , AddressID) values 
			( 'PB001' , 'Umer Book Depot' ,  '0632277990', 'UmerBookDepot@info' , 1008 )

-- insert issue info
insert into  IssuedInfo_tbl  ( Book , Member , Employee , IssuedDate , IssuedTime  , RetuenDate  )
values 
( 'BK001' , 'SP101' , 'EM001' , GETDATE()  ,
    CONVERT(TIME,GETDATE()), '2021-01-22'    )
--insert into member table
	insert into Member_tbl (
  M_ID ,  FirstName , LastName , Contact ,   Email  , MemberShipIssuedDate ,MemberShipExpireDate , 
    DoB  , Gender  ,   AddressID) values
  (
  'SP101' , 'Haris' , 'Rehman' , '03346445777' , 'SP19-BCS-101@CUILAHORE.EDU.PK' , GETDATE()
   ,'2021-12-22' , '2000-07-19' , 'Male' , 1001 );


------ Query to Add an Employee

select * from Address_tbl

 insert into Address_tbl ( 
		Province , City ,  PostalCode , Area ,
			StreetNumber , BulidingNumber , UpdatedOn) 
			values (
					 'Punjab' , 'Lahore' ,  62300 , 'PCSIR'  , 'St4' , '4' , CURRENT_TIMESTAMP )

  select * from Employees_tbl

  insert into Employees_tbl (
  E_Id ,  FirstName , LastName ,  Salary ,  Contact ,   Email  , Designation , 
  AddressID , HireDate , DoB ) values
  (
  'EM001' , 'Abdul' , 'Rehman' , 300000 , '03346445716' , 'AR@gmail.com' , 'Manager'  ,
   1000 , GETDATE() , '2000-07-07'
  );

---------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------
-- Query to Add a Member

select * from Address_tbl
 insert into Address_tbl ( 
		Province , City ,  PostalCode , Area ,
			StreetNumber , BulidingNumber , UpdatedOn) 
			values (
					 'Punjab' , 'Lahore' ,  62300 , 'PCSIR'  , 'St4' , '4' , CURRENT_TIMESTAMP )

insert into Member_tbl (
  M_ID ,  FirstName , LastName , Contact ,   Email  , MemberShipIssuedDate ,MemberShipExpireDate , 
    DoB  , Gender  ,   AddressID) values
  (
  'SP101' , 'Haris' , 'Rehman' , '03346445777' , 'SP19-BCS-101@CUILAHORE.EDU.PK' , GETDATE()
   ,'2021-12-22' , '2000-07-19' , 'Male' , 1001 );



---------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------
-- Query to Add an Publisher 

select * from Address_tbl
 insert into Address_tbl ( 
		Province , City ,  PostalCode , Area ,
			StreetNumber , BulidingNumber , UpdatedOn) 
			values (
					 'Punjab' , 'Lahore' ,  62300 , 'PCSIR'  , 'St4' , '4' , CURRENT_TIMESTAMP )


--insert into Publisher Table
insert into Publisher_tbl  ( 
			P_ID , PublisherName , Contact , email , AddressID) values 
			( 'PB001' , 'Umer Book Depot' ,  '0632277990', 'UmerBookDepot@info' , 1004 )
---------------------------------------------------------------------------------------------------------------------


