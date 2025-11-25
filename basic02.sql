--Student ID 67040249133
--Student Name Kwansiri Suwannatrai

-- *********แบบฝึกหัด Basic Query #2 ***************
 
 --1. จงแสดงรหัสสินค้า ชื่อสินค้า ราคาต่อหน่วย เฉพาะสินค้าประเภท Seafood
 --แบบ Product  
 select ProductID, ProductName, UnitPrice
 from Products
    where CategoryID = 8;
 
--แบบ Join
select P.ProductID, P.ProductName, P.UnitPrice
from Products P 
join Categories C ON P.CategoryID = C.CategoryID
where C.CategoryName = 'Seafood';
---------------------------------------------------------------------
--2.จงแสดงชื่อบริษัทลูกค้า ประเทศที่ลูกค้าอยู่ และจำนวนใบสั่งซื้อที่ลูกค้านั้น ๆ ที่รายการสั่งซื้อในปี 1997
--แบบ Product
select CompanyName, Country, COUNT(OrderID) AS 'จำนวนใบสั่งซื้อ'
from Customers AS Cu ,orders AS O 
where Cu.CustomerID = O.CustomerID AND year(O.OrderDate) = 1997
GROUP by CompanyName,Country;
--แบบ Join
select CompanyName, Country, COUNT(O.OrderID) AS 'จำนวนใบสั่งซื้อ'
from Customers AS Cu INNER JOIN orders AS O
on Cu.CustomerID = O.CustomerID
where YEAR(OrderDate) = 1997
Group by CompanyName,Country

---------------------------------------------------------------------
--3. จงแสดงรหัสสินค้า ชื่อสินค้า ราคาต่อหน่วย ชื่อบริษัทและประเทศที่จัดจำหน่ายสินค้านั้น ๆ
--แบบ Product
select ProductID, ProductName,UnitPrice,CompanyName 
from Products As P,Suppliers As S
where P.SupplierID = S.SupplierID
--แบบ Join
select ProductID,ProductName,UnitPrice,CompanyName 
from Products As P Join Suppliers As S
On P.SupplierID = S.SupplierID

---------------------------------------------------------------------
--4. ชื่อ-นามสกุลของพนักงานขาย ตำแหน่งงาน และจำนวนใบสั่งซื้อที่แต่ละคนเป็นผู้ทำรายการขาย 
--เฉพาะที่ทำรายการขายช่วงเดือนมกราคม-เมษายน ปี 1997 และแสดงเฉพาะพนักงานที่ทำรายการขายมากกว่า 10 ใบสั่งซื้อ 
--แบบ Product
select FirstName+space(3)+LastName AS EmployeeName,Title,
count(orderID) As  numOrders
from Employees As E,Orders As O 
where  E.EmployeeID = O.EmployeeID
and OrderDate Between '1997-01-01' and '1997-04-30'
group by FirstName,LastName,Title
Having Count(OrderID)> 10;

--แบบ Join
select FirstName+space(3)+LastName As EmployeeName,Title,
count(OrderID) As numOrders
from Employees As E INNER JOIN Orders AS O on E.EmployeeID  = O.EmployeeID
where OrderDate between '1997-01-01' and '1997-04-30'
group by FirstName,LastName,Title
Having Count(OrderID)> 10;
---------------------------------------------------------------------
--5.จงแสดงรหัสสินค้า ชื่อสินค้า ยอดขายรวม(ไม่คิดส่วนลด) ของสินค้าแต่ละชนิด
--แบบ Product
select P.ProductID ,ProductName, sum(OD.UnitPrice* Quantity)As SumPrice
from [Order Details] As OD ,Products As P
where OD.ProductID = P.ProductID
group by P.ProductID,ProductName
Order by ProductID ASC;
--แบบ Join
select P.ProductID ,ProductName, sum(OD.UnitPrice* Quantity)As SumPrice
 from [Order Details] AS OD  INNER JOIN Products As P 
on OD.ProductID = P.ProductID
GROUP BY P.ProductID , P.ProductName
ORDER BY ProductID ASC;
---------------------------------------------------------------------
/*6.จงแสดงรหัสบริษัทจัดส่ง ชื่อบริษัทจัดส่ง จำนวนใบสั่งซื้อที่จัดส่งไปยังประเทศสหรัฐอเมริกา, 
อิตาลี, สหราชอาณาจักร, แคนาดา ในเดือนมกราคม-สิงหาคม ปี 1997 */
--แบบ Product
select ShipperID,CompanyName,Count(OrderID)AS NumShipoedOrder
from Orders As O , Shippers AS S
where o.ShipVia = S.shipperID
        and ShipCountry In ('USA','Italy','UK','Cannada')
        and ShippedDate  BETWEEN '1997-01-01' and '1997-08-31'
