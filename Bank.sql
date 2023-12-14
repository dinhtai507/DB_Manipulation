USE Bank
--1.	Thống kê số lượng giao dịch, tổng tiền giao dịch trong từng tháng của năm 2014
SELECT COUNT(t_id) AS So_luong_giao_dich, SUM(t_amount) AS So_tien_giao_dich, DATEPART(mm,t_date) AS Thang
FROM transactions
WHERE DATEPART(yy,t_date) = 2014
GROUP BY DATEPART(mm,t_date)
--2.	Thống kê tổng tiền khách hàng gửi của mỗi chi nhánh, sắp xếp theo thứ tự giảm dần của tổng tiền
SELECT Cust_name, SUM(t_amount) AS So_tien_giao_dich, BR_name
FROM account JOIN customer ON account.cust_id = customer.Cust_id
			 JOIN transactions ON account.Ac_no = transactions.ac_no
			 JOIN Branch ON Branch.BR_id = customer.Br_id
WHERE t_type = '1'
GROUP BY Cust_name,BR_name
ORDER BY SUM(t_amount) DESC
--3.	Những chi nhánh nào thực hiện nhiều giao dịch gửi tiền trong tháng 12/2015 hơn chi nhánh Đà Nẵng

SELECT BR_name,COUNT(t_type) AS Tong_gd_gui_tien
FROM account JOIN customer ON account.cust_id = customer.Cust_id
			 JOIN transactions ON account.Ac_no = transactions.ac_no
			 JOIN Branch ON Branch.BR_id = customer.Br_id
WHERE t_type = '1' AND (DATEPART(mm,t_date) = 12 
				   AND DATEPART(yy,t_date) = 2015)
				   AND BR_name <> N'Vietcombank Đà Nẵng'
GROUP BY BR_name, t_type
HAVING COUNT(t_type) > (SELECT COUNT(t_type) 
						FROM account JOIN customer ON account.cust_id = customer.Cust_id
									 JOIN transactions ON account.Ac_no = transactions.ac_no
									 JOIN Branch ON Branch.BR_id = customer.Br_id 
						WHERE t_type = '1' AND (DATEPART(mm,t_date) = 12 
										   AND DATEPART(yy,t_date) = 2015)
										   AND BR_name = N'Vietcombank Đà Nẵng')

--4.	Hiển thị danh sách khách hàng chưa thực hiện giao dịch nào trong năm 2017?
SELECT Cust_name
FROM customer
WHERE Cust_name NOT IN (SELECT Cust_name 
						FROM account JOIN customer ON account.cust_id = customer.Cust_id
									 JOIN transactions ON account.Ac_no = transactions.ac_no
						WHERE DATEPART(yy,t_date) = 2017)

--C2
SELECT Cust_name
FROM customer
WHERE Cust_name <> ALL (SELECT Cust_name 
						FROM account JOIN customer ON account.cust_id = customer.Cust_id
									 JOIN transactions ON account.Ac_no = transactions.ac_no
						WHERE DATEPART(yy,t_date) = 2017)
--5.	Tìm giao dịch gửi tiền nhiều nhất trong mùa đông. Nếu có thể, hãy đưa ra tên của người thực hiện giao dịch và chi nhánh.
SELECT TOP(1) Cust_name, t_type, BR_name,DATEPART(qq,t_date) AS Quy, Max(t_amount) AS Tong_so_tien
FROM account JOIN customer ON account.cust_id = customer.Cust_id
			 JOIN transactions ON account.Ac_no = transactions.ac_no
			 JOIN Branch ON Branch.BR_id = customer.Br_id 
WHERE DATEPART(qq,t_date) = 4 AND t_type = '1'
GROUP BY Cust_name,t_type, BR_name,DATEPART(qq,t_date),t_amount
ORDER BY Max(t_amount) DESC

--6.	Có bao nhiêu người ở Đắc Lắc sở hữu nhiều hơn một tài khoản?
SELECT COUNT(c.Cust_name) AS Tong_so_nguoi FROM customer c
WHERE EXISTS (
SELECT a.cust_id AS Tong_so_tai_khoan
FROM account a
WHERE c.Cust_id = a.Cust_id AND Cust_ad LIKE N'%Đăk%Lăk%' 
GROUP BY a.cust_id
HAVING COUNT(Ac_no) > 1)


/*7.	Cuối mỗi năm, nhiều khách hàng có xu hướng rút tiền khỏi ngân hàng để chuyển sang ngân hàng khác hoặc 
chuyển sang hình thức tiết kiệm khác. Hãy lọc những khách hàng có xu hướng rút tiền khỏi ngân hàng bằng cách hiển thị 
những người rút gần hết tiền trong tài khoản (tổng tiền rút trong tháng 12/2017 nhiều hơn 100 triệu và số dư trong tài khoản còn lại <= 100.000)*/
SELECT Cust_name,a.Ac_no, SUM(t_amount) AS Tong_tien_da_rut,
	ac_balance AS So_du_tk
