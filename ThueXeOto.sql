Create Database ThueXeOto
Use ThueXeOto
--
Create table HOPDONGTHUEXE(SoHopDong char(5) not null Primary key,
MaKhach char(7) not null, BienSo varchar(10) not null,
NgayThue date not null, NgayTra date not null,
ThoigianThue varchar(3), GiaTriHopDong varchar(10),
DatTruoc varchar(2), ConLai varchar(2))
Insert into HOPDONGTHUEXE(SoHopDong, MaKhach, BienSo, NgayThue, NgayTra)
values ('HD123','ABC2001', '75A1-12345', '2021-01-08', '2021-02-08'),
	('HD124','ABC2002', '43A1-23456', '2021-02-08', '2021-03-08'),
	('HD125','ABC2003', '75A2-45678', '2021-01-09', '2021-02-09'),
	('HD126','ABC2004', '43B1-56789', '2021-01-10', '2021-02-10'),
	('HD127','ABC2005', '75C1-12345', '2021-02-11', '2021-03-11')
Select * from HOPDONGTHUEXE
--
Create table XECHOTHUE(BienSo varchar(10) not null Primary key,
SoChoNgoi int not null, HangSanXuat varchar(20) not null, DonGiaThue int not null)
Insert into XECHOTHUE(BienSo, SoChoNgoi, HangSanXuat, DonGiaThue)
values('75A1-12345', 4, 'Ford', 100000),
('43A1-23456', 7, 'Mercedes', 150000),
('75A2-45678', 7, 'Toyota', 120000),
('43B1-56789', 4, 'Toyota', 130000),
('75C1-12345', 7, 'Ford', 140000)
--
Alter table HOPDONGTHUEXE
Add Constraint FK_XECHOTHUE Foreign key(BienSo) References XECHOTHUE(BienSo)
--
Create table KHACHTHUE(MaKhach char(7) not null Primary Key,
TenKhach varchar(40) not null, GioiTinh bit not null,
NgaySinh date not null, DienThoai varchar(11) not null,
DiaChi varchar(40) not null)
Insert into KHACHTHUE(MaKhach, TenKhach, GioiTinh, NgaySinh, DienThoai, DiaChi)
values('ABC2001', 'Nguyen Thi Lan Anh', 0, '2002-06-03', '02363123123', '1 Le Duan'), 
('ABC2002', 'Nguyen Quoc Tuan', 1, '2002-07-03', '02363234234', '213 Hai Phong'), 
('ABC2003', 'Nguyen Van Tu', 1, '2002-06-03', '02363345345', '160 Nguyen Van Linh'), 
('ABC2004', 'Nguyen Thi Khanh Ha', 0, '2002-09-26', '02363456456', '240 Dien Bien Phu'), 
('ABC2005', 'Nguyen Cong Phuong', 1, '2002-12-02', '02363789789', '250 Yen Bai')
--
Alter table HOPDONGTHUEXE
Add Constraint FK_KHACHTHUE Foreign key(MaKhach) References KHACHTHUE(MaKhach)