GROUP BY ShipperID,CompanyName 
--แบบ Join
select ShipperID ,CompanyName,count(OrderID) OrderCount
from Orders O JOIN Shippers S
on ShipCountry In ('USA','Italy','UK','Cannada')
    and ShippedDate  BETWEEN '1997-01-01' and '1997-08-31'
    GROUP BY ShipperID,CompanyName 
---------------------------------------------------------------------
-- *** 3 ตาราง ****
/*7 : จงแสดงเลขเดือน ยอดสั่งซื้อรวม(ไม่คิดส่วนลด) เฉพาะรายการสั่งซื้อที่ทำรายการขายในปี 1996 
และจัดส่งไปยังประเทศสหราชอาณาจักร,เบลเยี่ยม, โปรตุเกส ของพนักงานขายชื่อ Nancy Davolio */
--แบบ Product
select MONTH(OrderDate) As MONTH_NO , Sum(UnitPrice* Quantity)As SumPrice
from Orders As O , [Order Details] As OD,Employees As E
where O.OrderID = OD.OrderID and O.EmployeeID = E.EmployeeID
    And year(OrderDate) =1996
    And ShipCountry In ('UK','Belgium','Portugal')
    And FirstName = 'Nancy' and LastName = 'Davolio' 
group by MONTH(OrderDate)
--แบบ Join
select MONTH(OrderDate) As MONTH_NO , Sum(UnitPrice* Quantity)As SumPrice
from Orders As O INNER JOIN [Order Details] As OD On O.OrderID = OD.OrderID
                 INNER JOIN Employees As E on O.EmployeeID = E.EmployeeID
GROUP BY MONTH(OrderDate)

--------------------------------------------------------------------------------

/*8 : จงแสดงข้อมูลรหัสลูกค้า ชื่อบริษัทลูกค้า และยอดรวม(ไม่คิดส่วนลด) เฉพาะใบสั่งซื้อที่ทำรายการสั่งซื้อในเดือน มค. ปี 1997 
จัดเรียงข้อมูลตามยอดสั่งซื้อมากไปหาน้อย*/
--แบบ Product
select C.CustomerID,CompanyName,Sum(UnitPrice*Quantity)As SumPrice
 from [Order Details] AS OD,Orders As O,Customers As C
 where OD.OrderID = O.OrderID and O.CustomerID = C.CustomerID
        and OrderDate between '1997-01-01'and '1997-01-31'
GROUP BY C. CustomerID,CompanyName
Order By SumPrice DESC

--แบบ Join
select C.CustomerID,CompanyName,Sum(UnitPrice*Quantity)As SumPrice
 from [Order Details] AS OD INNER JOIN Orders As O on OD.OrderID = O.OrderID 
                            INNER JOIN Customers As C on O.CustomerID = C.CustomerID
 where OrderDate between '1997-01-01'and '1997-01-31'
 GROUP BY C. CustomerID,CompanyName
Order By SumPrice DESC
---------------------------------------------------------------------------------

/*9 : จงแสดงรหัสผู้จัดส่ง ชื่อบริษัทผู้จัดส่ง ยอดรวมค่าจัดส่ง เฉพาะรายการสั่งซื้อที่ Nancy Davolio เป็นผู้ทำรายการขาย*/
--แบบ Product
select ShipperID,CompanyName,Sum(Freight)As Sum_Freight
from  Employees As E,  Orders As O , Shippers S
where E.EmployeeID = O.EmployeeID and O.ShipVia = S.ShipperID
        And FirstName = 'Nancy' And LastName = 'Davolio'
GROUP BY ShipperID , CompanyName

--แบบ Join
select ShipperID,CompanyName,Sum(Freight)As Sum_Freight
from  Employees As E INNER JOIN Orders As O on E.EmployeeID = O.EmployeeID
                     INNER JOIN Shippers As S  On O.ShipVia = S.ShipperID
where  FirstName = 'Nancy' And LastName = 'Davolio'
GROUP BY ShipperID , CompanyName

