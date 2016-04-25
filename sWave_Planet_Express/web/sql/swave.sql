SET GLOBAL max_allowed_packet=16*1024*1024;

-- Adds Unicode Support
SET CHARACTER SET utf8;
SET NAMES         utf8;

CREATE DATABASE IF NOT EXISTS SWAVE;
USE SWAVE;

DROP TABLE IF EXISTS ADS;
DROP TABLE IF EXISTS RADIO;
DROP TABLE IF EXISTS PLAYTRACKS;
DROP TABLE IF EXISTS PLAYLISTS;
DROP TABLE IF EXISTS ORDERSONG;
DROP TABLE IF EXISTS ORDERMERCH;
DROP TABLE IF EXISTS ORDERS;
DROP TABLE IF EXISTS SONGS;
DROP TABLE IF EXISTS MESSAGE;
DROP TABLE IF EXISTS MERCH;
DROP TABLE IF EXISTS TICKETS;
DROP TABLE IF EXISTS FRIEND;
DROP TABLE IF EXISTS USERS;

CREATE TABLE USERS (
    USERID     SMALLINT    NOT NULL AUTO_INCREMENT,
    USERNAME   VARCHAR(20) NOT NULL,
    EMAIL      VARCHAR(70) NOT NULL,
    FNAME      VARCHAR(20),
    LNAME      VARCHAR(20),
    PASSWD     VARCHAR(97) NOT NULL,
    ADD1       VARCHAR(30),
    ADD2       VARCHAR(30),
    CITY       VARCHAR(20),
    COUNTY     ENUM('CW', 'CN', 'CL', 'C', 'DL', 'D', 'G', 'K', 'KD', 'KK', 'LS', 'LM', 'LK', 'LF', 'L', 'M', 'MH', 'MO', 'O', 'R', 'S', 'T', 'WF', 'WM', 'WX', 'W'),
    SKIN       ENUM('swave', 'flat', 'flat darkness', 'nova', 'quantum', 'evolved', 'legacy', 'shire', 'smart', 'smart++', '1337', '9x') DEFAULT 'swave' NOT NULL,
    PICTURE    BLOB,
    ADMIN      BOOLEAN   NOT NULL DEFAULT false,
    CONSTRAINT PK_USERID PRIMARY KEY (USERID)
);

CREATE TABLE FRIEND (
    USERID         SMALLINT NOT NULL,
    FRIENDID       SMALLINT NOT NULL,
    FRIENDSHIPDATE DATE     NOT NULL,
    STATUS         CHAR(1)  NOT NULL DEFAULT 'p',
    CONSTRAINT  PK_FRIEND PRIMARY KEY(USERID, FRIENDID),
    CONSTRAINT  FK_FRIEND_USERID  FOREIGN KEY(USERID) REFERENCES USERS(USERID),
    CONSTRAINT  CHK_STATUS CHECK(STATUS IN ('c','p'))
);

CREATE TABLE MESSAGE (
    MSGID    SMALLINT NOT NULL AUTO_INCREMENT,
    SENDER   SMALLINT NOT NULL,
    RECEIVER SMALLINT NOT NULL,
    MSGDATE  DATE NOT NULL,
    CONTENT  VARCHAR(500) NOT NULL,
    STATUS   BOOLEAN NOT NULL DEFAULT false,
    CONSTRAINT PK_MSGID PRIMARY KEY(MSGID),
    CONSTRAINT FK_SENDER FOREIGN KEY(SENDER) REFERENCES USERS(USERID),
    CONSTRAINT FK_RECEIVER FOREIGN KEY(RECEIVER) REFERENCES USERS(USERID)
);

CREATE TABLE SONGS (
    SONGID    SMALLINT     NOT NULL AUTO_INCREMENT,
    FILENAME  VARCHAR(255) NOT NULL,
    TITLE     VARCHAR(255) NOT NULL,
    ARTIST    VARCHAR(255),
    ALBUM     VARCHAR(255),
    GENRE     VARCHAR(255),
    RELYEAR   YEAR,
    DURATION  INT          UNSIGNED,
    PRICE     FLOAT(3, 2)  UNSIGNED NOT NULL DEFAULT 2.99,
    LICENSE   VARCHAR(300) NOT NULL,
    PLAYCOUNT BIGINT       NOT NULL DEFAULT 0,
    UPLOADED  DATE,
    ARTWORK   MEDIUMBLOB,
    SONGDATA  MEDIUMBLOB,
    CONSTRAINT PK_SONGID PRIMARY KEY(SONGID)
);

CREATE TABLE MERCH (
    MERCHID SMALLINT    NOT NULL AUTO_INCREMENT,
    TITLE   VARCHAR(30) NOT NULL,
    PRICE   FLOAT(5, 2) UNSIGNED NOT NULL,
    THREED  VARCHAR(10),
    CONSTRAINT PK_MERCHID PRIMARY KEY(MERCHID)
);

