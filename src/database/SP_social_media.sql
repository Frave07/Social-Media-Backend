
/*******************************************************************/
/******** STORED PROCEDURE | SOCIAL MEDIA | FRAVE DEVELOEPR ********/
/*******************************************************************/

USE social_media;

DELIMITER //
CREATE PROCEDURE SP_REGISTER_USER(IN uidPerson VARCHAR(100), IN fullname VARCHAR(100), IN username VARCHAR(50), IN email VARCHAR(100), IN pass VARCHAR(100), IN uidUser VARCHAR(100), IN temp VARCHAR(50))
BEGIN
	INSERT INTO person(uid, fullname, image) VALUE (uidPerson, fullname, 'avatar-default.png');
	
	INSERT INTO users(uid, username, email, passwordd, person_uid, token_temp) VALUE (uidUser, username, email, pass, uidPerson, temp);
END//


/*---------------------------------------------------------------------------------------------------------------------------*/
DELIMITER //
CREATE PROCEDURE SP_GET_USER_BY_ID(IN ID VARCHAR(100))
BEGIN
	SELECT p.uid, p.fullname, p.phone, p.image, p.cover, p.birthday_date, p.created_at, u.username, u.description, u.is_private, u.is_online, u.email
	FROM person p
	INNER JOIN users u ON p.uid = u.person_uid
	WHERE p.uid = ID AND p.state = 1;
END//


/*---------------------------------------------------------------------------------------------------------------------------*/
DELIMITER //
CREATE PROCEDURE SP_GET_ALL_POSTS_HOME(IN ID VARCHAR(100))
BEGIN
	SELECT img.post_uid AS post_uid, pos.is_comment, pos.type_privacy, pos.created_at, pos.person_uid, ANY_VALUE(username) AS username, 
	per.image AS avatar, GROUP_CONCAT( DISTINCT img.image ) images, 
	(SELECT COUNT(co.post_uid) FROM comments co WHERE co.post_uid = pos.uid ) AS count_comment,
	(SELECT COUNT(li.post_uid) FROM likes li WHERE li.post_uid = pos.uid ) AS count_likes,
	(SELECT COUNT(li.user_uid) FROM likes li WHERE li.user_uid = ID AND li.post_uid = pos.uid )AS is_like
	FROM images_post img
	INNER JOIN posts pos  ON img.post_uid = pos.uid
	INNER JOIN comments co ON co.post_uid = pos.uid
	INNER JOIN users us ON us.person_uid = pos.person_uid
	INNER JOIN person per ON per.uid = pos.person_uid
	LEFT JOIN friends f ON f.friend_uid = per.uid
	WHERE f.person_uid = ID OR pos.person_uid = ID
	GROUP BY img.post_uid, co.post_uid 
	ORDER BY pos.created_at DESC;
END//
	
	
/*---------------------------------------------------------------------------------------------------------------------------*/
DELIMITER //
CREATE PROCEDURE SP_GET_ALL_POST_BY_USER(IN ID VARCHAR(100))
BEGIN
	SELECT img.post_uid AS post_uid, pos.is_comment, pos.type_privacy, pos.created_at, pos.person_uid, ANY_VALUE(username) AS username, 
	per.image AS avatar, GROUP_CONCAT( DISTINCT img.image ) images, 
	(SELECT COUNT(co.post_uid) FROM comments co WHERE co.post_uid = pos.uid ) AS count_comment,
	(SELECT COUNT(li.post_uid) FROM likes li WHERE li.post_uid = pos.uid ) AS count_likes,
	(SELECT COUNT(li.user_uid) FROM likes li WHERE li.user_uid = ID AND li.post_uid = pos.uid )AS is_like
	FROM images_post img
	INNER JOIN posts pos  ON img.post_uid = pos.uid
	INNER JOIN comments co ON co.post_uid = pos.uid
	INNER JOIN users us ON us.person_uid = pos.person_uid
	INNER JOIN person per ON per.uid = pos.person_uid
	WHERE per.uid = ID
	GROUP BY img.post_uid, co.post_uid 
	ORDER BY pos.created_at DESC;
END//
	

/*---------------------------------------------------------------------------------------------------------------------------*/
DELIMITER //
CREATE PROCEDURE SP_GET_POST_BY_ID_PERSON(IN ID VARCHAR(100))
BEGIN
	SELECT pos.uid, pos.is_comment, pos.type_privacy, pos.created_at, GROUP_CONCAT( DISTINCT img.image ) images FROM images_post img
	INNER JOIN posts pos  ON img.post_uid = pos.uid
	WHERE pos.person_uid = ID
	GROUP BY pos.uid;
END//