---------------------------------------------------------------------------------
/*10 : จงแสดงข้อมูลรหัสใบสั่งซื้อ วันที่สั่งซื้อ ลูกค้าที่สั่งซื้อ ประเทศที่จัดส่ง จำนวนที่สั่งซื้อทั้งหมด ของสินค้าชื่อ Tofu ในช่วงปี 1997*/
--แบบ Product
select O.OrderID,OrderDate,CompanyName,ShipCountry,Quantity
from Products As P, Orders As O , [Order Details] As OD ,Customers AS C
where P.ProductID = OD.ProductID 
    and OD.OrderID = O.OrderID 
    and O.CustomerID = C.CustomerID
    And ProductName = 'Tofu' And Year(OrderDate) =1997
ORDER BY O.OrderID ASC

--แบบ Join
select O.OrderID,OrderDate,CompanyName,ShipCountry,Quantity
from Orders As O INNER JOIN [Order Details] As OD On O.OrderID = OD.OrderID
                 INNER JOIN Products AS P On OD.ProductID = P.ProductID
                 INNER JOIN Customers AS C On O.CustomerID = C.CustomerID
where  ProductName = 'Tofu' And Year(OrderDate) =1997
ORDER BY O.OrderID ASC
-----------------------------------------------------------------------------
/*11 : จงแสดงข้อมูลรหัสสินค้า ชื่อสินค้า ยอดขายรวม(ไม่คิดส่วนลด) ของสินค้าแต่ละรายการเฉพาะที่มีการสั่งซื้อในเดือน มค.-สค. ปี 1997*/
--แบบ Product
select P.ProductID,ProductName,Sum(OD.UnitPrice * Quantity)AS SumPrice
From Products AS P ,[Order Details] As OD ,Orders As O
where P.ProductID = OD.ProductID 
    and OD.OrderID = O.OrderID
    And OrderDate between '1997-01-01' and '1997-08-31'
GROUP BY P.ProductID,ProductName

--แบบ Join
select P.ProductID,ProductName,Sum(OD.UnitPrice * Quantity)AS SumPrice
From Products AS P INNER JOIN [Order Details] As OD On P.ProductID = OD.ProductID
                    INNER JOIN Orders As O On OD.OrderID = O.OrderID
where OrderDate between '1997-01-01' and '1997-08-31'
GROUP BY P.ProductID,ProductName

-----------------------------------------------------------------------------
-- *** 4 ตาราง ****
/*12 : จงแสดงข้อมูลรหัสประเภทสินค้า ชื่อประเภทสินค้า ยอดสั่งซื้อรวม(ไม่คิดส่วนลด) เฉพาะที่มีการจัดส่งไปประเทศสหรัฐอเมริกา ในปี 1997*/
--แบบ Product
select C.CategoryID, CategoryName
From Categories As C ,Products As P ,[Order Details] As OD, Orders As O
where C.CategoryID = P.CategoryID And P.ProductID = OD.ProductID 
        And OD.OrderID = O.OrderID
        And O.ShipCountry = 'USA'
--แบบ Join
select  C.CategoryID, CategoryName
From Categories As C INNER JOIN  Products As P On C.CategoryID = P.CategoryID
                     INNER JOIN [Order Details] As OD On P.ProductID = OD.ProductID
                     INNER JOIN Orders AS O On OD.OrderID = O.OrderID
where ShipCountry = 'USA' And YEAR(ShippedDate) = '1997' 

                     ----------------------------------------------------------------------------
/*13 : จงแสดงรหัสพนักงาน ชื่อและนามสกุล(แสดงในคอลัมน์เดียวกัน) ยอดขายรวมของพนักงานแต่ละคน เฉพาะรายการขายที่จัดส่งโดยบริษัท Speedy Express 
ไปยังประเทศสหรัฐอเมริกา และทำการสั่งซื้อในปี 1997 */
--แบบ Product
select  E.EmployeeID,FirstName+''+LastName As EmployeeName ,
            Sum(UnitPrice*Quantity)AS SaleVolum
 from Employees AS E ,Orders As O ,Shippers As S, [Order Details] As OD
where E.EmployeeID = O.EmployeeID 
     And O.ShipVia = S.ShipperID
     And O.OrderID = OD.OrderID 
     And CompanyName = 'Speedy Express'And ShipCountry = 'USA'  
                    and YEAR(OrderDate) = 1997
GROUP BY E.EmployeeID, FirstName,LastName;
--แบบ Join
select E.EmployeeID,FirstName+''+LastName As EmployeeName ,
            Sum(UnitPrice*Quantity)AS SaleVolum
