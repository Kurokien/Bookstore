-- Disable foreign key checks temporarily (useful for Supabase migrations)
SET session_replication_role = 'replica';

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS category;
CREATE TABLE category (
                          category_id BIGINT NOT NULL,
                          category_name VARCHAR(255),
                          PRIMARY KEY (category_id)
);

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO category VALUES
                         (1, 'Sách văn học'),
                         (2, 'Sách khoa học'),
                         (3, 'Sách thiếu nhi'),
                         (4, 'Sách kỹ năng'),
                         (5, 'Sách ngoại ngữ');

-- ----------------------------
-- Table structure for product
-- ----------------------------
DROP TABLE IF EXISTS product;
CREATE TABLE product (
                         product_id BIGINT NOT NULL,
                         category_id BIGINT,
                         product_name VARCHAR(255),
                         product_image VARCHAR(255),
                         product_price DOUBLE PRECISION,
                         product_description TEXT,
                         quantity INTEGER,
                         PRIMARY KEY (product_id),
                         CONSTRAINT fk_product_category FOREIGN KEY (category_id)
                             REFERENCES category(category_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ----------------------------
-- Records of product
-- ----------------------------
INSERT INTO product (product_id, category_id, product_name, product_image, product_price, product_description, quantity) VALUES
                                                                                                                             (1, 1, 'Nhà giả kim', 'images/nhagiakim.jpg', 86000, 'Tiểu thuyết kinh điển', 100),
                                                                                                                             (2, 1, 'Tuổi trẻ đáng giá bao nhiêu', 'images/tuoitredanggiabaonhieu.jpg', 91000, 'Sách truyền cảm hứng', 100),
                                                                                                                             (3, 1, 'Chí Phèo', 'images/chipheo.jpg', 57000, 'Truyện Việt nổi tiếng', 100),
                                                                                                                             (4, 1, 'Dế mèn phiêu lưu ký', 'images/demenphieuluky.jpg', 60000, 'Truyện thiếu nhi Việt', 100),
                                                                                                                             (5, 1, 'Tắt đèn', 'images/tatden.jpg', 55000, 'Tiểu thuyết hiện thực', 100),
                                                                                                                             (6, 1, 'Số đỏ', 'images/sodo.jpg', 67000, 'Tác phẩm kinh điển', 100),
                                                                                                                             (7, 1, 'Bắt trẻ đồng xanh', 'images/battredongxanh.jpg', 99000, 'Tiểu thuyết nổi tiếng', 100),
                                                                                                                             (8, 1, 'Điều kỳ diệu của tiệm tạp hóa Namiya', 'images/tiemtaphoanamiya.jpg', 87000, 'Truyện cảm động', 100),
                                                                                                                             (9, 1, 'Cánh đồng bất tận', 'images/canhdongbattan.jpg', 68000, 'Tập truyện ngắn hay', 100),
                                                                                                                             (10, 1, 'Người trong muôn nghề', 'images/nguoitrongmuonnghe.jpg', 85000, 'Tiểu thuyết hiện đại', 100),
                                                                                                                             (11, 1, 'Mắt biếc', 'images/matORIA.jpg', 89000, 'Truyện tình nổi tiếng', 100),
                                                                                                                             (12, 1, 'Kính vạn hoa', 'images/kinhvanhoa.jpg', 83000, 'Truyện thiếu nhi vui', 100),
                                                                                                                             (13, 1, 'Cho tôi xin một vé đi tuổi thơ', 'images/chotoixinmotve.jpg', 91000, 'Truyện tuổi thơ', 100),
                                                                                                                             (14, 1, 'Trăm năm cô đơn', 'images/tramnamcodon.jpg', 116000, 'Kiệt tác văn học', 100),
                                                                                                                             (15, 1, 'Những người khốn khổ', 'images/nhungnguoikhonkho.jpg', 115000, 'Tiểu thuyết vĩ đại', 100),
                                                                                                                             (16, 1, 'Giết con chim nhại', 'images/gietconchimnhai.jpg', 98000, 'Truyện nhân văn', 100),
                                                                                                                             (17, 1, 'Đồi gió hú', 'images/doigiohu.jpg', 92000, 'Tiểu thuyết cổ điển', 100),
                                                                                                                             (18, 1, 'Những người hàng xóm', 'images/nhungnguoihangxom.jpg', 80000, 'Truyện ngắn Việt', 100),
                                                                                                                             (19, 1, 'Vợ nhặt', 'images/vonhat.jpg', 55000, 'Truyện ngắn hay', 100),
                                                                                                                             (20, 1, 'Bố già', 'images/bogia.jpg', 112000, 'Tiểu thuyết kinh điển', 100),
                                                                                                                             (1748702330289, 1, 'Tiếng chim hót trong bụi mận gai', 'images/tiengchimhottrongbuimangai.jpg', 130000, 'Tiểu thuyết lãng mạn', 100),
                                                                                                                             (1748702330290, 1, 'Đứa trẻ thứ 44', 'images/duatrethu44.jpg', 87000, 'Tiểu thuyết trinh thám', 100),
                                                                                                                             (1748702330291, 1, 'Phố của người', 'images/phocuanguoi.jpg', 82000, 'Truyện Việt Nam hiện đại', 100),
                                                                                                                             (1748702330292, 1, 'Không gia đình', 'images/khonggiadinh.jpg', 90000, 'Tiểu thuyết kinh điển', 100),
                                                                                                                             (1748702330293, 1, 'Lão Hạc', 'images/laohac.jpg', 54000, 'Truyện ngắn nổi tiếng', 100),
                                                                                                                             (1748702330294, 1, 'Cô gái đến từ hôm qua', ' accurate', 89000, 'Truyện thanh xuân Việt', 100),
                                                                                                                             (1748702330295, 1, 'Người lái đò sông Đà', 'images/nguoilaidosongda.jpg', 79000, 'Tùy bút đặc sắc', 100),
                                                                                                                             (1748702330296, 1, 'Chiếc lược ngà', 'images/chiecluocnga.jpg', 61000, 'Truyện ngắn cảm động', 100),
                                                                                                                             (1748702330297, 1, 'Ông già và biển cả', 'images/onggiavabienca.jpg', 110000, 'Tiểu thuyết nổi tiếng', 100),
                                                                                                                             (1748702330298, 1, 'Người mẹ', 'images/nguoime.jpg', 102000, 'Tiểu thuyết Nga kinh điển', 100),
                                                                                                                             (1748702330299, 1, 'Chuyện người tùy nữ', 'images/chuyennguoituynu.jpg', 87000, 'Truyện ngắn hay', 100),
                                                                                                                             (1748702330300, 1, 'Ánh sáng thành phố', 'images/anhsangthanhpho.jpg', 77000, 'Truyện hiện đại Việt', 100),
                                                                                                                             (1748702330301, 1, 'Hoa cúc vàng trên đầm lầy', 'images/hoacucvangtrendamlay.jpg', 88000, 'Truyện ngắn nhẹ nhàng', 100),
                                                                                                                             (1748702330302, 1, 'Một thoáng ta rực rỡ ở nhân gian', 'images/motthoangtarucro.jpg', 95000, 'Truyện ngắn sâu sắc', 100),
                                                                                                                             (1748702330303, 1, 'Em sẽ đến cùng cơn mưa', 'images/emsedencungconmua.jpg', 85000, 'Tiểu thuyết cảm động', 100),
                                                                                                                             (1748702330304, 1, 'Sống mòn', 'images/songmon.jpg', 66000, 'Tiểu thuyết hiện thực', 100),
                                                                                                                             (1748702330305, 1, 'Con chim xanh biếc bay về', 'images/conchimxanhbiecbayve.jpg', 79000, 'Truyện tình cảm nhẹ nhàng', 100),
                                                                                                                             (1748702330306, 1, 'Chuyện xứ Lang Biang', 'images/chuyenxulangbiang.jpg', 86000, 'Truyện phiêu lưu', 100),
                                                                                                                             (1748702330307, 1, 'Tôi thấy hoa vàng trên cỏ xanh', 'images/toithayhoavangtrencoxanh.jpg', 92000, 'Truyện thanh xuân đẹp', 100),
                                                                                                                             (1748702330308, 1, 'Nhật ký Đặng Thùy Trâm', 'images/nhatkydangthuytram.jpg', 73000, 'Nhật ký cảm động', 100);

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS users;
CREATE TABLE users (
                       user_id BIGINT NOT NULL,
                       user_email VARCHAR(255) NOT NULL,
                       user_fullname VARCHAR(255),
                       user_phone VARCHAR(20),
                       user_address TEXT,
                       user_country VARCHAR(100),
                       user_pass VARCHAR(255) NOT NULL,
                       user_role BOOLEAN DEFAULT FALSE,
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       PRIMARY KEY (user_id),
                       CONSTRAINT idx_user_email UNIQUE (user_email),
                       CONSTRAINT check_user_role CHECK (user_role IN (FALSE, TRUE))
);

CREATE INDEX idx_user_role ON users (user_role);
CREATE INDEX idx_created_at ON users (created_at);

COMMENT ON TABLE users IS 'Bảng người dùng với thông tin đầy đủ';

-- Trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
    RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO users (user_id, user_email, user_fullname, user_phone, user_address, user_country, user_pass, user_role, created_at, updated_at) VALUES
                                                                                                                                                 (1, 'admin@bookstore.com', 'Administrator', '+84 123-456-789', '123 Admin Street, District 1, Ho Chi Minh City', 'Vietnam', '0192023a7bbd73250516f069df18b500', TRUE, '2025-05-31 17:24:52', '2025-05-31 17:24:52'),
                                                                                                                                                 (1463056081950, 'john.doe@gmail.com', 'John Doe', '+1 555-123-4567', '123 Main Street, New York, NY 10001', 'United States', 'e10adc3949ba59abbe56e057f20f883e', FALSE, '2025-05-31 17:24:52', '2025-05-31 17:24:52'),
                                                                                                                                                 (1463056081951, 'jane.smith@gmail.com', 'Jane Smith', '+1 555-987-6543', '456 Oak Avenue, Los Angeles, CA 90210', 'United States', 'e10adc3949ba59abbe56e057f20f883e', FALSE, '2025-05-31 17:24:52', '2025-05-31 17:24:52'),
                                                                                                                                                 (1463056081952, 'truongtungduong9x@gmail.com', 'Truong Tung Duong', '+84 987-654-321', '456 Customer Street, District 3, Ho Chi Minh City', 'Vietnam', '827ccb0eea8a706c4c34a16891f84e7b', FALSE, '2025-05-31 17:24:52', '2025-05-31 17:24:52'),
                                                                                                                                                 (1463056081953, 'blogkenhlaptrinh@gmail.com', 'Kenh Lap Trinh', '+84 555-123-456', '789 Developer Avenue, District 7, Ho Chi Minh City', 'Vietnam', '827ccb0eea8a706c4c34a16891f84e7b', FALSE, '2025-05-31 17:24:52', '2025-05-31 17:24:52'),
                                                                                                                                                 (1463056081954, 'nguyen.van.a@gmail.com', 'Nguyen Van A', '+84 909-123-456', '123 Nguyen Trai Street, District 5, Ho Chi Minh City', 'Vietnam', '482c811da5d5b4bc6d497ffa98491e38', FALSE, '2025-05-31 17:24:52', '2025-05-31 17:24:52'),
                                                                                                                                                 (1463056081955, 'le.thi.b@gmail.com', 'Le Thi B', '+84 908-987-654', '456 Le Loi Boulevard, District 1, Ho Chi Minh City', 'Vietnam', '482c811da5d5b4bc6d497ffa98491e38', FALSE, '2025-05-31 17:24:52', '2025-05-31 17:24:52'),
                                                                                                                                                 (1463056081956, 'david.wilson@yahoo.com', 'David Wilson', '+44 20-7123-4567', '10 Downing Street, London SW1A 2AA', 'United Kingdom', '34819d7beeabb9260a5c854bc85b3e44', FALSE, '2025-05-31 17:24:52', '2025-05-31 17:24:52'),
                                                                                                                                                 (1463056081957, 'maria.garcia@hotmail.com', 'Maria Garcia', '+34 91-123-4567', 'Calle Mayor 1, 28013 Madrid', 'Spain', '6637b58a3fbb2d6735e57e4135b1e6a5', FALSE, '2025-05-31 17:24:52', '2025-05-31 17:24:52'),
                                                                                                                                                 (1463056081958, 'test.user@bookstore.com', 'Test User', '+84 999-888-777', 'Test Address, Test District, Test City', 'Vietnam', 'cc03e747a6afbbcbf8be7668acfebee5', FALSE, '2025-05-31 17:24:52', '2025-05-31 17:24:52'),
                                                                                                                                                 (1748713487931, '1@gmail.com', '1', '1234567891', '1', 'Vietnam', 'e10adc3949ba59abbe56e057f20f883e', FALSE, '2025-05-31 17:44:47', '2025-05-31 17:44:47');

-- ----------------------------
-- Table structure for bill
-- ----------------------------
DROP TABLE IF EXISTS bill;
CREATE TABLE bill (
                      bill_id BIGINT NOT NULL,
                      user_id BIGINT,
                      total DOUBLE PRECISION,
                      payment VARCHAR(255),
                      address TEXT,
                      date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                      PRIMARY KEY (bill_id),
                      CONSTRAINT fk_bill_user FOREIGN KEY (user_id)
                          REFERENCES users(user_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ----------------------------
-- Records of bill
-- ----------------------------
INSERT INTO bill (bill_id, user_id, total, payment, address, date) VALUES
                                                                       ('1463295350519', '1463056081952', 13, 'Live', '123 - Q1 - TPHCM', '2016-05-15 13:55:50'),
                                                                       ('1463297481103', '1463056081950', 7, 'Bank transfer', '123 - Q1 - TPHCM', '2016-05-15 14:31:21');

-- ----------------------------
-- Table structure for bill_detail
-- ----------------------------
DROP TABLE IF EXISTS bill_detail;
CREATE TABLE bill_detail (
                             bill_detail_id BIGSERIAL NOT NULL,
                             bill_id BIGINT,
                             product_id BIGINT,
                             price DOUBLE PRECISION,
                             quantity INTEGER,
                             PRIMARY KEY (bill_detail_id),
                             CONSTRAINT fk_bill_detail_bill FOREIGN KEY (bill_id)
                                 REFERENCES bill(bill_id) ON DELETE CASCADE ON UPDATE CASCADE,
                             CONSTRAINT fk_bill_detail_product FOREIGN KEY (product_id)
                                 REFERENCES product(product_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ----------------------------
-- Records of bill_detail
-- ----------------------------
INSERT INTO bill_detail (bill_detail_id, bill_id, product_id, price, quantity) VALUES
                                                                                   (4, '1463295350519', 1, 2, 1),
                                                                                   (5, '1463295350519', 2, 3, 1),
                                                                                   (6, '1463295350519', 3, 4, 2),
                                                                                   (7, '1463297481103', 1, 2, 2),
                                                                                   (8, '1463297481103', 2, 3, 1);

-- Re-enable foreign key checks
SET session_replication_role = 'origin';