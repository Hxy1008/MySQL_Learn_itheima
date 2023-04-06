/*
 Navicat Premium Data Transfer

 Source Server         : conn-localhost
 Source Server Type    : MySQL
 Source Server Version : 80025
 Source Host           : localhost:3306
 Source Schema         : mydb6_view

 Target Server Type    : MySQL
 Target Server Version : 80025
 File Encoding         : 65001

 Date: 14/10/2021 11:39:07
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for dept
-- ----------------------------
DROP TABLE IF EXISTS `dept`;
CREATE TABLE `dept`  (
  `deptno` int NOT NULL,
  `dname` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `loc` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`deptno`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of dept
-- ----------------------------
INSERT INTO `dept` VALUES (10, '教研部', '北京');
INSERT INTO `dept` VALUES (20, '学工部', '上海');
INSERT INTO `dept` VALUES (30, '销售部', '广州');
INSERT INTO `dept` VALUES (40, '财务部', '武汉');

-- ----------------------------
-- Table structure for emp
-- ----------------------------
DROP TABLE IF EXISTS `emp`;
CREATE TABLE `emp`  (
  `empno` int NOT NULL,
  `ename` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `job` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `mgr` int NULL DEFAULT NULL,
  `hiredate` date NULL DEFAULT NULL,
  `sal` decimal(7, 2) NULL DEFAULT NULL,
  `COMM` decimal(7, 2) NULL DEFAULT NULL,
  `deptno` int NULL DEFAULT NULL,
  PRIMARY KEY (`empno`) USING BTREE,
  INDEX `fk_emp`(`mgr`) USING BTREE,
  CONSTRAINT `fk_emp` FOREIGN KEY (`mgr`) REFERENCES `emp` (`empno`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of emp
-- ----------------------------
INSERT INTO `emp` VALUES (1001, '甘宁', '文员', 1013, '2000-12-17', 8000.00, NULL, 20);
INSERT INTO `emp` VALUES (1002, '黛绮丝', '销售员', 1006, '2001-02-20', 16000.00, 3000.00, 30);
INSERT INTO `emp` VALUES (1003, '殷天正', '销售员', 1006, '2001-02-22', 12500.00, 5000.00, 30);
INSERT INTO `emp` VALUES (1004, '刘备', '经理', 1009, '2001-04-02', 29750.00, NULL, 20);
INSERT INTO `emp` VALUES (1005, '谢逊', '销售员', 1006, '2001-09-28', 12500.00, 14000.00, 30);
INSERT INTO `emp` VALUES (1006, '关羽', '经理', 1009, '2001-05-01', 28500.00, NULL, 30);
INSERT INTO `emp` VALUES (1007, '张飞', '经理', 1009, '2001-09-01', 24500.00, NULL, 10);
INSERT INTO `emp` VALUES (1008, '诸葛亮', '分析师', 1004, '2007-04-19', 30000.00, NULL, 20);
INSERT INTO `emp` VALUES (1009, '曾阿牛', '董事长', NULL, '2001-11-17', 50000.00, NULL, 10);
INSERT INTO `emp` VALUES (1010, '韦一笑', '销售员', 1006, '2001-09-08', 15000.00, 0.00, 30);
INSERT INTO `emp` VALUES (1011, '周泰', '文员', 1008, '2007-05-23', 11000.00, NULL, 20);
INSERT INTO `emp` VALUES (1012, '程普', '文员', 1006, '2001-12-03', 9500.00, NULL, 30);
INSERT INTO `emp` VALUES (1013, '庞统', '分析师', 1004, '2001-12-03', 30000.00, NULL, 20);
INSERT INTO `emp` VALUES (1014, '黄盖', '文员', 1007, '2002-01-23', 13000.00, NULL, 10);

-- ----------------------------
-- Table structure for salgrade
-- ----------------------------
DROP TABLE IF EXISTS `salgrade`;
CREATE TABLE `salgrade`  (
  `grade` int NOT NULL,
  `losal` int NULL DEFAULT NULL,
  `hisal` int NULL DEFAULT NULL,
  PRIMARY KEY (`grade`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of salgrade
-- ----------------------------
INSERT INTO `salgrade` VALUES (1, 7000, 12000);
INSERT INTO `salgrade` VALUES (2, 12010, 14000);
INSERT INTO `salgrade` VALUES (3, 14010, 20000);
INSERT INTO `salgrade` VALUES (4, 20010, 30000);
INSERT INTO `salgrade` VALUES (5, 30010, 99990);

SET FOREIGN_KEY_CHECKS = 1;
