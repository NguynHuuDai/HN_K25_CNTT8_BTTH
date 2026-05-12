CREATE DATABASE StudentManagement;
USE StudentManagement;

CREATE TABLE KhoaHoc (
    ma_khoa_hoc INT PRIMARY KEY AUTO_INCREMENT,
    ten_khoa_hoc VARCHAR(100) NOT NULL,
    thoi_gian_hoc INT, 
    trang_thai_khoa_hoc ENUM('Hoạt động', 'Không hoạt động')
);

CREATE TABLE MonHoc (
    ma_mon_hoc VARCHAR(10) PRIMARY KEY, -- Định dạng MHxx
    ten_mon_hoc VARCHAR(100) NOT NULL,
    so_tin_chi INT,
    trang_thai_mon_hoc ENUM('Hoạt động', 'Không hoạt động'),
    ma_khoa_hoc INT,
    FOREIGN KEY (ma_khoa_hoc) REFERENCES KhoaHoc(ma_khoa_hoc)
);

CREATE TABLE SinhVien (
    ma_sinh_vien VARCHAR(10) PRIMARY KEY, 
    ten_sinh_vien VARCHAR(100) NOT NULL,
    nam_sinh INT,
    gioi_tinh BIT, 
    so_dien_thoai VARCHAR(15),
    dia_chi VARCHAR(255),
    trang_thai_sinh_vien ENUM('Đang học', 'Bảo lưu', 'Đình chỉ', 'Tốt nghiệp')
);

CREATE TABLE CCCD (
    ma_the_cccd INT PRIMARY KEY AUTO_INCREMENT,
    so_cccd VARCHAR(20) UNIQUE NOT NULL,
    ngay_cap DATE,
    noi_cap VARCHAR(100),
    ma_sinh_vien VARCHAR(10) UNIQUE,
    FOREIGN KEY (ma_sinh_vien) REFERENCES SinhVien(ma_sinh_vien)
);

CREATE TABLE DangKy (
    ma_dang_ky INT PRIMARY KEY AUTO_INCREMENT,
    ma_mon_hoc VARCHAR(10),
    ma_sinh_vien VARCHAR(10),
    diem_mon_hoc FLOAT CHECK (diem_mon_hoc >= 0 AND diem_mon_hoc <= 10),
    ngay_dang_ky DATE,
    FOREIGN KEY (ma_mon_hoc) REFERENCES MonHoc(ma_mon_hoc),
    FOREIGN KEY (ma_sinh_vien) REFERENCES SinhVien(ma_sinh_vien)
);

INSERT INTO KhoaHoc (ten_khoa_hoc, thoi_gian_hoc, trang_thai_khoa_hoc) VALUES 
('Công nghệ thông tin', 48, 'Hoạt động'),
('Quản trị kinh doanh', 42, 'Hoạt động'),
('Ngôn ngữ Anh', 42, 'Hoạt động'),
('Marketing kỹ thuật số', 36, 'Hoạt động'),
('Thiết kế đồ họa', 36, 'Không hoạt động');

INSERT INTO MonHoc VALUES 
('MH01', 'Cơ sở dữ liệu', 3, 'Hoạt động', 1),
('MH02', 'Lập trình Java', 4, 'Hoạt động', 1),
('MH03', 'Kinh tế vi mô', 2, 'Hoạt động', 2),
('MH04', 'Tiếng Anh chuyên ngành', 3, 'Không hoạt động', 3),
('MH05', 'Cấu trúc dữ liệu', 3, 'Hoạt động', NULL); 

INSERT INTO SinhVien VALUES 
('SV001', 'Nguyễn Văn A', 2003, 1, '0912345678', 'Hà Nội', 'Đang học'),
('SV002', 'Trần Thị B', 2004, 0, '0987654321', 'Đà Nẵng', 'Đang học'),
('SV003', 'Lê Văn C', 2002, 1, '0905556667', 'TP HCM', 'Tốt nghiệp'),
('SV004', 'Phạm Minh D', 2003, 1, '0344556677', 'Hải Phòng', 'Bảo lưu'),
('SV005', 'Hoàng Thu E', 2005, 0, '0388990011', 'Cần Thơ', 'Đang học');

INSERT INTO CCCD (so_cccd, ngay_cap, noi_cap, ma_sinh_vien) VALUES 
('001002003004', '2020-01-01', 'Cục CS QLHC', 'SV001'),
('001002003005', '2021-05-12', 'Cục CS QLHC', 'SV002'),
('001002003006', '2019-11-20', 'Công an tỉnh', 'SV003'),
('001002003007', '2022-03-15', 'Cục CS QLHC', 'SV004'),
('001002003008', '2023-08-08', 'Cục CS QLHC', 'SV005');

