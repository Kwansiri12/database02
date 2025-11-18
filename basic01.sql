--Student ID 67040249133
--Student Name Kwansiri Suwannatrai

-- *********แบบฝึกหัด Basic Query #1 ***************
--1. แสดงข้อมูลสินค้า 10 รายการแรก
select * from Products
where ProductID between 1 and 10;

select Top 10 * from Products

--2. จงแสดงข้อมูล รหัสพนักงาน ชื่อ นามสกุล ของพนักงานทุกคน
select EmployeeID, FirstName, LastName from Employees ;

--3. แสดงรหัสพนักงาน ชื่อและนามสกุลต่อกัน อายุ ของพนักงานแต่ละคน
select EmployeeID, (FirstName + Space(3) + LastName) AS EmployeeName,
		year(Getdate()) - year(birthdate) AS Age
from Employees;

/*4. แสดงข้อมูลรหัสสินค้า ชื่อสินค้า ราคาต่อหน่วย จำนวนคงเหลือ รหัสประเภทสินค้า
จัดเรียงข้อมูลตามรหัสประเภทสินค้า จากน้อยไปหามาก และจำนวนคงเหลือจากมากไปหาน้อย */
select ProductID, ProductName, UnitPrice,UnitsInStock,CategoryID
from Products
order By CategoryID ASC,UnitsInStock DESC;

--5. แสดงจำนวนรายการสินค้าที่จัดอยู่ในประเภทสินค้ารหัส 1
select count(ProductID) as 'จำนวนรายการสินค้า' from Products
where CategoryID = 1;

--6. แสดงจำนวนลูกค้าที่อยู่ในประเทศสหรัฐอเมริกา
select count(CustomerID) as 'จำนวนลูกค้า' from Customers
where Country = 'USA';

--7. แสดงจำนวนใบสั่งซื้อที่จัดส่งไปยังประเทศฝรั่งเศส ในปี 1997
select count(*) as numOrders
from Orders 
where ShipCountry = 'France' and year(shippedDate) = '1997';

--8. แสดงราคาต่อหน่วยของสินค้าที่แพงสุด และถูกที่สุด
select Max(UnitPrice) AS max_Price, Min(UnitPrice) AS Min_Price
from Products
-- แสดงข้อมูลสินค้าที่มีราคาต่อหน่วยแพงที่สุด
select *
from Products
where UnitPrice = (select Max(UnitPrice) From Products);

--9. จงแสดงอายุของพนักงานที่มากสุดและอายุน้อยสุด
select MAX(year(Getdate()) - year(birthdate)) AS Max_Age,
		MIN(year(Getdate()) - year(birthdate)) AS MIN_Age 
from Employees;

--10. แสดงรหัสสินค้า ราคาต่อหน่วย จำนวนที่ซื้อ ราคารวม ของรายการสั่งซื้อที่อยู่ในใบสั่งซื้อหมายเลข10248
select ProductID,UnitPrice,Quantity,(UnitPrice * Quantity) AS SumPrice
from [Order Details]
where OrderID = 10248;

--11. แสดงยอดสั่งซื้อรวมของใบสั่งซื้อหมายเลข 10248
select Sum(UnitPrice * Quantity) AS totalPrice
from [Order Details]
where OrderID = 10248;

--12. แสดงอายุเฉลี่ยของพนักงาน
select AVG(year(Getdate()) - year(birthdate)) AS AVG_Age
from Employees

--13. แสดงรหัสประเภทสินค้าและจำนวนรายการสินค้าในแต่ละประเภท
select CategoryID,COUNT(ProductID) AS NumProductID
From Products
Group BY CategoryID;


/*14. แสดงรหัสประเภทสินค้าและจำนวนรายการสินค้าในแต่ละประเภท 
เฉพาะประเภทสินค้าที่มีรายการสินค้าอยู่ในประเภทนั้น 10 รายการขึ้นไป */

--15. แสดงชื่อประเทศและจำนวนลูกค้าที่อยู่ในแต่ละประเทศ เฉพาะประเทศที่มีลูกค้าไม่ถึง 5 ราย

/*16. แสดงรหัสใบสั่งซื้อและยอดสั่งซื้อรวมในแต่ละใบสั่งซื้อ เฉพาะใบสั่งซื้อที่มียอดสั่งซื้อรวมเกิน $10000
จัดเรียงข้อมูลตามยอดสั่งซื้อรวมจากมากไปหาน้อย */
