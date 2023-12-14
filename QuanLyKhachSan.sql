create database QuanLyKS
use QuanLyKS

--Cau 1--
create table KHACHTHUE
(
	MaKhach char(5) not null primary key,
	TenKhach varchar(50) not null,
	QuocTich varchar(20) not null,
	NgaySinh date not null,
	GioiTinh bit not null,
	Email varchar(50) not null, 
)

create table PHONG
(
	MaPhong char(5) not null primary key,
	LoaiPhong varchar(7) not null, 
	DonGia int not null,
	SucChua int not null
)

create table HOADON
(
	SoHoaDon char(7) not null primary key,
	MaKhach char(5) not null,
	MaPhong char(5) not null, 
	NgayLapHD date not null,
	NgayDen date not null, 
	NgayDi date not null,
	ThoiGianThue int, 
	TienPhong int, 
	ChietKhau int, 
	TienThanhToan int,
	Constraint FK_KHACHTHUE foreign key (MaKhach) References KHACHTHUE(MaKhach),
	Constraint FK_PHONG foreign key (MaPhong) References PHONG(MaPhong)
)

--Cau 2--
insert into KHACHTHUE(MaKhach, TenKhach, QuocTich, NgaySinh, GioiTinh, Email)
values
	('01002', 'Nguyen Thi Lan Anh', 'Viet Nam', '1967-06-03', 0, 'lananh0603@gmail.com'),
	('02003', 'Tuan Potter', 'American', '1984-07-03', 1, 'nguyenquoctuan0703@gmail.com'),
	('09003', 'Nguyen Van Tu', 'Viet Nam', '1999-02-09', 1, 'vantu1999@gmail.com'),
	('07009', 'Nguyen Thi Khanh Ha', 'Viet Nam', '1992-09-26', 0, 'hadng269@gmail.com'),
	('08005', 'Nguyen Cong Huy', 'American', '1997-09-07', 1, 'conghuy97@gmail.com')

insert into PHONG(MaPhong, LoaiPhong, DonGia, SucChua)
values
	('PH201', 'VIP', 300, 4),
	('PH309', 'Lux', 150, 2),
	('PH402', 'Eco', 100, 2),
	('PH302', 'Eco', 100, 2),
	('PH107', 'VIP', 300, 4)

insert into HOADON(SoHoaDon, MaKhach, MaPhong, NgayLapHD, NgayDen, NgayDi)
values
	('HD123', '01002','PH201', '2021-10-08', '2021-10-09', '2021-10-20'),
	('HD124', '02003','PH309', '2021-10-08', '2021-11-15', '2021-11-26'),
	('HD125', '09003', 'PH402', '2021-04-09', '2021-04-15', '2021-04-22'),
	('HD126', '07009', 'PH302', '2021-06-10', '2021-06-11', '2021-06-18'),
	('HD127', '08005', 'PH107', '2021-11-11', '2021-11-20', '2021-11-27')

--Cau 3--
update PHONG set DonGia =
case 
	when LoaiPhong = 'VIP' then 300
	when LoaiPhong = 'Lux' then 150
	when LoaiPhong = 'Eco' then 100
end

--Cau 4--
update HOADON set ThoiGianThue  = 
case 
	when datediff(day, NgayDen, NgayDi) = 0 then 1
	else datediff(day, NgayDen, NgayDi)
end

--Cau 5--
update HOADON set TienPhong = ThoiGianThue * DonGia
from HOADON inner join PHONG on HOADON.MaPhong = PHONG.MaPhong

--Câu 6--
update HOADON set ChietKhau =
case 
	when ThoiGianThue > 8 then 0.2 * TienPhong
	when ThoiGianThue >=6 then 0.1 * TienPhong
	when ThoiGianThue >= 3 then 0.05* TienPhong
	else 0
end 
 
--Câu 7--
select LoaiPhong, count(*) as SoPhong
from PHONG
group by LoaiPhong

--Câu 8--
select LoaiPhong, count(*) SoPhong
from PHONG inner join HOADON on PHONG.MaPhong = HOADON.MaPhong
where LoaiPhong = 'VIP' and ThoiGianThue > 5 and datepart(quarter, NgayDen) = 2
group by LoaiPhong

--Câu 9--
select count(*) as So_Lan_Thue, sum(ThoiGianThue) as Tong_Thoi_Gian_Thue, avg(ThoiGianThue) as Thoi_Gian_TB
from HOADON
where datepart(month, NgayDen) = 10

--Câu 10--
select TenKhach, QuocTich, NgayDen,NgayDi, LoaiPhong, DonGia