INSERT INTO DangKy (ma_mon_hoc, ma_sinh_vien, diem_mon_hoc, ngay_dang_ky) VALUES 
('MH01', 'SV001', 8.5, '2024-01-10'),
('MH02', 'SV001', 7.0, '2024-01-15'),
('MH01', 'SV002', 4.5, '2024-01-10'),
('MH03', 'SV002', 9.0, '2024-02-01'),
('MH01', 'SV005', 6.0, '2024-01-10');


UPDATE MonHoc 
SET ten_mon_hoc = 'Toán cao cấp', so_tin_chi = 3 
WHERE ma_mon_hoc = 'MH01';

DELETE FROM MonHoc 
WHERE trang_thai_mon_hoc = 'Không hoạt động'
AND NOT EXISTS (
    SELECT 1 
    FROM DangKy 
    WHERE DangKy.ma_mon_hoc = MonHoc.ma_mon_hoc
);

SELECT ma_sinh_vien, ten_sinh_vien, so_dien_thoai, dia_chi 
FROM SinhVien;

SELECT ma_mon_hoc, ten_mon_hoc, so_tin_chi 
FROM MonHoc 
WHERE ma_khoa_hoc IS NULL;

SELECT DISTINCT ma_khoa_hoc 
FROM MonHoc 
WHERE ma_khoa_hoc IS NOT NULL;

SELECT sv.ma_sinh_vien, sv.ten_sinh_vien, dk.ngay_dang_ky, mh.ten_mon_hoc, dk.diem_mon_hoc, c.so_cccd
FROM SinhVien sv
JOIN DangKy dk ON sv.ma_sinh_vien = dk.ma_sinh_vien
JOIN MonHoc mh ON dk.ma_mon_hoc = mh.ma_mon_hoc
LEFT JOIN CCCD c ON sv.ma_sinh_vien = c.ma_sinh_vien
ORDER BY sv.nam_sinh DESC;



SELECT mh.ten_mon_hoc, COUNT(dk.ma_dang_ky) AS tong_dang_ky
FROM MonHoc mh
LEFT JOIN DangKy dk ON mh.ma_mon_hoc = dk.ma_mon_hoc
GROUP BY mh.ma_mon_hoc, mh.ten_mon_hoc;

SELECT kh.ten_khoa_hoc, COUNT(mh.ma_mon_hoc) AS so_mon
FROM KhoaHoc kh
LEFT JOIN MonHoc mh ON kh.ma_khoa_hoc = mh.ma_khoa_hoc
GROUP BY kh.ma_khoa_hoc, kh.ten_khoa_hoc;

SELECT sv.ten_sinh_vien, AVG(dk.diem_mon_hoc) AS diem_trung_binh
FROM SinhVien sv
JOIN DangKy dk ON sv.ma_sinh_vien = dk.ma_sinh_vien
GROUP BY sv.ma_sinh_vien, sv.ten_sinh_vien;

SELECT mh.ma_mon_hoc, mh.ten_mon_hoc, kh.ten_khoa_hoc
FROM MonHoc mh
JOIN KhoaHoc kh ON mh.ma_khoa_hoc = kh.ma_khoa_hoc
JOIN DangKy dk ON mh.ma_mon_hoc = dk.ma_mon_hoc
GROUP BY mh.ma_mon_hoc, mh.ten_mon_hoc, kh.ten_khoa_hoc
HAVING AVG(dk.diem_mon_hoc) > 5;

SELECT sv.ma_sinh_vien, sv.ten_sinh_vien, mh.ten_mon_hoc, dk.diem_mon_hoc
FROM DangKy dk
JOIN SinhVien sv ON dk.ma_sinh_vien = sv.ma_sinh_vien
JOIN MonHoc mh ON dk.ma_mon_hoc = mh.ma_mon_hoc
WHERE dk.diem_mon_hoc = (SELECT MAX(diem_mon_hoc) FROM DangKy);

SELECT sv.ma_sinh_vien, sv.ten_sinh_vien, (YEAR(CURDATE()) - sv.nam_sinh) AS tuoi, mh.ten_mon_hoc, kh.ten_khoa_hoc
FROM SinhVien sv
JOIN DangKy dk ON sv.ma_sinh_vien = dk.ma_sinh_vien
JOIN MonHoc mh ON dk.ma_mon_hoc = mh.ma_mon_hoc
JOIN KhoaHoc kh ON mh.ma_khoa_hoc = kh.ma_khoa_hoc
WHERE mh.ma_mon_hoc = (
    SELECT ma_mon_hoc 
    FROM DangKy 
    GROUP BY ma_mon_hoc 
    ORDER BY AVG(diem_mon_hoc) DESC 
    LIMIT 1
);