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
from Products 


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
select *
 from

--แบบ Join
select * 
 from
---------------------------------------------------------------------------------

/*9 : จงแสดงรหัสผู้จัดส่ง ชื่อบริษัทผู้จัดส่ง ยอดรวมค่าจัดส่ง เฉพาะรายการสั่งซื้อที่ Nancy Davolio เป็นผู้ทำรายการขาย*/
--แบบ Product


--แบบ Join


---------------------------------------------------------------------------------
/*10 : จงแสดงข้อมูลรหัสใบสั่งซื้อ วันที่สั่งซื้อ รหัสลูกค้าที่สั่งซื้อ ประเทศที่จัดส่ง จำนวนที่สั่งซื้อทั้งหมด ของสินค้าชื่อ Tofu ในช่วงปี 1997*/
--แบบ Product


--แบบ Join

-----------------------------------------------------------------------------
/*11 : จงแสดงข้อมูลรหัสสินค้า ชื่อสินค้า ยอดขายรวม(ไม่คิดส่วนลด) ของสินค้าแต่ละรายการเฉพาะที่มีการสั่งซื้อในเดือน มค.-สค. ปี 1997*/
--แบบ Product


--แบบ Join

-----------------------------------------------------------------------------
-- *** 4 ตาราง ****
/*12 : จงแสดงข้อมูลรหัสประเภทสินค้า ชื่อประเภทสินค้า ยอดสั่งซื้อรวม(ไม่คิดส่วนลด) เฉพาะที่มีการจัดส่งไปประเทศสหรัฐอเมริกา ในปี 1997*/
--แบบ Product


--แบบ Join

----------------------------------------------------------------------------
/*13 : จงแสดงรหัสพนักงาน ชื่อและนามสกุล(แสดงในคอลัมน์เดียวกัน) ยอดขายรวมของพนักงานแต่ละคน เฉพาะรายการขายที่จัดส่งโดยบริษัท Speedy Express 
ไปยังประเทศสหรัฐอเมริกา และทำการสั่งซื้อในปี 1997 */
--แบบ Product


--แบบ Join

--------------------------------------------------------------------------
/*14 : จงแสดงรหัสสินค้า ชื่อสินค้า ยอดขายรวม เฉพาะสินค้าที่นำมาจัดจำหน่ายจากประเทศญี่ปุ่น และมีการสั่งซื้อในปี 1997 และจัดส่งไปยังประเทศสหรัฐอเมริกา */
--แบบ Product


--แบบ Join

----------------------------------------------------------------------------
-- *** 5 ตาราง ***
/*15 : จงแสดงรหัสลูกค้า ชื่อบริษัทลูกค้า ยอดสั่งซื้อรวมของการสั่งซื้อสินค้าประเภท Beverages ของลูกค้าแต่ละบริษัท  และสั่งซื้อในปี 1997 จัดเรียงตามยอดสั่งซื้อจากมากไปหาน้อย*/
--แบบ Product


--แบบ Join


---------------------------------------------------------------------------
/*16 : จงแสดงรหัสผู้จัดส่ง ชื่อบริษัทที่จัดส่ง จำนวนใบสั่งซื้อที่จัดส่งสินค้าประเภท Seafood ไปยังประเทศสหรัฐอเมริกา ในปี 1997 */
--แบบ Product


--แบบ Join

---------------------------------------------------------------------------
-- *** 6 ตาราง ***
/*17 : จงแสดงรหัสประเภทสินค้า ชื่อประเภท ยอดสั่งซื้อรวม(ไม่คิดส่วนลด) ที่ทำรายการขายโดย Margaret Peacock ในปี 1997 
และสั่งซื้อโดยลูกค้าที่อาศัยอยู่ในประเทศสหรัฐอเมริกา สหราชอาณาจักร แคนาดา */

--แบบ Product


--แบบ Join

---------------------------------------------------------------------------
/*18 : จงแสดงรหัสสินค้า ชื่อสินค้า ยอดสั่งซื้อรวม(ไม่คิดส่วนลด) ของสินค้าที่จัดจำหน่ายโดยบริษัทที่อยู่ประเทศสหรัฐอเมริกา ที่มีการสั่งซื้อในปี 1997 
จากลูกค้าที่อาศัยอยู่ในประเทศสหรัฐอเมริกา และทำการขายโดยพนักงานที่อาศัยอยู่ในประเทศสหรัฐอเมริกา */

--แบบ Product


--แบบ Join