/*---------------------------------------------------------------------------------------------------------------------------*/
DELIMITER //
CREATE PROCEDURE SP_GET_LIST_POST_SAVED_BY_USER(IN ID VARCHAR(100))
BEGIN
	SELECT ps.post_save_uid, ps.post_uid, ps.person_uid, ps.date_save, per.image AS avatar, ANY_VALUE(username) AS username, GROUP_CONCAT( DISTINCT img.image ) images FROM post_save ps 
	INNER JOIN posts po ON ps.post_uid = po.uid
	INNER JOIN images_post img ON po.uid = img.post_uid
	INNER JOIN person per ON per.uid = ps.person_uid
	INNER JOIN users us ON us.person_uid = ps.person_uid
	where ps.person_uid = ID
	GROUP BY ps.post_save_uid;
END//


/*---------------------------------------------------------------------------------------------------------------------------*/
DELIMITER //
CREATE PROCEDURE SP_GET_ALL_POSTS_FOR_SEARCH(IN ID VARCHAR(100))
BEGIN
	SELECT img.post_uid AS post_uid, pos.is_comment, pos.type_privacy, pos.created_at, pos.person_uid, ANY_VALUE(username) AS username, per.image AS avatar, GROUP_CONCAT( DISTINCT img.image ) images  
	FROM images_post img
	INNER JOIN posts pos  ON img.post_uid = pos.uid
	INNER JOIN users us ON us.person_uid = pos.person_uid
	INNER JOIN person per ON per.uid = pos.person_uid
	WHERE pos.person_uid <> ID AND pos.type_privacy = 1
	GROUP BY img.post_uid
	ORDER BY pos.uid DESC;
END//


/*---------------------------------------------------------------------------------------------------------------------------*/
DELIMITER //
CREATE PROCEDURE SP_SEARCH_USERNAME(IN USERNAMEE VARCHAR(100))
BEGIN
	SELECT pe.uid, pe.fullname, pe.image AS avatar, us.username FROM person pe
	INNER JOIN users us ON pe.uid = us.person_uid
	WHERE us.username LIKE CONCAT('%', USERNAMEE, '%');
END//


/*---------------------------------------------------------------------------------------------------------------------------*/
DELIMITER //
CREATE PROCEDURE SP_GET_POST_BY_IDPERSON(IN ID VARCHAR(100))
BEGIN
	SELECT img.post_uid AS post_uid, pos.is_comment, pos.type_privacy, pos.created_at, GROUP_CONCAT( DISTINCT img.image ) images  
	FROM images_post img
	INNER JOIN posts pos  ON img.post_uid = pos.uid
	WHERE pos.person_uid = ID
	GROUP BY img.post_uid;
END

/*---------------------------------------------------------------------------------------------------------------------------*/
DELIMITER //
CREATE PROCEDURE SP_IS_FRIEND(IN UID VARCHAR(100), IN FRIEND VARCHAR(100))
BEGIN
	SELECT COUNT(uid) AS is_friend FROM friends
	WHERE person_uid = UID AND friend_uid = FRIEND
	LIMIT 1;
END


/*---------------------------------------------------------------------------------------------------------------------------*/
DELIMITER //
CREATE PROCEDURE SP_IS_PENDING_FOLLOWER(IN UIDPERSON VARCHAR(100), IN UIDFOLLOWER VARCHAR(100))
BEGIN
	SELECT COUNT(uid_notification) AS is_pending_follower FROM notifications
	WHERE user_uid = UIDPERSON AND followers_uid = UIDFOLLOWER AND type_notification = '1';
END//


/*---------------------------------------------------------------------------------------------------------------------------*/
DELIMITER //
CREATE PROCEDURE SP_GET_NOTIFICATION_BY_USER(IN ID VARCHAR(100))
BEGIN
	SELECT noti.uid_notification, noti.type_notification, noti.created_at, noti.user_uid, u.username, noti.followers_uid, s.username AS follower, pe.image AS avatar, noti.post_uid 
	FROM notifications noti
	INNER JOIN users u ON noti.user_uid = u.person_uid
	INNER JOIN users s ON noti.followers_uid = s.person_uid
	INNER JOIN person pe ON pe.uid = s.person_uid
	WHERE noti.user_uid = ID;
END//


/*---------------------------------------------------------------------------------------------------------------------------*/
DELIMITER //
CREATE PROCEDURE SP_GET_ALL_FOLLOWING(IN IDUSER VARCHAR(100))
BEGIN
	SELECT f.uid AS uid_friend, f.friend_uid AS uid_user, f.date_friend, u.username, p.fullname, p.image AS avatar 
	FROM friends f
	INNER JOIN users u ON f.friend_uid = u.person_uid
	INNER JOIN person p ON u.person_uid = p.uid
	WHERE f.person_uid = IDUSER;
