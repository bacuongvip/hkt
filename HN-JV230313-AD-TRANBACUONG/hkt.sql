create database hkt;
use hkt;

create table dmkhoa(
	makhoa varchar(20) primary key,
    tenkhoa varchar(255)
);

create table dmnganh(
	manganh int primary key,
    tennganh varchar(255),
    makhoa varchar(20),
    foreign key (makhoa) references dmkhoa(makhoa)
);

create table dmlop(
	malop varchar(20) primary key,
    tenlop varchar(255),
    manganh int,
    khoahoc int,
    hedt varchar(255),
    namnhaphoc int,
    foreign key (manganh) references dmnganh(manganh)
);

create table dmhocphan(
	mahp int primary key auto_increment,
    tenhp varchar(255),
    sodvht int,
    manganh int,
    hocky int,
    foreign key (manganh) references dmnganh(manganh)
);

create table sinhvien(
	masv int primary key auto_increment,
    hoten varchar(255),
    malop varchar(20),
    gioitinh tinyint(1),
    ngaysinh date,
    diachi varchar(255),
    foreign key (malop) references dmlop(malop)
);
create table diemhp(
	masv int,
    mahp int,
    diemhp float,
    primary key(masv, mahp),
    foreign key (masv) references sinhvien(masv),
    foreign key (mahp) references dmhocphan(mahp)
);

insert into dmkhoa values
('CNTT', 'Công nghệ thông tin'),
('KT', 'Kế Toán'),
('SP', 'Sư Phạm');

insert into dmnganh values
(140902, 'Sư phạm toán tin', 'SP'),
(480202, 'Tin học ứng dụng', 'CNTT');

insert into dmlop values
('CT11', 'Cao đẳng tin học', 480202, 11, 'TC', 2013),
('CT12', 'Cao đẳng tin học', 480202, 12, 'CĐ', 2013),
('CT13', 'Cao đẳng tin học', 480202, 13, 'TC', 2014);

insert into dmhocphan(tenhp, sodvht, manganh, hocky) values
('Toán cao cấp A1', 4, 480202, 1),
('Tiếng anh 1', 3, 480202, 1),
('Vật lý đại cương', 4, 480202, 1),
('Tiếng anh 2', 7, 480202, 1),
('Tiếng anh 1', 3, 140902, 2),
('Xác suất thống kê', 3, 480202, 2);

insert into sinhvien(hoten, malop, gioitinh, ngaysinh, diachi) values
('Phan Thanh', 'CT12', 0, '1990-09-12', 'Tuy Phước'),
('Nguyễn Thị Cẩm', 'CT12', 1, '1994-01-12', 'Quy Nhơn'),
('Võ Thị Hà', 'CT12', 1, '1995-07-02', 'An Nhơn'),
('Trần Hoài Nam', 'CT12', 0, '1994-04-05', 'Tây Sơn'),
('Trần Văn Hoàng', 'CT13', 0, '1995-08-04', 'Vĩnh Thạnh'),
('Đặng Thị Thảo', 'CT13', 1, '1995-06-12', 'Quy Nhơn'),
('Lê Thị Sen', 'CT13', 1, '1994-08-12', 'Phù Mỹ'),
('Nguyễn Văn Huy', 'CT11', 0, '1995-06-04', 'Tuy Phước'),
('Trần Thị Hoa', 'CT11', 1, '1994-08-09', 'Hoài Nhơn');

insert into diemhp values
(2, 2, 5.9),
(2, 3, 4.5),
(3, 1, 4.3),
(3, 2, 6.7),
(3, 3, 7.3),
(4, 1, 4),
(4, 2, 5.2),
(4, 3, 3.5),
(5, 1, 9.8),
(5, 2, 7.9),
(5, 3, 7.5),
(6, 1, 6.1),
(6, 2, 5.6),
(6, 3, 4),
(7, 1, 6.2);

-- 1. Cho biết họ tên sinh viên KHÔNG học học phần nào
select sv.masv, sv.hoten from sinhvien sv
where sv.masv not in (
select masv from diemhp);

-- 2.	Cho biết họ tên sinh viên CHƯA học học phần nào có mã 1 
select sv.masv, sv.hoten from sinhvien sv
where sv.masv not in (
select sv.masv from sinhvien sv
left join diemhp on diemhp.masv = sv.masv
where diemhp.mahp = 1);

-- 3.	Cho biết Tên học phần KHÔNG có sinh viên điểm HP <5
select dmhocphan.mahp, dmhocphan.tenhp from dmhocphan 
where dmhocphan.mahp not in 
(select distinct diemhp.mahp from diemhp 
join dmhocphan on diemhp.mahp = dmhocphan.mahp
where diemhp.diemhp < 5);