From Employees AS E INNER JOIN  Orders AS O On E.EmployeeID= O.EmployeeID
                    INNER JOIN Shippers AS S On O.ShipVia = S.ShipperID
                    INNER JOIN [Order Details] AS OD On O.OrderID= OD.OrderID
where CompanyName = 'Speedy Express'And ShipCountry = 'USA'  
                        and YEAR(OrderDate) = 1997
GROUP BY E.EmployeeID, FirstName,LastName;

--------------------------------------------------------------------------
/*14 : จงแสดงรหัสสินค้า ชื่อสินค้า ยอดขายรวม เฉพาะสินค้าที่นำมาจัดจำหน่ายจากประเทศญี่ปุ่น และมีการสั่งซื้อในปี 1997 และจัดส่งไปยังประเทศสหรัฐอเมริกา */
--แบบ Product
select P.ProductID,ProductName,Sum(OD.UnitPrice * Quantity)AS totalVume
From Products AS P ,Suppliers AS S ,[Order Details] As OD ,Orders As O
where P.SupplierID = S.SupplierID 
    and P.ProductID = OD.ProductID 
    and OD.OrderID = O.OrderID
    And S.Country = 'Japan' 
    And YEAR(OrderDate) = 1997
    And O.ShipCountry = 'USA'
GROUP BY P.ProductID,ProductName

--แบบ Join
select P.ProductID,ProductName,Sum(OD.UnitPrice * Quantity)AS totalVume 
From Products AS P INNER JOIN Suppliers AS S On P.SupplierID = S.SupplierID
                    INNER JOIN [Order Details] As OD On P.ProductID = OD.ProductID 
                    INNER JOIN Orders As O On OD.OrderID = O.OrderID
where S.Country = 'Japan' 
    And YEAR(OrderDate) = 1997
    And O.ShipCountry = 'USA'
----------------------------------------------------------------------------
-- *** 5 ตาราง ***
/*15 : จงแสดงรหัสลูกค้า ชื่อบริษัทลูกค้า ยอดสั่งซื้อรวมของการสั่งซื้อสินค้าประเภท Beverages ของลูกค้าแต่ละบริษัท  และสั่งซื้อในปี 1997 จัดเรียงตามยอดสั่งซื้อจากมากไปหาน้อย*/
--แบบ Product
select C.CustomerID,CompanyName,Sum(OD.UnitPrice * Quantity)AS totalVume
From Customers AS C ,Orders As O , [Order Details] As OD
    ,Products AS P ,Categories AS Ca
where C.CustomerID = O.CustomerID 
    and O.OrderID = OD.OrderID
    and OD.ProductID = P.ProductID
    and P.CategoryID = Ca.CategoryID
    And Ca.CategoryName = 'Beverages'
    And YEAR(OrderDate) = 1997
GROUP BY C.CustomerID, CompanyName
ORDER BY totalVume DESC

--แบบ Join
select C.CustomerID,CompanyName,Sum(OD.UnitPrice * Quantity)AS totalVume
From Customers AS C INNER JOIN Orders As O On C.CustomerID = O.CustomerID
                    INNER JOIN [Order Details] As OD On O.OrderID = OD.OrderID
                    INNER JOIN Products AS P On OD.ProductID = P.ProductID
                    INNER JOIN Categories AS Ca On P.CategoryID = Ca.CategoryID
where Ca.CategoryName = 'Beverages' And YEAR(OrderDate) = 1997
GROUP BY C.CustomerID, CompanyName
ORDER BY totalVume DESC

---------------------------------------------------------------------------
/*16 : จงแสดงรหัสผู้จัดส่ง ชื่อบริษัทที่จัดส่ง จำนวนใบสั่งซื้อที่จัดส่งสินค้าประเภท Seafood ไปยังประเทศสหรัฐอเมริกา ในปี 1997 */
--แบบ Product
select S.ShipperID,CompanyName,Count(O.OrderID)AS NumShipoedOrder
from Shippers AS S , Orders As O , [Order Details] As OD
    , Products AS P , Categories AS C
where S.ShipperID = O.ShipVia 
    and O.OrderID = OD.OrderID
    and OD.ProductID = P.ProductID
    and P.CategoryID = C.CategoryID
    And C.CategoryName = 'Seafood'
    And O.ShipCountry = 'USA'
    And YEAR(ShippedDate) = 1997
GROUP BY S.ShipperID,CompanyName


