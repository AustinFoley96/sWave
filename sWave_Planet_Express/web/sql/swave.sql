CREATE DATABASE IF NOT EXISTS SWAVE;
USE SWAVE;

DROP TABLE IF EXISTS PLAYTRACKS;
DROP TABLE IF EXISTS PLAYLISTS;
DROP TABLE IF EXISTS ORDERSONG;
DROP TABLE IF EXISTS ORDERMERCH;
DROP TABLE IF EXISTS ORDERS;
DROP TABLE IF EXISTS LOCKS;
DROP TABLE IF EXISTS SONGS;
DROP TABLE IF EXISTS MERCH;
DROP TABLE IF EXISTS TICKETS;
DROP TABLE IF EXISTS USERS;
DROP TABLE IF EXISTS ADS;

CREATE TABLE USERS (
    USERID     INT(5)      NOT NULL AUTO_INCREMENT,
    USERNAME   VARCHAR(20) NOT NULL,
    EMAIL      VARCHAR(70) NOT NULL,
    FNAME      VARCHAR(20),
    LNAME      VARCHAR(20),
    PASSWD     VARCHAR(97) NOT NULL,
    ADD1       VARCHAR(30),
    ADD2       VARCHAR(30),
    CITY       VARCHAR(20),
    COUNTY     VARCHAR(20),
    SKIN       VARCHAR(10),
    ADMIN      BOOLEAN     NOT NULL,
    CONSTRAINT PK_USERID   PRIMARY KEY (USERID)
);

CREATE TABLE SONGS (
    SONGID  INT(4)       NOT NULL AUTO_INCREMENT,
    TITLE   VARCHAR(20)  NOT NULL,
    ARTIST  VARCHAR(30),
    GENRE   VARCHAR(20),
    RELYEAR INT(4),
    PRICE   DOUBLE(3,2)  NOT NULL,
    LICENSE VARCHAR(300) NOT NULL,
    DATA    MEDIUMBLOB,
    CONSTRAINT PK_SONGID PRIMARY KEY(SONGID)
);

CREATE TABLE MERCH (
    MERCHID INT(4)      NOT NULL AUTO_INCREMENT,
    TITLE   VARCHAR(20) NOT NULL,
    PRICE   DOUBLE(3,2) NOT NULL,
    CONSTRAINT PK_MERCHID PRIMARY KEY(MERCHID)
);

CREATE TABLE ORDERS (
    ORDERID     INT(4)       NOT NULL AUTO_INCREMENT,
    USERID      INT(5)       NOT NULL,
    DATEORDERED DATE         NOT NULL,
    TOTAL       DOUBLE(6,2)  NOT NULL,
    CONSTRAINT  PK_ORDERID PRIMARY KEY(ORDERID),
    CONSTRAINT  FK_USERID  FOREIGN KEY(USERID) REFERENCES USERS(USERID)
);

CREATE TABLE ORDERSONG (
    ORDERID    INT(4) NOT NULL,
    SONGID     INT(4) NOT NULL,
    PRICEPAID  DOUBLE(3,2) NOT NULL,
    CONSTRAINT PK_ORDERSONG PRIMARY KEY(ORDERID, SONGID),
    CONSTRAINT FK_ORDERID   FOREIGN KEY(ORDERID) REFERENCES ORDERS(ORDERID),
    CONSTRAINT FK_SONGID    FOREIGN KEY(SONGID)  REFERENCES SONGS(SONGID)
);

CREATE TABLE ORDERMERCH (
    ORDERID    INT(4)      NOT NULL,
    MERCHID    INT(4)      NOT NULL,
    QTY        INT(3)      NOT NULL,
    PRICEPAID  DOUBLE(3,2) NOT NULL,
    CONSTRAINT PK_ORDERMERCH PRIMARY KEY(ORDERID, MERCHID),
    CONSTRAINT FK_ORDER_ID   FOREIGN KEY(ORDERID) REFERENCES ORDERS(ORDERID),
    CONSTRAINT FK_MERCHID    FOREIGN KEY(MERCHID)  REFERENCES MERCH(MERCHID)
);

CREATE TABLE TICKETS (
    TICKETID    INT(5)       NOT NULL AUTO_INCREMENT,
    USERID      INT(5)       NOT NULL,
    ISSUE       VARCHAR(500) NOT NULL,
    DATERAISED  DATE         NOT NULL,
    RESOLVED    BOOLEAN      NOT NULL,
    CONSTRAINT  PK_TICKETID PRIMARY KEY(TICKETID),
    CONSTRAINT  FK_USER     FOREIGN KEY(USERID) REFERENCES USERS(USERID)
);

CREATE TABLE ADS (
    ADID  INT(2)      NOT NULL AUTO_INCREMENT,
    ADURL VARCHAR(50) NOT NULL,
    CONSTRAINT PK_ADS PRIMARY KEY(ADID)
);

CREATE TABLE PLAYLISTS (
    PLAYLISTID INT(5)      NOT NULL AUTO_INCREMENT,
    USERID     INT(5)      NOT NULL,
    TITLE      VARCHAR(30) NOT NULL,
    CONSTRAINT PK_PLAYLISTID PRIMARY KEY(PLAYLISTID),
    CONSTRAINT FK_LISTENER   FOREIGN KEY(USERID) REFERENCES USERS(USERID)
);

CREATE TABLE PLAYTRACKS (
    SONGID     INT(4) NOT NULL,
    PLAYLISTID INT(5) NOT NULL,
    CONSTRAINT PK_PLAYTRACKS PRIMARY KEY(SONGID, PLAYLISTID),
    CONSTRAINT FK_THESONG    FOREIGN KEY(SONGID)     REFERENCES SONGS(SONGID),
    CONSTRAINT FK_PLAYLIST   FOREIGN KEY(PLAYLISTID) REFERENCES PLAYLISTS(PLAYLISTID)
);

CREATE TABLE LOCKS (
    USERID   INT(5) NOT NULL,
    SONGID   INT(4) NOT NULL,
    LOCKTIME BIGINT NOT NULL,
    CONSTRAINT PK_LOCKS      PRIMARY KEY(USERID, SONGID),
    CONSTRAINT FK_LOCKS_USER FOREIGN KEY(USERID) REFERENCES USERS(USERID),
    CONSTRAINT FK_LOCKS_SONG FOREIGN KEY(SONGID) REFERENCES SONGS(SONGID)
);

/* TEST DATA */

INSERT INTO USERS VALUES (-1, "appelman", "ceo@banana.com", "Steev", "Jubs", "a20abc570d9b856d2b489d48b899cd252454e9ea017ac130$1bdded0391ecaafea329ec8c5609e9edb5a6afab64b8f3a4", "1 hello", "Some Street", "New Yorko", "Cavan", "nova", false);
INSERT INTO USERS VALUES (-2, "dj_man", "admin@swave.com", "DJ", "sWave", "a20abc570d9b856d2b489d48b899cd252454e9ea017ac130$1bdded0391ecaafea329ec8c5609e9edb5a6afab64b8f3a4", "kek", "lel", "Dublin", "Kerry", "flat", true);

INSERT INTO SONGS VALUES (-1, "Title", "Artist", "Genre", 1970, 2.99, "Public Domain", NULL);

INSERT INTO ORDERS VALUES (-1, -1, '1970-1-1', 15.50);

INSERT INTO ADS VALUES (-1, "ads/test.html");

INSERT INTO TICKETS VALUES (-1, -1, "my pc is on fire", "2009-12-3", false);