-- 4.	Cho biết Họ tên sinh viên KHÔNG có học phần điểm HP<5 
select sv.masv, sv.hoten from sinhvien sv
where sv.masv not in 
(select diemhp.masv from diemhp
group by diemhp.masv
having min(diemhp.diemhp) < 5);

-- 5.	Cho biết Tên lớp có sinh viên tên Hoa 
select dmlop.tenlop from sinhvien sv
join dmlop on sv.malop = dmlop.malop
where sv.hoten like '%hoa';

-- 6.	Cho biết HoTen sinh viên có điểm học phần 1 là <5.
select sv.hoten from diemhp
join sinhvien sv on sv.masv = diemhp.masv
where diemhp < 5 and diemhp.mahp = 1;

-- 7.	Cho biết danh sách các học phần có số đơn vị học trình lớn hơn hoặc bằng số đơn vị học trình của học phần mã 1.
select * from dmhocphan
where dmhocphan.sodvht >= (
select dmhocphan.sodvht from dmhocphan
where dmhocphan.mahp = 1);

-- 8.	Cho biết HoTen sinh viên có DiemHP cao nhất
select sv.masv, sv.hoten, diemhp.mahp, diemhp.diemhp from sinhvien sv
join diemhp on diemhp.masv = sv.masv
where diemhp.diemhp >= all (select max(diemhp.diemhp) from diemhp);

-- 9.	Cho biết MaSV, HoTen sinh viên có điểm học phần mã 1 cao nhất
select sv.masv, sv.hoten from sinhvien sv
join diemhp on diemhp.masv = sv.masv
where diemhp.diemhp >= all (select max(diemhp.diemhp) from diemhp where diemhp.mahp = 1);

-- 10.	Cho biết MaSV, MaHP có điểm HP lớn hơn bất kì các điểm HP của sinh viên mã 3 
select diemhp.masv, diemhp.mahp from diemhp
where diemhp.diemhp > any (select diemhp.diemhp from diemhp where diemhp.masv = 3);

-- 11.	Cho biết MaSV, HoTen sinh viên ít nhất một lần học học phần nào đó. 
select sv.masv, sv.hoten from sinhvien sv
where exists (select 1 from diemhp where diemhp.masv = sv.masv);

-- 12.	Cho biết MaSV, HoTen sinh viên đã không học học phần nào
select sv.masv, sv.hoten from sinhvien sv
where not exists (select 1 from diemhp where diemhp.masv = sv.masv);

-- 13.	Cho biết MaSV đã học ít nhất một trong hai học phần có mã 1, 2. 
select diemhp.masv from diemhp
where diemhp.mahp = 1
union
select diemhp.masv from diemhp
where diemhp.mahp = 2;

-- 14.	Tạo thủ tục có tên KIEM_TRA_LOP 
delimiter //
create procedure kiem_tra_lop(in lop varchar(20))
begin
if(lop in (select malop from dmlop)) then 
	select distinct sv.masv, sv.hoten from sinhvien sv
    join dmlop on dmlop.malop = sv.malop
    join diemhp on diemhp.masv = sv.masv
    where dmlop.malop = lop
    group by diemhp.masv
    having min(diemhp.diemhp) >= 5;
else
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'Lớp này không có trong danh mục';
end if;
end;
// delimiter ;
call kiem_tra_lop('CT13');

-- 15.	Tạo một trigger để kiểm tra tính hợp lệ của dữ liệu nhập vào bảng sinhvien 
delimiter //
create trigger before_masv
before insert on sinhvien
for each row
begin
	if new.masv is null then
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Mã sinh viên phải được nhập';
	end if;
end;

-- 16.	Tạo một TRIGGER khi thêm một sinh viên trong bảng sinhvien 
ALTER TABLE dmlop 
ADD COLUMN SiSo INT;

DELIMITER //
CREATE TRIGGER before_masv2
AFTER INSERT ON sinhvien
FOR EACH ROW
BEGIN
    DECLARE siso_count INT;
    
    SELECT COUNT(sv.malop) INTO siso_count
    FROM sinhvien sv
    WHERE sv.malop = NEW.malop
    GROUP BY sv.malop;
    
    UPDATE dmlop
    SET SiSo = siso_count
    WHERE dmlop.malop = NEW.malop;
END //
DELIMITER ;

