-- Active: 1747891146046@@127.0.0.1@3306@shop


SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for bill
-- ----------------------------
DROP TABLE IF EXISTS `bill`;
CREATE TABLE `bill` (
  `bill_id` bigint(20) NOT NULL,
  `user_id` bigint(20) default NULL,
  `total` double default NULL,
  `payment` varchar(255) collate utf8_unicode_ci default NULL,
  `address` longtext collate utf8_unicode_ci,
  `date` timestamp NULL default NULL on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`bill_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of bill
-- ----------------------------
INSERT INTO `bill` VALUES ('1463295350519', '1463056081952', '13', 'Live', '123 - Q1 - TPHCM', '2016-05-15 13:55:50');
INSERT INTO `bill` VALUES ('1463297481103', '1463056081950', '7', 'Bank transfer', '123 - Q1 - TPHCM', '2016-05-15 14:31:21');

-- ----------------------------
-- Table structure for bill_detail
-- ----------------------------
DROP TABLE IF EXISTS `bill_detail`;
CREATE TABLE `bill_detail` (
  `bill_detail_id` bigint(20) NOT NULL auto_increment,
  `bill_id` bigint(20) default NULL,
  `product_id` bigint(20) default NULL,
  `price` double default NULL,
  `quantity` int(11) default NULL,
  PRIMARY KEY  (`bill_detail_id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of bill_detail
-- ----------------------------
INSERT INTO `bill_detail` VALUES ('4', '1463295350519', '1', '2', '1');
INSERT INTO `bill_detail` VALUES ('5', '1463295350519', '2', '3', '1');
INSERT INTO `bill_detail` VALUES ('6', '1463295350519', '3', '4', '2');
INSERT INTO `bill_detail` VALUES ('7', '1463297481103', '1', '2', '2');
INSERT INTO `bill_detail` VALUES ('8', '1463297481103', '2', '3', '1');

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
  `category_id` bigint(11) NOT NULL,
  `category_name` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES ('1', 'Name 1');
INSERT INTO `category` VALUES ('2', 'Name 2');
INSERT INTO `category` VALUES ('3', 'Name 3');

-- ----------------------------
-- Table structure for product
-- ----------------------------
DROP TABLE IF EXISTS `product`;
CREATE TABLE `product` (
  `product_id` bigint(20) NOT NULL,
  `category_id` bigint(20) default NULL,
  `product_name` varchar(255) collate utf8_unicode_ci default NULL,
  `product_image` varchar(255) collate utf8_unicode_ci default NULL,
  `product_price` double default NULL,
  `product_description` longtext collate utf8_unicode_ci,
  PRIMARY KEY  (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of product
-- ----------------------------
INSERT INTO `product` VALUES ('1', '1', 'product 1', 'images/pi1.jpg', '2', 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.');
INSERT INTO `product` VALUES ('2', '1', 'product 2', 'images/pi2.jpg', '3', 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.');
INSERT INTO `product` VALUES ('3', '1', 'product 3', 'images/pi3.jpg', '4', 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.');
INSERT INTO `product` VALUES ('4', '1', 'product 4', 'images/pi3.jpg', '4', 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.');
INSERT INTO `product` VALUES ('5', '1', 'product 5', 'images/pi3.jpg', '4', 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.');
INSERT INTO `product` VALUES ('6', '1', 'product 6', 'images/pi3.jpg', '4', 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.');
INSERT INTO `product` VALUES ('7', '1', 'product 7', 'images/pi3.jpg', '4', 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.');
INSERT INTO `product` VALUES ('8', '1', 'product 8', 'images/pi3.jpg', '4', 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.');
INSERT INTO `product` VALUES ('9', '1', 'product 9', 'images/pi3.jpg', '4', 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.');
INSERT INTO `product` VALUES ('10', '1', 'product 10', 'images/pi3.jpg', '4', 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.');
INSERT INTO `product` VALUES ('11', '1', 'product 11', 'images/pi3.jpg', '4', 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `user_id` bigint(20) NOT NULL,
  `user_email` varchar(255) collate utf8_unicode_ci default NULL,
  `user_pass` varchar(255) collate utf8_unicode_ci default NULL,
  `user_role` bit(1) default NULL,
  PRIMARY KEY  (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('1463056081950', 'truongtungduong9x@gmail.com', '827ccb0eea8a706c4c34a16891f84e7b', '\0');
INSERT INTO `users` VALUES ('1463056081952', 'blogkenhlaptrinh@gmail.com', '827ccb0eea8a706c4c34a16891f84e7b', '\0');