END//


/*---------------------------------------------------------------------------------------------------------------------------*/
DELIMITER //
CREATE PROCEDURE SP_GET_ALL_FOLLOWERS(IN IDUSER VARCHAR(100))
BEGIN
	SELECT f.uid AS idFollower, f.followers_uid AS uid_user, f.date_followers, u.username, p.fullname, p.image AS avatar FROM followers f
	INNER JOIN users u ON f.followers_uid = u.person_uid
	INNER JOIN person p ON u.person_uid = p.uid
	WHERE f.person_uid = IDUSER;
END//


/*---------------------------------------------------------------------------------------------------------------------------*/
DELIMITER //
CREATE PROCEDURE SP_ADD_NEW_STORY(IN IDSTORY VARCHAR(100), IN IDUSER VARCHAR(100), IN IDMEDIASTORY VARCHAR(100), IN MEDIA VARCHAR(150))
BEGIN
	INSERT INTO stories (uid_story, user_uid) VALUE (IDSTORY,IDUSER);
	INSERT INTO media_story(uid_media_story, media, story_uid) VALUE (IDMEDIASTORY, MEDIA, IDSTORY);
END//


/*---------------------------------------------------------------------------------------------------------------------------*/
DELIMITER //
CREATE PROCEDURE SP_GET_ALL_STORIES_HOME(IN IDUSER VARCHAR(100))
BEGIN
	SELECT s.uid_story, u.username, p.image AS avatar, COUNT(ms.story_uid) AS count_story
	FROM stories s
	INNER JOIN users u ON s.user_uid = u.person_uid
	INNER JOIN media_story ms ON s.uid_story = ms.story_uid
	INNER JOIN friends f ON u.person_uid = f.friend_uid
	INNER JOIN person p ON p.uid = f.friend_uid
	WHERE f.person_uid =  IDUSER
	GROUP BY s.uid_story, u.username, p.image;
END//


/*---------------------------------------------------------------------------------------------------------------------------*/
DELIMITER //
CREATE PROCEDURE SP_GET_STORY_BY_USER(IN IDSTORY VARCHAR(100))
BEGIN
	SELECT *
	FROM media_story ms
	WHERE ms.story_uid = IDSTORY;
END//


/*---------------------------------------------------------------------------------------------------------------------------*/
DELIMITER //
CREATE PROCEDURE SP_GET_COMMNETS_BY_UIDPOST(IN IDPOST VARCHAR(100))
BEGIN
	SELECT co.uid, co.`comment`, co.is_like, co.created_at, co.person_uid, co.post_uid, u.username, p.image AS avatar FROM comments co
	INNER JOIN users u ON co.person_uid = u.person_uid
	INNER JOIN person p ON p.uid = co.person_uid
	WHERE co.post_uid = IDPOST
	ORDER BY co.created_at ASC; 
END//


/*---------------------------------------------------------------------------------------------------------------------------*/
DELIMITER //
CREATE PROCEDURE SP_GET_ALL_MESSAGE_BY_USER(IN IDUSER VARCHAR(100))
BEGIN
	SELECT ls.uid_list_chat, ls.source_uid, ls.target_uid, ls.last_message, ls.updated_at, u.username, p.image AS avatar
	FROM list_chats ls
	INNER JOIN users u ON ls.target_uid = u.person_uid
	INNER JOIN person p ON u.person_uid = p.uid
 	WHERE ls.source_uid = IDUSER
 	ORDER BY ls.updated_at ASC;
END//


/*---------------------------------------------------------------------------------------------------------------------------*/
DELIMITER //
CREATE PROCEDURE SP_ALL_MESSAGE_BY_USER(IN UIDFROM VARCHAR(100), IN UIDTO VARCHAR(100))
BEGIN	
	SELECT * FROM messages me
	WHERE me.source_uid = UIDFROM AND me.target_uid = UIDTO || me.source_uid = UIDTO AND me.target_uid = UIDFROM
	ORDER BY me.created_at DESC
	LIMIT 30;  
END//


/*---------------------------------------------------------------------------------------------------------------------------*/
	/* EVENT FOR DELETE STORIES AFTER 24 HOURS 
/*---------------------------------------------------------------------------------------------------------------------------*/
	CREATE EVENT delete_story_after_24_hours 
		ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 1 DAY
		DO
			DELETE FROM media_story WHERE created_at < ( CURRENT_TIMESTAMP - INTERVAL 1 DAY );

/*---------------------------------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------------------------------*/