--แบบ Join
select s.shipperID,CompanyName,count(o.OrderID) AS NumShipoedOrder
from Shippers AS S INNER JOIN Orders As O On S.ShipperID = O.ShipVia 
                    INNER JOIN [Order Details] As OD On O.OrderID = OD.OrderID
                    INNER JOIN Products AS P On OD.ProductID = P.ProductID
                    INNER JOIN Categories AS C On P.CategoryID = C.CategoryID
where C.CategoryName = 'Seafood'
    And O.ShipCountry = 'USA'
    And YEAR(shippedDate) = 1997
GROUP BY S.ShipperID,CompanyName
---------------------------------------------------------------------------
-- *** 6 ตาราง ***
/*17 : จงแสดงรหัสประเภทสินค้า ชื่อประเภท ยอดสั่งซื้อรวม(ไม่คิดส่วนลด) ที่ทำรายการขายโดย Margaret Peacock ในปี 1997 
และสั่งซื้อโดยลูกค้าที่อาศัยอยู่ในประเทศสหรัฐอเมริกา สหราชอาณาจักร แคนาดา */
--แบบ Product
select C.CategoryID,CategoryName,Sum(OD.UnitPrice * Quantity)AS totalVume
From Categories AS C , Products AS P , [Order Details] As OD
    , Orders As O , Customers AS Cu , Employees AS E
where C.CategoryID = P.CategoryID 
    and P.ProductID = OD.ProductID 
    and OD.OrderID = O.OrderID
    and O.CustomerID = Cu.CustomerID
    and O.EmployeeID = E.EmployeeID
    And FirstName = 'Margaret' And LastName = 'Peacock'
    And YEAR(OrderDate) = 1997
    And Cu.Country in ('USA','UK','Canada')
    group by c.CategoryID,CategoryName

--แบบ Join
select C.CategoryID,CategoryName,Sum(OD.UnitPrice * Quantity)AS totalVume
from Categories AS C INNER JOIN Products AS P On C.CategoryID = P.CategoryID
                    INNER JOIN [Order Details] As OD On P.ProductID = OD.ProductID 
                    INNER JOIN Orders As O On OD.OrderID = O.OrderID
                    INNER JOIN Customers AS Cu On O.CustomerID = Cu.CustomerID
                    INNER JOIN Employees AS E On O.EmployeeID = E.EmployeeID
where YEAR(OrderDate) = 1997
    And Cu.Country In ('USA','UK','Canada')
    And FirstName = 'Margaret' And LastName = 'Peacock'
    group by c.CategoryID,CategoryName

---------------------------------------------------------------------------
/*18 : จงแสดงรหัสสินค้า ชื่อสินค้า ยอดสั่งซื้อรวม(ไม่คิดส่วนลด) ของสินค้าที่จัดจำหน่ายโดยบริษัทที่อยู่ประเทศสหรัฐอเมริกา ที่มีการสั่งซื้อในปี 1997 
จากลูกค้าที่อาศัยอยู่ในประเทศสหรัฐอเมริกา และทำการขายโดยพนักงานที่อาศัยอยู่ในประเทศสหรัฐอเมริกา */
--แบบ Product
select P.ProductID,ProductName,Sum(OD.UnitPrice * Quantity)AS totalVume
From Products AS P ,Suppliers AS S ,[Order Details] As OD
    , Orders As O , Customers AS Cu , Employees AS E
where P.SupplierID = S.SupplierID 
    and P.ProductID = OD.ProductID 
    and OD.OrderID = O.OrderID
    and O.CustomerID = Cu.CustomerID
    and O.EmployeeID = E.EmployeeID
    And S.Country = 'USA'
    And Cu.Country = 'USA'
    And E.Country = 'USA'
    And YEAR(OrderDate) = 1997
GROUP BY P.ProductID,ProductName

--แบบ Join
select P.ProductID,ProductName,Sum(OD.UnitPrice * Quantity)AS totalVume
From Products AS P INNER JOIN Suppliers AS S On P.SupplierID = S.SupplierID
                    INNER JOIN [Order Details] As OD On P.ProductID = OD.ProductID 
                    INNER JOIN Orders As O On OD.OrderID = O.OrderID
                    INNER JOIN Customers AS Cu On O.CustomerID = Cu.CustomerID
                    INNER JOIN Employees AS E On O.EmployeeID = E.EmployeeID
where S.Country = 'USA'
    And Cu.Country = 'USA'
    And E.Country = 'USA'
    And YEAR(OrderDate) = 1997
group by P.ProductID,ProductName