FROM account a JOIN customer c ON a.cust_id = c.Cust_id
			  JOIN transactions t ON a.Ac_no = t.ac_no 
WHERE t_type = '0' AND (DATEPART(mm,t_date) = 12 AND DATEPART(yy,t_date) = 2017) AND (ac_balance <= 100000) 
GROUP BY Cust_name,a.Ac_no,ac_balance
HAVING SUM(t_amount) > 100000000

--8.	Hãy liệt kê những tài khoản bất thường đó. Gợi ý: tài khoản bất thường là tài khoản có tổng tiền gửi – tổng tiền rút <> số tiền trong tài khoản
SELECT a.Ac_no AS So_tk,
	((SELECT SUM(t_amount) FROM transactions t1 WHERE a.Ac_no = t1.ac_no AND t_type = '1') 
			- (SELECT SUM(t_amount) FROM transactions  t1 WHERE a.Ac_no = t1.ac_no AND t_type = '0')) AS So_tien_gui_rut,
	ac_balance AS So_du_tk
FROM account a JOIN transactions t ON a.Ac_no = t.ac_no 
WHERE ac_balance <> ((SELECT SUM(t_amount) FROM transactions t1 WHERE a.Ac_no = t1.ac_no AND t_type = '1') 
							- (SELECT SUM(t_amount) FROM transactions  t1 WHERE a.Ac_no = t1.ac_no AND t_type = '0')) 
GROUP BY a.Ac_no,a.ac_balance

/*9.	Ngân hàng cần biết những chi nhánh nào có nhiều giao dịch rút tiền vào buổi chiều để chuẩn bị chuyển tiền tới. 
Hãy liệt kê danh sách các chi nhánh và lượng tiền rút trung bình theo ngày (chỉ xét những giao dịch diễn ra trong buổi chiều), sắp xếp giảm giần theo lượng tiền giao dịch.*/
SELECT BR_name, SUM(t_amount) AS Luong_tien_rut,t_time
FROM account JOIN customer ON account.cust_id = customer.Cust_id
			 JOIN transactions ON account.Ac_no = transactions.ac_no
			 JOIN Branch ON Branch.BR_id = customer.Br_id 
WHERE t_type = '0' AND (DATEPART(hh,t_time) BETWEEN 13 AND 17)
GROUP BY BR_name,t_time
ORDER BY SUM(t_amount) DESC

/*10.	Hiển thị những giao dịch trong mùa xuân của các chi nhánh miền trung. 
Gợi ý: giả sử một năm có 4 mùa, mỗi mùa kéo dài 3 tháng; chi nhánh miền trung có mã chi nhánh bắt đầu bằng VT.*/
SELECT BR_name,t_id, t_date,Branch.BR_id
FROM account JOIN customer ON account.cust_id = customer.Cust_id
			 JOIN transactions ON account.Ac_no = transactions.ac_no
			 JOIN Branch ON Branch.BR_id = customer.Br_id 
WHERE DATEPART(qq,t_date) = 1 AND Branch.BR_id LIKE N'VT%'
ORDER BY BR_name
--11.	Ông Phạm Duy Khánh thuộc chi nhánh nào? Từ 01/2017 đến nay ông Khánh đã thực hiện bao nhiêu giao dịch gửi tiền vào ngân hàng với tổng số tiền là bao nhiêu.
SELECT Cust_name,BR_name,SUM(t_amount) AS Tong_tien_gui,COUNT(t_type) AS So_lan_giao_dich
FROM account JOIN customer ON account.cust_id = customer.Cust_id
			 JOIN transactions ON account.Ac_no = transactions.ac_no
			 JOIN Branch ON Branch.BR_id = customer.Br_id 
WHERE Cust_name = N'Phạm Duy Khánh' 
			 AND t_type = '1' 
		     AND DATEPART(mm,t_date) BETWEEN 1 AND GETDATE() 
			 AND DATEPART(yy,t_date) BETWEEN 2017 AND GETDATE()
GROUP BY Cust_name,BR_name,t_type
--12.	Hiển thị khách hàng cùng họ với khách hàng có mã số 000002
SELECT Cust_name
FROM customer 
WHERE LEFT(Cust_name,CHARINDEX(' ',Cust_name)) = (SELECT LEFT(Cust_name,CHARINDEX(' ',Cust_name)) FROM customer WHERE Cust_id = '000002')
AND Cust_id <> '000002'

--13.	Hiển thị những khách hàng sống cùng tỉnh/thành phố với ông Lương Minh Hiếu
SELECT Cust_name, Cust_ad
FROM customer 
WHERE UPPER(RIGHT(Cust_ad,3)) = (SELECT UPPER(RIGHT(Cust_ad,3)) FROM customer WHERE Cust_name = N'Lương Minh Hiếu')