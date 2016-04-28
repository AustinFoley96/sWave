DROP FUNCTION  IF EXISTS SWAVE.reg_free_song//
DROP PROCEDURE IF EXISTS SWAVE.reg_friend_proc//
DROP PROCEDURE IF EXISTS SWAVE.verify_credentials//
DROP TRIGGER   IF EXISTS SWAVE.aft_reg_trgr//
DROP TRIGGER   IF EXISTS SWAVE.bef_reg_trgr//
USE SWAVE;

CREATE FUNCTION reg_free_song(URID SMALLINT) RETURNS SMALLINT
BEGIN
    /* This function give the new user a predetermined free song as a thank
     * you for registering. */
    DECLARE currdate DATE;
    DECLARE freesongid SMALLINT;
    SET currdate = CURDATE(); /* Avoid repeated calls to CURDATE() */
    SET freesongid = -1;
    /* 0 is used as ID because AUTO_INCREMENT is enabled */
    INSERT INTO ORDERS(ORDERID, USERID, DATEORDERED, TOTAL) VALUES(0, URID, currdate, 0.00);
    INSERT INTO ORDERSONG(ORDERID, SONGID, PRICEPAID) VALUES((SELECT MAX(ORDERID) FROM ORDERS), freesongid, 0.00);
    RETURN (freesongid);
END
//


CREATE PROCEDURE reg_friend_proc(URID SMALLINT, SNGID SMALLINT)
BEGIN
    /* This procedure adds the system admin as a friend of the new user and sends
     * the new user a message thanking them for joining and telling them about
     * the free song.
     */
    DECLARE adminId SMALLINT;
    DECLARE currdate DATE;
    DECLARE MSG VARCHAR(500);
    SET currdate = CURDATE();
    SET adminId  = -1;
    SET MSG = (SELECT CONCAT('Welcome to sWave! We are thrilled you made the great decision to join our website! You join a community of ',
              (SELECT COUNT(*) FROM USERS) ,' people who enjoy the beauty of music. To show our gratitude we have given you ',
              (SELECT TITLE FROM SONGS WHERE SONGID = SNGID), ' worth ',
              (SELECT PRICE FROM SONGS WHERE SONGID = SNGID), ' for absolutely no cost! :^)'));
    INSERT INTO FRIEND(USERID, FRIENDID, FRIENDSHIPDATE, STATUS) VALUES (URID, adminId, currdate, 'c');
    INSERT INTO MESSAGE(MSGID, SENDER, RECEIVER, MSGDATE, CONTENT, STATUS) VALUES (0, adminId, URID, currdate, MSG, false);
END
//

CREATE PROCEDURE verify_credentials(uname VARCHAR(20), uemail VARCHAR(70))
BEGIN
    /* This procedure ensures a new user cannot overwrite an existing one even
     * if the website's logic fails.
     */
    IF ((SELECT COUNT(*) FROM USERS WHERE USERNAME = uname)  > 0) OR
       ((SELECT COUNT(*) FROM USERS WHERE EMAIL    = uemail) > 0) THEN
        SIGNAL SQLSTATE '45000' /* Abort the insert */
        SET MESSAGE_TEXT = 'User with same credentials exists.';
    END IF;
END//


CREATE TRIGGER SWAVE.aft_reg_trgr AFTER INSERT ON SWAVE.USERS
FOR EACH ROW
BEGIN
    /* After insert we add the admin friend and give the free song, we pass the
     * returned song information to the msg procedure so it can be mentioned in
     * the message.
     */
    CALL SWAVE.reg_friend_proc(new.USERID, SWAVE.reg_free_song(new.USERID));
END
//

CREATE TRIGGER SWAVE.bef_reg_trgr BEFORE INSERT ON SWAVE.USERS
FOR EACH ROW
BEGIN
    /* We check and make sure the user doesn't already exist before inserting */
    CALL SWAVE.verify_credentials(new.USERNAME, new.EMAIL);
END
//
