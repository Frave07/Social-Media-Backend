CREATE DATABASE social_media;

USE social_media;

CREATE TABLE person 
(
	uid VARCHAR(100) PRIMARY KEY,
	fullname VARCHAR(150) NULL,
	phone VARCHAR(11) NULL,
	image VARCHAR(250) NULL,
	cover VARCHAR(50) NULL,
	birthday_date DATE NULL,
	state BOOL DEFAULT 1,
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT NOW()
);

CREATE TABLE users
(
	uid VARCHAR(100) PRIMARY KEY,
	username VARCHAR(50) NOT NULL,
	description VARCHAR(100) NULL,
	is_private BOOL DEFAULT FALSE,
	is_online BOOL DEFAULT FALSE,
	email VARCHAR(100) NOT NULL,
	passwordd VARCHAR(100) NOT NULL,
	email_verified BOOL DEFAULT FALSE,
	person_uid VARCHAR(100) NOT NULL,
	notification_token VARCHAR(255) NULL,
	token_temp VARCHAR(100) NULL,
	UNIQUE KEY (email),
	FOREIGN KEY (person_uid) REFERENCES person(uid)
);


CREATE TABLE posts
(
	uid VARCHAR(100) PRIMARY KEY,
	is_comment BOOL DEFAULT 1,
	type_privacy VARCHAR(3) NOT NULL,
	created_at DATETIME DEFAULT NOW(),
	upadted_at DATETIME DEFAULT NOW(),
	person_uid VARCHAR(100) NOT NULL,
		
	FOREIGN KEY(person_uid) REFERENCES person(uid) 
);

CREATE TABLE comments
(
	uid VARCHAR(100) PRIMARY KEY,
	comment VARCHAR(150) NULL,
	is_like BOOL DEFAULT 0,
	created_at DATETIME DEFAULT NOW(),
	person_uid VARCHAR(100) NOT NULL,
	post_uid VARCHAR(100) NOT NULL,
	
	FOREIGN KEY(person_uid) REFERENCES person(uid),
	FOREIGN KEY (post_uid) REFERENCES posts(uid)
);

CREATE TABLE likes
(
	uid_likes VARCHAR(100) PRIMARY KEY,
	user_uid VARCHAR(100) NOT NULL,
	post_uid VARCHAR(100) NOT NULL,
	created_at DATETIME DEFAULT NOW(),
	
	FOREIGN KEY(user_uid) REFERENCES users(person_uid),
	FOREIGN KEY(post_uid) REFERENCES posts(uid)
);


CREATE TABLE images_post
(
	uid VARCHAR(100) PRIMARY KEY,
	image VARCHAR(255) NOT NULL,
	post_uid VARCHAR(100) NOT NULL,
	FOREIGN KEY(post_uid) REFERENCES posts(uid)
);


CREATE TABLE post_save
(
	post_save_uid VARCHAR(100) PRIMARY KEY,
	post_uid VARCHAR(100) NOT NULL,
	person_uid VARCHAR(100) NOT NULL,
	date_save DATETIME DEFAULT NOW(),
	
	FOREIGN KEY(post_uid) REFERENCES posts(uid),
	FOREIGN KEY(person_uid) REFERENCES person(uid)
);


CREATE TABLE friends
(
	uid VARCHAR(100) PRIMARY KEY,
	person_uid VARCHAR(100) NOT NULL,
	friend_uid VARCHAR(100) NOT NULL,
	date_friend DATETIME DEFAULT NOW(),
	
	FOREIGN KEY(person_uid) REFERENCES person(uid),
	FOREIGN KEY(friend_uid) REFERENCES person(uid)
);


CREATE TABLE followers
(
	uid VARCHAR(100) PRIMARY KEY,
	person_uid VARCHAR(100) NOT NULL,
	followers_uid VARCHAR(100) NOT NULL,
	date_followers DATETIME DEFAULT NOW(),
	
	FOREIGN KEY(person_uid) REFERENCES person(uid),
	FOREIGN KEY(followers_uid) REFERENCES person(uid)	
);


CREATE TABLE stories
(
	uid_story VARCHAR(100) PRIMARY KEY,
	user_uid VARCHAR(100) NOT NULL,	
	FOREIGN KEY(user_uid) REFERENCES users(person_uid)
);

CREATE TABLE media_story
(
	uid_media_story VARCHAR(100) PRIMARY KEY,
	media VARCHAR(150) NOT NULL,
	created_at DATETIME DEFAULT NOW(),
	story_uid VARCHAR(100) NOT NULL,
	
	FOREIGN KEY(story_uid) REFERENCES stories(uid_story) ON DELETE CASCADE
);

CREATE TABLE notifications
(
	uid_notification VARCHAR(100) PRIMARY KEY,
	type_notification VARCHAR(5) NOT NULL,
	created_at DATETIME DEFAULT NOW(),
	user_uid VARCHAR(100) NOT NULL,
	followers_uid VARCHAR(100) NULL,
	post_uid VARCHAR(100) NULL,
	
	FOREIGN KEY(user_uid) REFERENCES users(person_uid),
	FOREIGN KEY(followers_uid) REFERENCES users(person_uid),
	FOREIGN KEY(post_uid) REFERENCES posts(uid)
);

CREATE TABLE list_chats
(
	uid_list_chat VARCHAR(100) PRIMARY KEY,
	source_uid VARCHAR(100) NOT NULL,
	target_uid VARCHAR(100) NOT NULL,
	last_message TEXT NULL,
	updated_at DATETIME NULL,
	
	FOREIGN KEY(source_uid) REFERENCES person(uid),
	FOREIGN KEY(target_uid) REFERENCES person(uid)
);

CREATE TABLE messages
(
	uid_messages VARCHAR(100) PRIMARY KEY,
	source_uid VARCHAR(100) NOT NULL,
	target_uid VARCHAR(100) NOT NULL,
	message TEXT NOT NULL,
	created_at DATETIME DEFAULT NOW(),
	
	FOREIGN KEY(source_uid) REFERENCES users(person_uid),
	FOREIGN KEY(target_uid) REFERENCES users(person_uid)
);


