CREATE TABLE ORDERS (
    ORDERID     SMALLINT    NOT NULL AUTO_INCREMENT,
    USERID      SMALLINT    NOT NULL,
    DATEORDERED DATE        NOT NULL,
    TOTAL       FLOAT(6, 2) UNSIGNED NOT NULL DEFAULT 0.00,
    CONSTRAINT  PK_ORDERID PRIMARY KEY(ORDERID),
    CONSTRAINT  FK_USERID  FOREIGN KEY(USERID) REFERENCES USERS(USERID)
);

CREATE TABLE ORDERSONG (
    ORDERID    SMALLINT     NOT NULL,
    SONGID     SMALLINT     NOT NULL,
    PRICEPAID  FLOAT(3, 2)  UNSIGNED NOT NULL DEFAULT 0.00,
    CONSTRAINT PK_ORDERSONG PRIMARY KEY(ORDERID, SONGID),
    CONSTRAINT FK_ORDERID   FOREIGN KEY(ORDERID) REFERENCES ORDERS(ORDERID),
    CONSTRAINT FK_SONGID    FOREIGN KEY(SONGID)  REFERENCES SONGS(SONGID)
);

CREATE TABLE ORDERMERCH (
    ORDERID    SMALLINT NOT NULL,
    MERCHID    SMALLINT NOT NULL,
    QTY        SMALLINT    UNSIGNED NOT NULL DEFAULT 1,
    PRICEPAID  FLOAT(5, 2) UNSIGNED NOT NULL DEFAULT 0.00,
    CUSTIMG    BLOB,
    CONSTRAINT PK_ORDERMERCH PRIMARY KEY(ORDERID, MERCHID),
    CONSTRAINT FK_ORDER_ID   FOREIGN KEY(ORDERID) REFERENCES ORDERS(ORDERID),
    CONSTRAINT FK_MERCHID    FOREIGN KEY(MERCHID) REFERENCES MERCH(MERCHID)
);

CREATE TABLE TICKETS (
    TICKETID    SMALLINT     NOT NULL AUTO_INCREMENT,
    USERID      SMALLINT     NOT NULL,
    ISSUE       VARCHAR(500) NOT NULL,
    DATERAISED  DATE         NOT NULL,
    RESOLVED    BOOLEAN      NOT NULL DEFAULT false,
    CONSTRAINT  PK_TICKETID PRIMARY KEY(TICKETID),
    CONSTRAINT  FK_USER     FOREIGN KEY(USERID) REFERENCES USERS(USERID)
);

CREATE TABLE ADS (
    ADID  TINYINT     NOT NULL AUTO_INCREMENT,
    ADURL VARCHAR(50) NOT NULL,
    CONSTRAINT PK_ADS PRIMARY KEY(ADID)
);

CREATE TABLE RADIO (
    RADIOID     SMALLINT NOT NULL AUTO_INCREMENT,
    STREAMURL   VARCHAR(100),
    TITLE       VARCHAR(30),
    DESCRIPTION VARCHAR(100),
    CONSTRAINT  PK_RADIOID PRIMARY KEY(RADIOID)
);

CREATE TABLE PLAYLISTS (
    PLAYLISTID SMALLINT    NOT NULL AUTO_INCREMENT,
    USERID     SMALLINT    NOT NULL,
    TITLE      VARCHAR(30) NOT NULL,
    CONSTRAINT PK_PLAYLISTID PRIMARY KEY(PLAYLISTID),
    CONSTRAINT FK_LISTENER   FOREIGN KEY(USERID) REFERENCES USERS(USERID)
);

CREATE TABLE PLAYTRACKS (
    SONGID        SMALLINT NOT NULL,
    PLAYLISTID    SMALLINT NOT NULL,
    PLAYLISTORDER SMALLINT NOT NULL,
    CONSTRAINT PK_PLAYTRACKS PRIMARY KEY(SONGID, PLAYLISTID),
    CONSTRAINT FK_THESONG    FOREIGN KEY(SONGID)     REFERENCES SONGS(SONGID),
    CONSTRAINT FK_PLAYLIST   FOREIGN KEY(PLAYLISTID) REFERENCES PLAYLISTS(PLAYLISTID)
);

/* TEST DATA */

