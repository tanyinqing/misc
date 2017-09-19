# 1. 创建数据库 db_library
DROP DATABASE IF EXISTS db_library;
CREATE DATABASE db_library;

SELECT * FROM mysql.user;
# 2. 创建数据库帐号为 library_admin，指定密码为 library_admin_password
CREATE USER library_admin@'localhost'
  IDENTIFIED BY 'library_admin_password';

-- SHOW GRANTS FOR library_admin@'localhost';
-- DROP USER library_admin@'localhost';
# 3. 向 library_admin 授予在 db_library 上的所有权限
USE db_library;
GRANT ALL ON db_library.* TO library_admin@'localhost';

# 4. 创建用户表
DROP TABLE IF EXISTS db_library.user;
CREATE TABLE db_library.user (
  id       INT AUTO_INCREMENT PRIMARY KEY
  COMMENT 'PK',
  username VARCHAR(255) NOT NULL
  COMMENT '用户名',
  password VARCHAR(255) NOT NULL
  COMMENT '密码',
  role     VARCHAR(255) NOT NULL
  COMMENT '角色'
)
  COMMENT '用户表';

# 5. 创建图书表
DROP TABLE IF EXISTS db_library.book;
CREATE TABLE db_library.book (
  id        INT AUTO_INCREMENT PRIMARY KEY
  COMMENT 'PK',
  title     VARCHAR(191) COMMENT '书名',
  author    VARCHAR(255) COMMENT '作者',
  publisher VARCHAR(255) COMMENT '出版社',
  date      DATE COMMENT '出版时间',
  pirce     DECIMAL(6, 2) COMMENT '定价',
  amount    INT COMMENT '存书量'
)
  COMMENT '图书表';

# 6. 创建用户借书表
DROP TABLE IF EXISTS db_library.user_book;
CREATE TABLE db_library.user_book (
  id         INT AUTO_INCREMENT PRIMARY KEY
  COMMENT 'PK',
  borrowTime DATETIME COMMENT '借书时间',
  returnTime DATETIME COMMENT '还书时间',
  userId     INT COMMENT 'FK',
  bookId     INT COMMENT 'FK'
)
  COMMENT '用户借书表';

# 7. 修改 user_book 表，追加外键
ALTER TABLE db_library.user_book
  ADD CONSTRAINT
  fk_user_book_userId
FOREIGN KEY (userId)
REFERENCES db_library.user (id);

ALTER TABLE db_library.user_book
  ADD CONSTRAINT
  fk_user_book_bookId
FOREIGN KEY (bookId)
REFERENCES db_library.book (id);

# 8. 向用户表添加一个管理员和三个读者记录
INSERT INTO db_library.user VALUES (NULL, 'admin', '123', 'admin');
INSERT INTO db_library.user VALUES (NULL, 'user1', '123', 'user');
INSERT INTO db_library.user VALUES (NULL, 'user2', '123', 'user');
INSERT INTO db_library.user VALUES (NULL, 'user3', '123', 'user');

# 9. 向图书表添加十条记录
INSERT INTO db_library.book VALUES (NULL, 'title0', 'author0', 'publisher0', '2017-1-20', 123.0, 100);
INSERT INTO db_library.book VALUES (NULL, 'title1', 'author1', 'publisher1', '2017-1-21', 123.1, 101);
INSERT INTO db_library.book VALUES (NULL, 'title2', 'author2', 'publisher2', '2017-1-22', 123.2, 102);
INSERT INTO db_library.book VALUES (NULL, 'title3', 'author3', 'publisher3', '2017-1-23', 123.3, 103);
INSERT INTO db_library.book VALUES (NULL, 'title4', 'author4', 'publisher4', '2017-1-24', 123.4, 104);
INSERT INTO db_library.book VALUES (NULL, 'title5', 'author5', 'publisher5', '2017-1-25', 123.5, 105);
INSERT INTO db_library.book VALUES (NULL, 'title6', 'author6', 'publisher6', '2017-1-26', 123.6, 106);
INSERT INTO db_library.book VALUES (NULL, 'title7', 'author7', 'publisher7', '2017-1-27', 123.7, 107);
INSERT INTO db_library.book VALUES (NULL, 'title8', 'author8', 'publisher8', '2017-1-28', 123.8, 108);
INSERT INTO db_library.book VALUES (NULL, 'title9', 'author9', 'publisher9', '2017-1-29', 123.9, 109);

# 10. 为图书名称添加索引
CREATE INDEX idx_title
  ON db_library.book (title);

# 11. 管理员登录判断语句
SELECT *
FROM db_library.user
WHERE username = 'admin' AND password = '123' AND user.role = 'admin';

# 12. 读者查询图书语句
SELECT *
FROM db_library.book
WHERE title LIKE '%title%';

# 13. 读者借阅图书语句
UPDATE db_library.book
SET amount = amount - 1
WHERE id = 1;

INSERT INTO db_library.user_book VALUES (NULL, current_time, NULL, 1, 1);

# 14. 读者归还图书语句
UPDATE db_library.book
SET amount = amount + 1
WHERE id = 1;

UPDATE db_library.user_book
SET returnTime = current_time
WHERE userId = 1 AND bookId = 1;

# 15. 读者查询自己的借阅记录语句
SELECT
  b.title,
  ub.borrowTime,
  ub.returnTime
FROM db_library.user u INNER JOIN db_library.book b
  INNER JOIN db_library.user_book ub
    ON u.id = ub.userId AND b.id = ub.bookId
WHERE u.id = 1;

# 16. 管理员查询图书借阅情况语句
SELECT
  u.username,
  b.title,
  ub.borrowTime,
  ub.returnTime
FROM db_library.user u INNER JOIN db_library.book b
  INNER JOIN db_library.user_book ub
    ON u.id = ub.userId AND b.id = ub.bookId;

# 17. 根据上题的查询，创建图书借阅视图
CREATE VIEW db_library.v_user_book
AS
  SELECT
    u.username,
    b.title,
    ub.borrowTime,
    ub.returnTime
  FROM db_library.user u INNER JOIN db_library.book b
    INNER JOIN db_library.user_book ub
      ON u.id = ub.userId AND b.id = ub.bookId;

# 18. 根据视图查询借阅情况语句
SELECT *
FROM db_library.v_user_book;

# 19. 删除视图
DROP VIEW db_library.v_user_book;

# 20. 删除图书名称索引
DROP INDEX idx_title
ON db_library.book;