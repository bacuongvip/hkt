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

-- 1.Hiển thị danh sách gồm MaSV, HoTên, MaLop, DiemHP, MaHP của những sinh viên có điểm HP >= 5     
select sv.masv, sv.hoten, sv.malop, diemhp.diemhp, diemhp.mahp from sinhvien sv 
join diemhp on diemhp.masv = sv.masv
where diemhp >= 5;

-- 2.	Hiển thị danh sách MaSV, HoTen, MaLop, MaHP, DiemHP, MaHP được sắp xếp theo ưu tiên MaLop, HoTen tăng dần
select sv.masv, sv.hoten, sv.malop, diemhp.diemhp, diemhp.mahp from sinhvien sv 
join diemhp on diemhp.masv = sv.masv
order by sv.malop, sv.hoten;

-- 3. Hiển thị danh sách gồm MaSV, HoTen, MaLop, DiemHP, HocKy của những sinh viên có DiemHP từ 5  7 ở học kỳ I. 
select sv.masv, sv.hoten, sv.malop, diemhp.diemhp, dmhocphan.hocky from sinhvien sv 
join diemhp on diemhp.masv = sv.masv
join dmhocphan on dmhocphan.mahp = diemhp.mahp
where diemhp.diemhp between 5 and 7;

-- 4.	Hiển thị danh sách sinh viên gồm MaSV, HoTen, MaLop, TenLop, MaKhoa của Khoa có mã CNTT 
select sv.masv, sv.hoten, sv.malop, dmlop.tenlop, dmnganh.makhoa from sinhvien sv
join dmlop on sv.malop = dmlop.malop
join dmnganh on dmnganh.manganh = dmlop.manganh
where dmnganh.makhoa like 'CNTT';

-- 5.	Cho biết MaLop, TenLop, tổng số sinh viên của mỗi lớp
select sv.malop, dmlop.tenlop, count(sv.malop) as SiSo from sinhvien sv
join dmlop on sv.malop = dmlop.malop
group by sv.malop;

-- 6.	Cho biết điểm trung bình chung của mỗi sinh viên ở mỗi học kỳ
select dmhocphan.hocky, diemhp.masv, sum(diemhp.diemhp * dmhocphan.sodvht)/sum(dmhocphan.sodvht) as DiemTBC from diemhp
join dmhocphan on diemhp.mahp = dmhocphan.mahp
group by diemhp.masv, dmhocphan.hocky
order by diemhp.masv;

-- 7.	Cho biết MaLop, TenLop, số lượng nam nữ theo từng lớp.
select dmlop.malop, dmlop.tenlop,
(case when sv.gioitinh = 0 then 'Nữ'
	  when sv.gioitinh = 1 then 'Nam'
end) as gioitinh ,count(sv.gioitinh)  from dmlop 
join sinhvien sv on sv.malop = dmlop.malop
group by dmlop.malop, sv.gioitinh;

-- 8.	Cho biết điểm trung bình chung của mỗi sinh viên ở học kỳ 1
select diemhp.masv, sum(diemhp.diemhp * dmhocphan.sodvht)/sum(dmhocphan.sodvht) from diemhp
join dmhocphan on diemhp.mahp = dmhocphan.mahp
group by diemhp.masv;

-- 9.	Cho biết MaSV, HoTen, Số các học phần thiếu điểm (DiemHP<5) của mỗi sinh viên
select sv.masv, sv.hoten, count(diemhp.mahp) as SLuong from sinhvien sv
join diemhp on diemhp.masv = sv.masv
where diemhp.diemhp < 5
group by diemhp.masv;

-- 10.	Đếm số sinh viên có điểm HP <5 của mỗi học phần
select diemhp.mahp, count(diemhp.masv) as SL_SV_Thieu from sinhvien sv
join diemhp on diemhp.masv = sv.masv
where diemhp.diemhp < 5
group by diemhp.mahp
order by diemhp.mahp;

-- 11.	Tính tổng số đơn vị học trình có điểm HP<5 của mỗi sinh viên
select sv.masv, sv.hoten, sum(dmhocphan.sodvht) from sinhvien sv
join diemhp on diemhp.masv = sv.masv
join dmhocphan on dmhocphan.mahp = diemhp.mahp
where diemhp.diemhp < 5
group by sv.masv
order by sv.masv;

-- 12.	Cho biết MaLop, TenLop có tổng số sinh viên >2
select dmlop.malop, dmlop.tenlop, count(sv.masv) as SiSo from sinhvien sv
join dmlop on dmlop.malop = sv.malop
group by dmlop.malop
having SiSo > 2;

-- 13.	Cho biết HoTen sinh viên có ít nhất 2 học phần có điểm <5. 
select sv.masv, sv.hoten, count(sv.masv) as 'Soluong' from sinhvien sv
join diemhp dhp on dhp.masv = sv.masv
where dhp.diemhp < 5
group by sv.masv
having count(sv.masv) >= 2;