INSERT INTO USERS VALUES (-1, "appelman", "ceo@banana.com", "Steev", "Jubs", "a20abc570d9b856d2b489d48b899cd252454e9ea017ac130$1bdded0391ecaafea329ec8c5609e9edb5a6afab64b8f3a4", "1 hello", "Some Street", "New Yorko", "CN", "flat", null, false);
INSERT INTO USERS VALUES (-2, "dj_man", "admin@swave.com", "DJ", "sWave", "a20abc570d9b856d2b489d48b899cd252454e9ea017ac130$1bdded0391ecaafea329ec8c5609e9edb5a6afab64b8f3a4", "kek", "lel", "Dublin", "K", "swave", null, true);
INSERT INTO USERS VALUES (1, "colonelPanic", "m'lady@neckbeard.com", "Todd", "Beardsley", "a20abc570d9b856d2b489d48b899cd252454e9ea017ac130$1bdded0391ecaafea329ec8c5609e9edb5a6afab64b8f3a4", "The Basement", "Moms House", "Neo Tokyo", "D", "1337", null, false);
INSERT INTO USERS VALUES (2, "hereComesDaPane", "ceo@macrohard.com", "Gill", "Bates", "a20abc570d9b856d2b489d48b899cd252454e9ea017ac130$1bdded0391ecaafea329ec8c5609e9edb5a6afab64b8f3a4", "23 unhello", "Other Street", "South Cali", "CN", "flat", null, false);
INSERT INTO USERS VALUES (3, "croak&dagger", "feels@goodman.com", "Pepe", "Frog", "a20abc570d9b856d2b489d48b899cd252454e9ea017ac130$1bdded0391ecaafea329ec8c5609e9edb5a6afab64b8f3a4", "Smackdown Hotel", "Jabroni Drive", "Know Your Role Boulevard", "CN", "flat", null, false);
INSERT INTO USERS VALUES (4, "cymbolic", "widerthan@mile.com", "Moon", "River", "a20abc570d9b856d2b489d48b899cd252454e9ea017ac130$1bdded0391ecaafea329ec8c5609e9edb5a6afab64b8f3a4", "Round The Bend", "Rainbows End", "Mississippi", "C", "flat", null, false);
INSERT INTO USERS VALUES (5, "suiteserenity", "hippiedaze@dmt.com", "Sage", "Sapphire", "a20abc570d9b856d2b489d48b899cd252454e9ea017ac130$1bdded0391ecaafea329ec8c5609e9edb5a6afab64b8f3a4", "7 Heaven", "The Walls Are Melting", "San Diego", "G", "flat", null, false);


INSERT INTO FRIEND VALUES(-1,-2,'1970-1-1','c');
INSERT INTO FRIEND VALUES(-1,2,'2015-1-1','c');
INSERT INTO FRIEND VALUES(2,1,'1990-1-1','c');
INSERT INTO FRIEND VALUES(2,-2,'2016-1-1','p');
INSERT INTO FRIEND VALUES(3,5,'2016-4-1','p');

INSERT INTO SONGS VALUES (-1, "Track 1", "Title", "Artist", "Album", "Genre", 1970, 420, 2.99, "Public Domain", 0, NULL, NULL, NULL);

INSERT INTO ORDERS VALUES (-1, -1, '1970-1-1', 15.50);
INSERT INTO ORDERS VALUES (-2, -2, '1971-1-1', 16.20);
INSERT INTO ORDERS VALUES (-3, -1, '1972-1-1', 0.00);
INSERT INTO ORDERS VALUES (-4, -1, '1975-1-1', 0.00);

INSERT INTO ORDERSONG VALUES(-1, -1, 5.51);
INSERT INTO ORDERSONG VALUES(-4, -1, 5.99);
INSERT INTO ORDERSONG VALUES(-2, -1, 5.99);

INSERT INTO PLAYLISTS  VALUES(-1, -1, 'test1');
INSERT INTO PLAYLISTS  VALUES(-2, -2, 'My Little Playlist');
INSERT INTO PLAYTRACKS VALUES(-1, -2, 0);

INSERT INTO ADS VALUES (1, "ads/test.html");
INSERT INTO ADS VALUES (2, "ads/test2.html");

INSERT INTO RADIO VALUES (1, "Lainchan Radio", "https://lainchan.org/radio_assets/lain.mp3", "Lainchan.org's Cyberpunk Radio Stream");

INSERT INTO TICKETS VALUES (-1, -1, "my pc is on fire", "2009-12-3", false);

INSERT INTO MERCH VALUES(-1, "Mug", 9.99, NULL);
INSERT INTO MERCH VALUES(-2, "T-Shirt", 29.99, NULL);
INSERT INTO MERCH VALUES(1, "sWave Headphones", 34.99, NULL);
INSERT INTO MERCH VALUES(2, "1/4 inch Jack Cable", 1.99, NULL);
INSERT INTO MERCH VALUES(3, "So-knee Boombox Audio System", 239.90, NULL);
INSERT INTO MERCH VALUES(4, "So-Knee Wireless Speaker", 64.99, NULL);
INSERT INTO MERCH VALUES(5, "sWave: Behind The Music DVD", 19.99, NULL);
INSERT INTO MERCH VALUES(6, "Banana Y-Pod Nano", 199.50, NULL);

INSERT INTO ORDERMERCH VALUES(-1, -1, 1, 9.99, NULL);
INSERT INTO ORDERMERCH VALUES(-3, -1, 1, 8.50, NULL);

INSERT INTO MESSAGE VALUES(-1,-1,-2,"2009-12-3","oh hai mark!",false);