-- 17.	Viết một function DOC_DIEM đọc điểm chữ số thập phân thành chữ 
DELIMITER //
CREATE FUNCTION DOC_DIEM(diem DECIMAL(10, 2))
RETURNS VARCHAR(255)
BEGIN
    DECLARE phan_nguyen INT;
    DECLARE phan_le INT;
    DECLARE chu_so VARCHAR(255);
    DECLARE chu_phan_le VARCHAR(255);
    DECLARE chu_diem VARCHAR(255);
    
    SET phan_nguyen = FLOOR(diem);
    SET phan_le = ROUND((diem - phan_nguyen) * 10);
    
    -- Ánh xạ số thành chữ (0-9)
    CASE phan_le
        WHEN 1 THEN SET chu_phan_le = 'một';
        WHEN 2 THEN SET chu_phan_le = 'hai';
        WHEN 3 THEN SET chu_phan_le = 'ba';
        WHEN 4 THEN SET chu_phan_le = 'bốn';
        WHEN 5 THEN SET chu_phan_le = 'năm';
        WHEN 6 THEN SET chu_phan_le = 'sáu';
        WHEN 7 THEN SET chu_phan_le = 'bảy';
        WHEN 8 THEN SET chu_phan_le = 'tám';
        WHEN 9 THEN SET chu_phan_le = 'chín';
        ELSE SET chu_phan_le = '';
    END CASE;
    
    -- Ánh xạ số nguyên thành chữ
    CASE phan_nguyen
        WHEN 0 THEN SET chu_so = 'không';
        WHEN 1 THEN SET chu_so = 'một';
        WHEN 2 THEN SET chu_so = 'hai';
        WHEN 3 THEN SET chu_so = 'ba';
        WHEN 4 THEN SET chu_so = 'bốn';
        WHEN 5 THEN SET chu_so = 'năm';
        WHEN 6 THEN SET chu_so = 'sáu';
        WHEN 7 THEN SET chu_so = 'bảy';
        WHEN 8 THEN SET chu_so = 'tám';
        WHEN 9 THEN SET chu_so = 'chín';
        ELSE SET chu_so = '';
    END CASE;
    
    IF phan_le > 0 THEN
        SET chu_diem = CONCAT(chu_so, ' phẩy ', chu_phan_le);
    ELSE
        SET chu_diem = chu_so;
    END IF;
    
    RETURN chu_diem;
END;
//
DELIMITER ;

-- 18.	Tạo thủ tục: HIEN_THI_DIEM Hiển thị danh sách gồm MaSV, HoTen, MaLop, DiemHP, MaHP của những sinh viên có DiemHP nhỏ hơn số chỉ định, nếu không có thì hiển thị thông báo không có sinh viên nào.
delimiter //
create procedure hien_thi_diem(diem float)
begin
declare count_students int;
select COUNT(*) into count_students
    from diemhp
    where diemhp.diemhp < diem;
if(count_students > 0) then 
	select distinct sv.masv, sv.hoten, sv.malop, diemhp.diemhp, diemhp.mahp from sinhvien sv
    join diemhp on diemhp.masv = sv.masv
    where diemhp.diemhp < diem;
else
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'không có sinh viên nào';
end if;
end;
// DELIMITER ;
call hien_thi_diem(4.5);

-- 19.	Tạo thủ tục: HIEN_THI_MAHP hiển thị HoTen sinh viên CHƯA học học phần có mã chỉ định
DELIMITER //
CREATE PROCEDURE HIEN_THI_MAHP(IN ma_hp INT)
BEGIN
    DECLARE count_mahp INT;

    SELECT COUNT(*) INTO count_mahp
    FROM dmhocphan
    WHERE dmhocphan.mahp = ma_hp;

    IF count_mahp = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không có học phần này' ;
    ELSE
        SELECT sv.hoten, sv.masv
        FROM sinhvien sv
        WHERE sv.masv NOT IN (SELECT masv FROM diemhp WHERE mahp = ma_hp);
    END IF;
END;
//
DELIMITER ;
call hien_thi_mahp(1);

-- 20.	Tạo thủ tục: HIEN_THI_TUOI  Hiển thị danh sách gồm: MaSV, HoTen, MaLop, NgaySinh, GioiTinh, Tuoi của sinh viên có tuổi trong khoảng chỉ định
DELIMITER //
CREATE PROCEDURE HIEN_THI_TUOI(tuoi_min INT, tuoi_max INT)
BEGIN
    DECLARE count_students INT;

    SELECT COUNT(*) INTO count_students
    FROM sinhvien
    WHERE YEAR(CURDATE()) - YEAR(NgaySinh) BETWEEN tuoi_min AND tuoi_max;

    IF count_students = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không có sinh viên nào';
    ELSE
        SELECT MaSV, HoTen, MaLop, NgaySinh, GioiTinh, YEAR(CURDATE()) - YEAR(NgaySinh) AS Tuoi
        FROM sinhvien
        WHERE YEAR(CURDATE()) - YEAR(NgaySinh) BETWEEN tuoi_min AND tuoi_max;
    END IF;
END;
//
DELIMITER ;
call hien_thi_tuoi(20, 30);

