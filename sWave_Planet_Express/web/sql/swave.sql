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
    USERID     SMALLINT    NOT NULL AUTO_INCREMENT,
    USERNAME   VARCHAR(20) NOT NULL,
    EMAIL      VARCHAR(70) NOT NULL,
    FNAME      VARCHAR(20),
    LNAME      VARCHAR(20),
    PASSWD     VARCHAR(97) NOT NULL,
    ADD1       VARCHAR(30),
    ADD2       VARCHAR(30),
    CITY       VARCHAR(20),
    COUNTY     ENUM('Carlow', 'Cavan', 'Clare', 'Cork', 'Donegal', 'Dublin', 'Galway', 'Kerry', 'Kildare', 'Kilkenny', 'Laois', 'Leitrim', 'Limerick', 'Longford', 'Louth', 'Mayo', 'Meath', 'Monaghan', 'Offaly', 'Roscommon', 'Sligo', 'Tipperary', 'Waterford', 'Westmeath', 'Wexford', 'Wicklow'),
    SKIN       ENUM('flat', 'flat darkness', 'nova', 'quantum', 'evolved', 'legacy', 'shire', 'smart', 'smart++', '9x') DEFAULT 'flat' NOT NULL,
    ADMIN      BOOLEAN   NOT NULL DEFAULT false,
    CONSTRAINT PK_USERID PRIMARY KEY (USERID)
);

CREATE TABLE SONGS (
    SONGID    SMALLINT     NOT NULL AUTO_INCREMENT,
    TITLE     VARCHAR(50)  NOT NULL,
    ARTIST    VARCHAR(40),
    ALBUM     VARCHAR(40),
    GENRE     VARCHAR(20),
    RELYEAR   YEAR,
    PRICE     FLOAT(3, 2)  UNSIGNED NOT NULL,
    LICENSE   VARCHAR(300) NOT NULL,
    PLAYCOUNT BIGINT       NOT NULL DEFAULT 0,
    ARTWORK   MEDIUMBLOB,
    SONGDATA  MEDIUMBLOB,
    CONSTRAINT PK_SONGID PRIMARY KEY(SONGID)
);

CREATE TABLE MERCH (
    MERCHID SMALLINT    NOT NULL AUTO_INCREMENT,
    TITLE   VARCHAR(20) NOT NULL,
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

CREATE TABLE PLAYLISTS (
    PLAYLISTID SMALLINT    NOT NULL AUTO_INCREMENT,
    USERID     SMALLINT    NOT NULL,
    TITLE      VARCHAR(30) NOT NULL,
    CONSTRAINT PK_PLAYLISTID PRIMARY KEY(PLAYLISTID),
    CONSTRAINT FK_LISTENER   FOREIGN KEY(USERID) REFERENCES USERS(USERID)
);

CREATE TABLE PLAYTRACKS (
    SONGID     SMALLINT NOT NULL,
    PLAYLISTID SMALLINT NOT NULL,
    CONSTRAINT PK_PLAYTRACKS PRIMARY KEY(SONGID, PLAYLISTID),
    CONSTRAINT FK_THESONG    FOREIGN KEY(SONGID)     REFERENCES SONGS(SONGID),
    CONSTRAINT FK_PLAYLIST   FOREIGN KEY(PLAYLISTID) REFERENCES PLAYLISTS(PLAYLISTID)
);

CREATE TABLE LOCKS (
    USERID SMALLINT NOT NULL,
    SONGID SMALLINT NOT NULL,
    LOCKTIME BIGINT UNSIGNED NOT NULL,
    CONSTRAINT PK_LOCKS      PRIMARY KEY(USERID, SONGID),
    CONSTRAINT FK_LOCKS_USER FOREIGN KEY(USERID) REFERENCES USERS(USERID),
    CONSTRAINT FK_LOCKS_SONG FOREIGN KEY(SONGID) REFERENCES SONGS(SONGID)
);

/* TEST DATA */

INSERT INTO USERS VALUES (-1, "appelman", "ceo@banana.com", "Steev", "Jubs", "a20abc570d9b856d2b489d48b899cd252454e9ea017ac130$1bdded0391ecaafea329ec8c5609e9edb5a6afab64b8f3a4", "1 hello", "Some Street", "New Yorko", "Cavan", "nova", false);
INSERT INTO USERS VALUES (-2, "dj_man", "admin@swave.com", "DJ", "sWave", "a20abc570d9b856d2b489d48b899cd252454e9ea017ac130$1bdded0391ecaafea329ec8c5609e9edb5a6afab64b8f3a4", "kek", "lel", "Dublin", "Kerry", "flat", true);

INSERT INTO SONGS VALUES (-1, "Title", "Artist", "Album", "Genre", 1970, 2.99, "Public Domain", 0, NULL, NULL);

INSERT INTO ORDERS VALUES (-1, -1, '1970-1-1', 15.50);
INSERT INTO ORDERS VALUES (-2, -2, '1971-1-1', 16.20);

INSERT INTO ADS VALUES (1, "ads/test.html");
INSERT INTO ADS VALUES (2, "ads/test2.html");

INSERT INTO TICKETS VALUES (-1, -1, "my pc is on fire", "2009-12-3", false);

INSERT INTO MERCH VALUES(-1, "Mug", 9.99, NULL);
INSERT INTO MERCH VALUES(-2, "T-Shirt", 29.99, NULL);

INSERT INTO ORDERMERCH VALUES(-1, -1, 1, 9.99, NULL);
