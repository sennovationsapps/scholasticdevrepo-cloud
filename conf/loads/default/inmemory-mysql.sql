SET LOCK_MODE 3;
SET DB_CLOSE_DELAY -1;
CREATE USER IF NOT EXISTS "" SALT '' HASH '' ADMIN;
CREATE SEQUENCE PUBLIC.ORGANIZATION_SEQ START WITH 21;
CREATE SEQUENCE PUBLIC.TOKEN_ACTION_SEQ START WITH 1;
CREATE SEQUENCE PUBLIC.SPONSOR_ITEM_SEQ START WITH 41;
CREATE SEQUENCE PUBLIC.SECURITY_ROLE_SEQ START WITH 21;
CREATE SEQUENCE PUBLIC.USERS_SEQ START WITH 21;
CREATE SEQUENCE PUBLIC.EVENT_SEQ START WITH 61;
CREATE SEQUENCE PUBLIC.EVENT_PAGES_SEQ START WITH 41;
CREATE SEQUENCE PUBLIC.VOLUNTEERS_SEQ START WITH 61;
CREATE SEQUENCE PUBLIC.VOLUNTEER_SEQ START WITH 1;
CREATE SEQUENCE PUBLIC.PFP_SEQ START WITH 81;
CREATE SEQUENCE PUBLIC.LINKED_ACCOUNT_SEQ START WITH 21;
CREATE SEQUENCE PUBLIC.USER_PERMISSION_SEQ START WITH 41;
CREATE SEQUENCE PUBLIC.SPONSORS_SEQ START WITH 61;
CREATE SEQUENCE PUBLIC.PRIZE_SEQ START WITH 41;
CREATE SEQUENCE PUBLIC.AWARDS_SEQ START WITH 41;
CREATE SEQUENCE PUBLIC.TEAM_SEQ START WITH 81;
CREATE SEQUENCE PUBLIC.SHIFT_SEQ START WITH 61;
CREATE SEQUENCE PUBLIC.MERGED_ACCOUNT_SEQ START WITH 1;
CREATE SEQUENCE PUBLIC.DONATION_SEQ START WITH 41;
CREATE MEMORY TABLE PUBLIC.PLAY_EVOLUTIONS(
    ID INT NOT NULL,
    HASH VARCHAR(255) NOT NULL,
    APPLIED_AT TIMESTAMP NOT NULL,
    APPLY_SCRIPT TEXT,
    REVERT_SCRIPT TEXT,
    STATE VARCHAR(255),
    LAST_PROBLEM TEXT
);
ALTER TABLE PUBLIC.PLAY_EVOLUTIONS ADD CONSTRAINT PUBLIC.CONSTRAINT_9 PRIMARY KEY(ID);
-- 1 +/- SELECT COUNT(*) FROM PUBLIC.PLAY_EVOLUTIONS;
CREATE TABLE IF NOT EXISTS SYSTEM_LOB_STREAM(ID INT NOT NULL, PART INT NOT NULL, CDATA VARCHAR, BDATA BINARY);
CREATE PRIMARY KEY SYSTEM_LOB_STREAM_PRIMARY_KEY ON SYSTEM_LOB_STREAM(ID, PART);
CREATE ALIAS IF NOT EXISTS SYSTEM_COMBINE_CLOB FOR "org.h2.command.dml.ScriptCommand.combineClob";
CREATE ALIAS IF NOT EXISTS SYSTEM_COMBINE_BLOB FOR "org.h2.command.dml.ScriptCommand.combineBlob";
INSERT INTO SYSTEM_LOB_STREAM VALUES(0, 0, STRINGDECODE('create table awards (\nid                        bigint not null,\ncontent                   TEXT,\neventid                   bigint,\nimg_url                   varchar(255),\nname                      varchar(255),\ntitle                     varchar(255),\nconstraint pk_awards primary key (id))\n;\n\ncreate table donation (\nid                        bigint not null,\namount                    integer,\ncheck_num                 varchar(255),\ncc_digits                 varchar(255),\ndate_created              timestamp,\ndate_paid                 timestamp,\ndonor_message             varchar(255),\ndonor_name                varchar(255),\ndonation_type             integer,\nemail                     varchar(255),\nevent_id                  bigint not null,\nfirst_name                varchar(255),\nlast_name                 varchar(255),\npay_by_check              boolean,\npfp_id                    bigint,\nphone                     varchar(255),\nstatus                    integer,\npayment_type              integer,\ntransaction_number        varchar(255),\ninvoice_number            varchar(255),\nzip_code                  varchar(255),\nconstraint ck_donation_donation_type check (donation_type in (''2'',''1'',''3'')),\nconstraint ck_donation_status check (status in (''1'',''3'',''2'',''0'')),\nconstraint ck_donation_payment_type check (payment_type in (''1'',''2'',''3'')),\nconstraint pk_donation primary key (id))\n;\n\ncreate table event (\nid                        bigint not null,\ncity                      varchar(255),\ncontent                   TEXT,\ndate_created              timestamp,\nevent_start               timestamp,\nevent_end                 timestamp,\nfundraising_end           timestamp,\nfundraising_start         timestamp,\ngoal                      integer,\nhero_img_url              varchar(255),\nimg_url                   varchar(255),\nname                      varchar(255),\nschool_id                 varchar(255),\nslug                      varchar(255),\nstate                     varchar(255),\nstatus                    integer,\ntitle                     varchar(255),\ntotal                     integer,\ngeneralPfpId              bigint,\nsponsorPfpId              bigint,\nuser_admin_id             bigint not null,\nzip_code                  varchar(255),\nconstraint ck_event_status check (status in (''1'',''2'',''3'',''4'')),\nconstraint pk_event primary key (id))\n;\n\ncreate table event_pages (\nid                        bigint not null,\ncontent                   TEXT,\neventid                   bigint,\nname                      varchar(255),\ntitle                     varchar(255),\nconstraint pk_event_pages primary key (id))\n;\n\ncreate table linked_account (\nid                        bigint not null,\nprovider_key              varchar(255),\nprovider_user_id          varchar(255),\nuser_id                   bigint,\nconstraint pk_linked_account primary key (id))\n;\n\ncreate table merged_account (\nid                        bigint not null,\nuser_id                   bigint not null,\nauth_user_id              bigint,\nemail                     varchar(255),\nconstraint pk_merged_account primary key (id))\n;\n\ncreate table organization (\nid                        bigint not null,\naddress                   varchar(255),\ncity                      varchar(255),\nname                      varchar(255),\nphone                     varchar(255),\nstate                     varchar(255),\ntax_id                    bigint,\nzip                       varchar(255),\nconstraint pk_organization primary key (id))\n;\n\ncreate table pfp (\nid                        bigint not null,\ncontent                   TEXT,\ndate_created              timestamp,\nemergency_contact         varchar(255),\nemergency_contact_phone   varchar(255),\nevent_id                  bigint not null,\ngoal                      integer,\nhero_img_url              varchar(255),\nimg_url                   varchar(255),\nname                      varchar(255),\npfp_type                  integer,\nprivate_acct              boolean,\nslug                      varchar(255),\nteam_id                   bigint,\ntitle                     varchar(255),\ntotal              '), NULL);
INSERT INTO SYSTEM_LOB_STREAM VALUES(0, 1, STRINGDECODE('       integer,\nuser_admin_id             bigint not null,\nconstraint ck_pfp_pfp_type check (pfp_type in (''2'',''1'',''3'')),\nconstraint pk_pfp primary key (id))\n;\n\ncreate table prize (\nid                        bigint not null,\ndescription               varchar(255),\nawards_id                 bigint,\ninfo                      TEXT,\nname                      varchar(255),\nconstraint pk_prize primary key (id))\n;\n\ncreate table security_role (\nid                        bigint not null,\nrole_name                 varchar(255),\nconstraint pk_security_role primary key (id))\n;\n\ncreate table shift (\nid                        bigint not null,\ndate                      timestamp,\ndescription               varchar(255),\nend_time                  timestamp,\nname                      varchar(255),\nstart_time                timestamp,\nvolunteer_count           integer,\nvolunteers_id             bigint,\nconstraint pk_shift primary key (id))\n;\n\ncreate table sponsor_item (\nid                        bigint not null,\namount                    integer,\ndescription               varchar(255),\ndonation_id               bigint,\nsponsors_id               bigint,\ntitle                     varchar(255),\nconstraint pk_sponsor_item primary key (id))\n;\n\ncreate table sponsors (\nid                        bigint not null,\ncontent                   TEXT,\neventid                   bigint,\nname                      varchar(255),\ntitle                     varchar(255),\nconstraint pk_sponsors primary key (id))\n;\n\ncreate table team (\nid                        bigint not null,\ncaptain                   varchar(255),\ncaptain_email             varchar(255),\ncontent                   TEXT,\neventid                   bigint,\ngoal                      integer,\nhero_img_url              varchar(255),\nimg_url                   varchar(255),\nname                      varchar(255),\ntitle                     varchar(255),\nconstraint pk_team primary key (id))\n;\n\ncreate table token_action (\nid                        bigint not null,\ncreated                   timestamp,\nexpires                   timestamp,\ntarget_user_id            bigint,\ntoken                     varchar(255),\ntype                      varchar(2),\nconstraint ck_token_action_type check (type in (''EV'',''PR'')),\nconstraint uq_token_action_token unique (token),\nconstraint pk_token_action primary key (id))\n;\n\ncreate table users (\nid                        bigint not null,\nactive                    boolean,\nagree_to_policy           boolean,\nagree_to_represent        boolean,\ndate_created              timestamp,\nemail                     varchar(255),\nemail_validated           boolean,\nfirst_name                varchar(255),\nlast_login                timestamp,\nlast_name                 varchar(255),\norganization_id           bigint,\nphone                     varchar(255),\ntaxid                     bigint,\nzip                       varchar(255),\nconstraint uq_users_taxid unique (taxid),\nconstraint pk_users primary key (id))\n;\n\ncreate table user_permission (\nid                        bigint not null,\nvalue                     varchar(255),\nconstraint pk_user_permission primary key (id))\n;\n\ncreate table volunteer (\nid                        bigint not null,\nactive                    boolean,\ndate_created              timestamp,\nemail                     varchar(255),\nfirst_name                varchar(255),\nlast_name                 varchar(255),\nmobile                    varchar(255),\nnote                      varchar(255),\nphone                     varchar(255),\nshift_id                  bigint,\nconstraint pk_volunteer primary key (id))\n;\n\ncreate table volunteers (\nid                        bigint not null,\ncontent                   TEXT,\neventid                   bigint,\nname                      varchar(255),\ntitle                     varchar(255),\nconstraint pk_volunteers primary key (id))\n;\n\n\ncreate table users_user_permission (\nusers_id                       bigint not null,\nuser_permission_id             bigint not null,\nconstraint pk_users_user_permission primary key (users_id, user_permission_id))\n;\n\ncreate tab'), NULL);
INSERT INTO SYSTEM_LOB_STREAM VALUES(0, 2, STRINGDECODE('le users_security_role (\nusers_id                       bigint not null,\nsecurity_role_id               bigint not null,\nconstraint pk_users_security_role primary key (users_id, security_role_id))\n;\ncreate sequence awards_seq;\n\ncreate sequence donation_seq;\n\ncreate sequence event_seq;\n\ncreate sequence event_pages_seq;\n\ncreate sequence linked_account_seq;\n\ncreate sequence merged_account_seq;\n\ncreate sequence organization_seq;\n\ncreate sequence pfp_seq;\n\ncreate sequence prize_seq;\n\ncreate sequence security_role_seq;\n\ncreate sequence shift_seq;\n\ncreate sequence sponsor_item_seq;\n\ncreate sequence sponsors_seq;\n\ncreate sequence team_seq;\n\ncreate sequence token_action_seq;\n\ncreate sequence users_seq;\n\ncreate sequence user_permission_seq;\n\ncreate sequence volunteer_seq;\n\ncreate sequence volunteers_seq;\n\nalter table donation add constraint fk_donation_event_1 foreign key (event_id) references event (id) on delete restrict on update restrict;\ncreate index ix_donation_event_1 on donation (event_id);\nalter table donation add constraint fk_donation_pfp_2 foreign key (pfp_id) references pfp (id) on delete restrict on update restrict;\ncreate index ix_donation_pfp_2 on donation (pfp_id);\nalter table event add constraint fk_event_generalFund_3 foreign key (generalPfpId) references pfp (id) on delete restrict on update restrict;\ncreate index ix_event_generalFund_3 on event (generalPfpId);\nalter table event add constraint fk_event_sponsorFund_4 foreign key (sponsorPfpId) references pfp (id) on delete restrict on update restrict;\ncreate index ix_event_sponsorFund_4 on event (sponsorPfpId);\nalter table event add constraint fk_event_userAdmin_5 foreign key (user_admin_id) references users (id) on delete restrict on update restrict;\ncreate index ix_event_userAdmin_5 on event (user_admin_id);\nalter table linked_account add constraint fk_linked_account_user_6 foreign key (user_id) references users (id) on delete restrict on update restrict;\ncreate index ix_linked_account_user_6 on linked_account (user_id);\nalter table merged_account add constraint fk_merged_account_users_7 foreign key (user_id) references users (id) on delete restrict on update restrict;\ncreate index ix_merged_account_users_7 on merged_account (user_id);\nalter table pfp add constraint fk_pfp_event_8 foreign key (event_id) references event (id) on delete restrict on update restrict;\ncreate index ix_pfp_event_8 on pfp (event_id);\nalter table pfp add constraint fk_pfp_team_9 foreign key (team_id) references team (id) on delete restrict on update restrict;\ncreate index ix_pfp_team_9 on pfp (team_id);\nalter table pfp add constraint fk_pfp_userAdmin_10 foreign key (user_admin_id) references users (id) on delete restrict on update restrict;\ncreate index ix_pfp_userAdmin_10 on pfp (user_admin_id);\nalter table prize add constraint fk_prize_awards_11 foreign key (awards_id) references awards (id) on delete restrict on update restrict;\ncreate index ix_prize_awards_11 on prize (awards_id);\nalter table shift add constraint fk_shift_volunteers_12 foreign key (volunteers_id) references volunteers (id) on delete restrict on update restrict;\ncreate index ix_shift_volunteers_12 on shift (volunteers_id);\nalter table sponsor_item add constraint fk_sponsor_item_donation_13 foreign key (donation_id) references donation (id) on delete restrict on update restrict;\ncreate index ix_sponsor_item_donation_13 on sponsor_item (donation_id);\nalter table sponsor_item add constraint fk_sponsor_item_sponsors_14 foreign key (sponsors_id) references sponsors (id) on delete restrict on update restrict;\ncreate index ix_sponsor_item_sponsors_14 on sponsor_item (sponsors_id);\nalter table token_action add constraint fk_token_action_targetUser_15 foreign key (target_user_id) references users (id) on delete restrict on update restrict;\ncreate index ix_token_action_targetUser_15 on token_action (target_user_id);\nalter table users add constraint fk_users_organization_16 foreign key (organization_id) references organization (id) on delete restrict on update restrict;\ncreate index ix_users_organization_16 on users (organizat'), NULL);
INSERT INTO SYSTEM_LOB_STREAM VALUES(0, 3, STRINGDECODE('ion_id);\nalter table volunteer add constraint fk_volunteer_shift_17 foreign key (shift_id) references shift (id) on delete restrict on update restrict;\ncreate index ix_volunteer_shift_17 on volunteer (shift_id);\n\n\n\nalter table users_user_permission add constraint fk_users_user_permission_user_01 foreign key (users_id) references users (id) on delete restrict on update restrict;\n\nalter table users_user_permission add constraint fk_users_user_permission_user_02 foreign key (user_permission_id) references user_permission (id) on delete restrict on update restrict;\n\nalter table users_security_role add constraint fk_users_security_role_users_01 foreign key (users_id) references users (id) on delete restrict on update restrict;\n\nalter table users_security_role add constraint fk_users_security_role_securi_02 foreign key (security_role_id) references security_role (id) on delete restrict on update restrict;'), NULL);
INSERT INTO PUBLIC.PLAY_EVOLUTIONS(ID, HASH, APPLIED_AT, APPLY_SCRIPT, REVERT_SCRIPT, STATE, LAST_PROBLEM) VALUES
(1, 'be0409a80f7e279636d9bb8d27b5d724bea20b4c', TIMESTAMP '2014-09-20 00:00:00.0', SYSTEM_COMBINE_CLOB(0), STRINGDECODE('SET REFERENTIAL_INTEGRITY FALSE;\n\ndrop table if exists awards;\n\ndrop table if exists donation;\n\ndrop table if exists event;\n\ndrop table if exists event_pages;\n\ndrop table if exists linked_account;\n\ndrop table if exists merged_account;\n\ndrop table if exists organization;\n\ndrop table if exists pfp;\n\ndrop table if exists prize;\n\ndrop table if exists security_role;\n\ndrop table if exists shift;\n\ndrop table if exists sponsor_item;\n\ndrop table if exists sponsors;\n\ndrop table if exists team;\n\ndrop table if exists token_action;\n\ndrop table if exists users;\n\ndrop table if exists users_user_permission;\n\ndrop table if exists users_security_role;\n\ndrop table if exists user_permission;\n\ndrop table if exists volunteer;\n\ndrop table if exists volunteers;\n\nSET REFERENTIAL_INTEGRITY TRUE;\n\ndrop sequence if exists awards_seq;\n\ndrop sequence if exists donation_seq;\n\ndrop sequence if exists event_seq;\n\ndrop sequence if exists event_pages_seq;\n\ndrop sequence if exists linked_account_seq;\n\ndrop sequence if exists merged_account_seq;\n\ndrop sequence if exists organization_seq;\n\ndrop sequence if exists pfp_seq;\n\ndrop sequence if exists prize_seq;\n\ndrop sequence if exists security_role_seq;\n\ndrop sequence if exists shift_seq;\n\ndrop sequence if exists sponsor_item_seq;\n\ndrop sequence if exists sponsors_seq;\n\ndrop sequence if exists team_seq;\n\ndrop sequence if exists token_action_seq;\n\ndrop sequence if exists users_seq;\n\ndrop sequence if exists user_permission_seq;\n\ndrop sequence if exists volunteer_seq;\n\ndrop sequence if exists volunteers_seq;'), 'applied', '');
CREATE MEMORY TABLE PUBLIC.AWARDS(
    ID BIGINT NOT NULL,
    CONTENT TEXT,
    EVENTID BIGINT,
    IMG_URL VARCHAR(255),
    NAME VARCHAR(255),
    TITLE VARCHAR(255)
);

ALTER TABLE PUBLIC.AWARDS ADD CONSTRAINT PUBLIC.PK_AWARDS PRIMARY KEY(ID);
-- 2 +/- SELECT COUNT(*) FROM PUBLIC.AWARDS;
INSERT INTO PUBLIC.AWARDS(ID, CONTENT, EVENTID, IMG_URL, NAME, TITLE) VALUES
(1, STRINGDECODE('\r\n1 Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven&#39;t heard of them accusamus labore sustainable VHS.\r\n'), 1, NULL, 'Awards', 'Awards'),
(33, STRINGDECODE('\r\n1 Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven&#39;t heard of them accusamus labore sustainable VHS.\r\n'), 41, 'https://s3.amazonaws.com/scholasticchallenge-images/dynamic/12757921-5abd-4a07-b812-065531606789/Latest_News.png', 'Prizes to Win', 'Prizes to Win');
CREATE MEMORY TABLE PUBLIC.DONATION(
    ID BIGINT NOT NULL,
    AMOUNT INTEGER,
    CHECK_NUM VARCHAR(255),
    CC_DIGITS VARCHAR(255),
    DATE_CREATED TIMESTAMP,
    DATE_PAID TIMESTAMP,
    DONOR_MESSAGE VARCHAR(255),
    DONOR_NAME VARCHAR(255),
    DONATION_TYPE INTEGER,
    EMAIL VARCHAR(255),
    EVENT_ID BIGINT NOT NULL,
    FIRST_NAME VARCHAR(255),
    LAST_NAME VARCHAR(255),
    PAY_BY_CHECK BOOLEAN,
    PFP_ID BIGINT,
    PHONE VARCHAR(255),
    STATUS INTEGER,
    PAYMENT_TYPE INTEGER,
    TRANSACTION_NUMBER VARCHAR(255),
    INVOICE_NUMBER VARCHAR(255),
    ZIP_CODE VARCHAR(255)
);
ALTER TABLE PUBLIC.DONATION ADD CONSTRAINT PUBLIC.PK_DONATION PRIMARY KEY(ID);
-- 8 +/- SELECT COUNT(*) FROM PUBLIC.DONATION;
INSERT INTO PUBLIC.DONATION(ID, AMOUNT, CHECK_NUM, CC_DIGITS, DATE_CREATED, DATE_PAID, DONOR_MESSAGE, DONOR_NAME, DONATION_TYPE, EMAIL, EVENT_ID, FIRST_NAME, LAST_NAME, PAY_BY_CHECK, PFP_ID, PHONE, STATUS, PAYMENT_TYPE, TRANSACTION_NUMBER, INVOICE_NUMBER, ZIP_CODE) VALUES
(1, 50, NULL, NULL, TIMESTAMP '2014-09-20 16:38:30.429', TIMESTAMP '2014-09-20 16:39:26.124', '', '', 1, 'jay.blanton@sbcglobal.net', 1, 'Jon', 'Jon', TRUE, 4, '9167851222', 2, 2, 'e5fbe888-03ff-4d3f-a423-df04efcd0341', '1_1411256310429', NULL),
(2, 50, NULL, NULL, TIMESTAMP '2014-09-20 16:38:52.338', TIMESTAMP '2014-09-20 16:39:30.368', '', '', 1, 'jay.blanton@sbcglobal.net', 1, 'Robert', 'Jeffrey', TRUE, 4, '9167851222', 2, 2, '3aed8e8a-1652-4c09-af44-e5e1ce1ff469', '1_1411256332338', NULL),
(3, 15, '', NULL, TIMESTAMP '2014-09-20 16:39:57.943', TIMESTAMP '2014-09-20 16:40:49.113', '', '', 1, 'jay.blanton@sbcglobal.net', 1, 'Jon', 'Jon', TRUE, 3, '9167851222', 2, 2, 'dbb085c6-5220-4d1b-8d17-b82faa004b0f', '1_1411256397943', NULL),
(4, 5, NULL, NULL, TIMESTAMP '2014-09-20 16:40:30.236', TIMESTAMP '2014-09-20 16:40:53.688', '', '', 1, 'jay.blanton@sbcglobal.net', 1, 'Jon', 'Jon', TRUE, 1, '5551116666', 2, 2, '40ce0dd2-7681-4320-beb8-624b348c33d0', '1_1411256430236', NULL),
(33, 50, '', NULL, TIMESTAMP '2014-10-05 18:34:36.834', NULL, '', '', 1, 'jay.blanton@sbcglobal.net', 1, 'Grandma', 'Smith', TRUE, 41, '9991119999', 1, 2, 'a224363e-05c6-4ba0-b3dd-bf8b5a213296', '1_1412559276834', NULL),
(34, 50, NULL, '3003', TIMESTAMP '2014-10-06 07:15:07.475', NULL, '', '', 1, 'jay.blanton@sbcglobal.net', 41, 'Jon', 'Granny', FALSE, 67, '9167851222', 0, 1, 'AA49315-2FD8FFAC-9A0E-463D-8CFC-58CEEA0E768A', '41_1412604907475', NULL),
(35, 100, '', NULL, TIMESTAMP '2014-10-06 07:16:43.405', TIMESTAMP '2014-10-06 07:16:43.407', '', '', 1, 'jay.blanton@sbcglobal.net', 33, 'Grandma', 'Granny', FALSE, 42, '9165551222', 2, 3, NULL, '33_1412605003405', NULL),
(36, 20, '1111', NULL, TIMESTAMP '2014-10-06 07:17:36.108', NULL, '', '', 1, 'jay.blanton@sbcglobal.net', 33, 'Jon', 'Jeffrey', TRUE, 42, '9167851222', 1, 2, '5a6e6ff0-ad6f-4ab0-abd3-e36b0371b663', '33_1412605056108', NULL);
CREATE INDEX PUBLIC.IX_DONATION_EVENT_1 ON PUBLIC.DONATION(EVENT_ID);
CREATE INDEX PUBLIC.IX_DONATION_PFP_2 ON PUBLIC.DONATION(PFP_ID);
CREATE MEMORY TABLE PUBLIC.EVENT(
    ID BIGINT NOT NULL,
    CITY VARCHAR(255),
    CONTENT TEXT,
    DATE_CREATED TIMESTAMP,
    EVENT_START TIMESTAMP,
    EVENT_END TIMESTAMP,
    FUNDRAISING_END TIMESTAMP,
    FUNDRAISING_START TIMESTAMP,
    GOAL INTEGER,
    HERO_IMG_URL VARCHAR(255),
    IMG_URL VARCHAR(255),
    NAME VARCHAR(255),
    SCHOOL_ID VARCHAR(255),
    SLUG VARCHAR(255),
    STATE VARCHAR(255),
    STATUS INTEGER,
    TITLE VARCHAR(255),
    TOTAL INTEGER,
    GENERALPFPID BIGINT,
    SPONSORPFPID BIGINT,
    USER_ADMIN_ID BIGINT NOT NULL,
    ZIP_CODE VARCHAR(255)
);
ALTER TABLE PUBLIC.EVENT ADD CONSTRAINT PUBLIC.PK_EVENT PRIMARY KEY(ID);
-- 3 +/- SELECT COUNT(*) FROM PUBLIC.EVENT;
INSERT INTO PUBLIC.EVENT(ID, CITY, CONTENT, DATE_CREATED, EVENT_START, EVENT_END, FUNDRAISING_END, FUNDRAISING_START, GOAL, HERO_IMG_URL, IMG_URL, NAME, SCHOOL_ID, SLUG, STATE, STATUS, TITLE, TOTAL, GENERALPFPID, SPONSORPFPID, USER_ADMIN_ID, ZIP_CODE) VALUES
(1, 'Some City', STRINGDECODE('\r\n1 Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven&#39;t heard of them accusamus labore sustainable VHS.\r\n'), TIMESTAMP '2014-09-20 15:56:18.793', TIMESTAMP '2014-12-25 00:00:00.0', NULL, TIMESTAMP '2014-12-29 00:00:00.0', TIMESTAMP '2014-09-01 00:00:00.0', 20002, 'https://scholasticchallenge-files.s3.amazonaws.com/images/defaultHeroSlider.jpg', NULL, 'Great Jogathon', 'Russell Rowdy School', '9fhxM@1', 'AK', 3, 'Event - Great Jogathon', 0, 1, 2, 3, '12322'),
(33, 'Folsom', STRINGDECODE('\r\n1 Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven&#39;t heard of them accusamus labore sustainable VHS.\r\n'), TIMESTAMP '2014-09-20 16:06:54.111', TIMESTAMP '2014-12-25 00:00:00.0', NULL, TIMESTAMP '2014-12-28 00:00:00.0', TIMESTAMP '2014-09-01 00:00:00.0', 2000, 'https://scholasticchallenge-files.s3.amazonaws.com/images/defaultHeroSlider.jpg', NULL, 'Harvest Run', 'Russell Rowdy School', '52QWT8@33', 'AK', 3, 'Event - Harvest Run', 0, 33, 34, 3, '88888'),
(41, 'Folsom', STRINGDECODE('\r\n1 Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven&#39;t heard of them accusamus labore sustainable VHS.\r\n'), TIMESTAMP '2014-10-06 07:10:54.165', TIMESTAMP '2014-12-23 00:00:00.0', NULL, TIMESTAMP '2014-12-28 00:00:00.0', TIMESTAMP '2014-10-05 00:00:00.0', 2000, 'https://s3.amazonaws.com/scholasticchallenge-images/dynamic/bd0c6f0b-d284-4ac4-bf9b-7710eca18c95/delete_icon.jpg', 'https://s3.amazonaws.com/scholasticchallenge-images/dynamic/05564ee4-7f9f-46b9-9c1a-b0c5a878c944/Our_Story.png', 'Hop-a-thon', 'Russell Town School', '6HC8GB@41', 'AK', 3, 'Event - Hop-a-thon', 0, 67, 68, 3, '12322');
CREATE INDEX PUBLIC.IX_EVENT_GENERALFUND_3 ON PUBLIC.EVENT(GENERALPFPID);
CREATE INDEX PUBLIC.IX_EVENT_SPONSORFUND_4 ON PUBLIC.EVENT(SPONSORPFPID);
CREATE INDEX PUBLIC.IX_EVENT_USERADMIN_5 ON PUBLIC.EVENT(USER_ADMIN_ID);
CREATE MEMORY TABLE PUBLIC.EVENT_PAGES(
    ID BIGINT NOT NULL,
    CONTENT TEXT,
    EVENTID BIGINT,
    NAME VARCHAR(255),
    TITLE VARCHAR(255)
);
ALTER TABLE PUBLIC.EVENT_PAGES ADD CONSTRAINT PUBLIC.PK_EVENT_PAGES PRIMARY KEY(ID);
-- 2 +/- SELECT COUNT(*) FROM PUBLIC.EVENT_PAGES;
INSERT INTO PUBLIC.EVENT_PAGES(ID, CONTENT, EVENTID, NAME, TITLE) VALUES
(1, STRINGDECODE('\r\n1 Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven&#39;t heard of them accusamus labore sustainable VHS.\r\n'), 1, 'How your money works', 'How your money works'),
(33, STRINGDECODE('\r\n1 Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven&#39;t heard of them accusamus labore sustainable VHS.\r\n'), 41, 'How your money works', 'How your money works');
CREATE MEMORY TABLE PUBLIC.LINKED_ACCOUNT(
    ID BIGINT NOT NULL,
    PROVIDER_KEY VARCHAR(255),
    PROVIDER_USER_ID VARCHAR(255),
    USER_ID BIGINT
);
ALTER TABLE PUBLIC.LINKED_ACCOUNT ADD CONSTRAINT PUBLIC.PK_LINKED_ACCOUNT PRIMARY KEY(ID);
-- 4 +/- SELECT COUNT(*) FROM PUBLIC.LINKED_ACCOUNT;
INSERT INTO PUBLIC.LINKED_ACCOUNT(ID, PROVIDER_KEY, PROVIDER_USER_ID, USER_ID) VALUES
(1, 'password', '$2a$12$dWtUTAsudnjqRGjKeKTA5.TPMa55fciV1LMtXnAhXUjVNWMIWCpIO', 1),
(2, 'password', '$2a$12$Ha5ry6vm81ZvqEKyfsjKZu/w1in86omZew0BO1lPpSq.9Gwog/mxS', 2),
(3, 'uniqueid', '$2a$12$OFCS8vJUmTEYHm6f0Z6YyeBBwAnf8arw8XuiMoGwux9fUB1Gr/49i', 3),
(4, 'password', '$2a$12$T/Vk9Z6.7FKsxWO3BNTiheSbgeGOCQySRHzbbzA7hA6jOSepy8TC2', 4);
CREATE INDEX PUBLIC.IX_LINKED_ACCOUNT_USER_6 ON PUBLIC.LINKED_ACCOUNT(USER_ID);
CREATE MEMORY TABLE PUBLIC.MERGED_ACCOUNT(
    ID BIGINT NOT NULL,
    USER_ID BIGINT NOT NULL,
    AUTH_USER_ID BIGINT,
    EMAIL VARCHAR(255)
);
ALTER TABLE PUBLIC.MERGED_ACCOUNT ADD CONSTRAINT PUBLIC.PK_MERGED_ACCOUNT PRIMARY KEY(ID);
-- 0 +/- SELECT COUNT(*) FROM PUBLIC.MERGED_ACCOUNT;
CREATE INDEX PUBLIC.IX_MERGED_ACCOUNT_USERS_7 ON PUBLIC.MERGED_ACCOUNT(USER_ID);
CREATE MEMORY TABLE PUBLIC.ORGANIZATION(
    ID BIGINT NOT NULL,
    ADDRESS VARCHAR(255),
    CITY VARCHAR(255),
    NAME VARCHAR(255),
    PHONE VARCHAR(255),
    STATE VARCHAR(255),
    TAX_ID BIGINT,
    ZIP VARCHAR(255)
);
ALTER TABLE PUBLIC.ORGANIZATION ADD CONSTRAINT PUBLIC.PK_ORGANIZATION PRIMARY KEY(ID);
-- 1 +/- SELECT COUNT(*) FROM PUBLIC.ORGANIZATION;
INSERT INTO PUBLIC.ORGANIZATION(ID, ADDRESS, CITY, NAME, PHONE, STATE, TAX_ID, ZIP) VALUES
(1, '1111 Fork Avenue', 'Folsom', 'Help the Kids', '9169991111', 'CA', 111222333, '95630');
CREATE MEMORY TABLE PUBLIC.PFP(
    ID BIGINT NOT NULL,
    CONTENT TEXT,
    DATE_CREATED TIMESTAMP,
    EMERGENCY_CONTACT VARCHAR(255),
    EMERGENCY_CONTACT_PHONE VARCHAR(255),
    EVENT_ID BIGINT NOT NULL,
    GOAL INTEGER,
    HERO_IMG_URL VARCHAR(255),
    IMG_URL VARCHAR(255),
    NAME VARCHAR(255),
    PFP_TYPE INTEGER,
    PRIVATE_ACCT BOOLEAN,
    SLUG VARCHAR(255),
    TEAM_ID BIGINT,
    TITLE VARCHAR(255),
    TOTAL INTEGER,
    USER_ADMIN_ID BIGINT NOT NULL
);
ALTER TABLE PUBLIC.PFP ADD CONSTRAINT PUBLIC.PK_PFP PRIMARY KEY(ID);
-- 14 +/- SELECT COUNT(*) FROM PUBLIC.PFP;
INSERT INTO PUBLIC.PFP(ID, CONTENT, DATE_CREATED, EMERGENCY_CONTACT, EMERGENCY_CONTACT_PHONE, EVENT_ID, GOAL, HERO_IMG_URL, IMG_URL, NAME, PFP_TYPE, PRIVATE_ACCT, SLUG, TEAM_ID, TITLE, TOTAL, USER_ADMIN_ID) VALUES
(1, STRINGDECODE('\r\n1 Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven&#39;t heard of them accusamus labore sustainable VHS.\r\n'), TIMESTAMP '2014-09-20 15:56:18.803', NULL, NULL, 1, 2000, 'https://scholasticchallenge-files.s3.amazonaws.com/images/defaultHeroSlider.jpg', NULL, 'General Fund', 2, FALSE, '9fhxM@1', NULL, 'General Fund', 0, 3),
(2, STRINGDECODE('\r\n1 Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven&#39;t heard of them accusamus labore sustainable VHS.\r\n'), TIMESTAMP '2014-09-20 15:56:18.823', NULL, NULL, 1, 2000, 'https://scholasticchallenge-files.s3.amazonaws.com/images/defaultHeroSlider.jpg', NULL, 'Sponsor Fund', 3, FALSE, 'KUDTI@2', NULL, 'Sponsor Fund', 0, 3),
(3, 'I am participating in this years Great Jogathon event. I am asking you to join me in the effort to support education and our school by making a contribution to support my efforts. The money I raise will be supporting all the students in our school. Because education is so important to me I am challenging myself to raise 2000. As my friends and family make donations to my personal fundraising page my apple tree will grow and flourish. I will be watching and working very hard to not only grow one tree but an entire orchard by exceeding my goal. With your help I will be successful. So please help me add an apple to my tree. To make a donation click the red donate button at the top of the page. Whatever you can give will help! Thank You! Jay Aws.', TIMESTAMP '2014-09-20 15:58:23.498', 'Sample', '9995551234', 1, 200, NULL, NULL, 'Jay Aws', 1, TRUE, 'TKkzD@3', 1, 'Event - Jay Aws', 0, 4),
(4, 'I am participating in this years Great Jogathon event. I am asking you to join me in the effort to support education and our school by making a contribution to support my efforts. The money I raise will be supporting all the students in our school. Because education is so important to me I am challenging myself to raise 500. As my friends and family make donations to my personal fundraising page my apple tree will grow and flourish. I will be watching and working very hard to not only grow one tree but an entire orchard by exceeding my goal. With your help I will be successful. So please help me add an apple to my tree. To make a donation click the red donate button at the top of the page. Whatever you can give will help! Thank You! Jon Jonson.', TIMESTAMP '2014-09-20 15:58:39.716', 'Sample', '9165559999', 1, 500, NULL, NULL, 'Jon Jonson', 1, FALSE, 'd9HV8@4', 34, 'Event - Jon Jonson', 0, 4),
(33, STRINGDECODE('\r\n1 Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven&#39;t heard of them accusamus labore sustainable VHS.\r\n'), TIMESTAMP '2014-09-20 16:06:54.12', NULL, NULL, 33, 2000, 'https://scholasticchallenge-files.s3.amazonaws.com/images/defaultHeroSlider.jpg', NULL, 'General Fund', 2, FALSE, '52QWT8@33', NULL, 'General Fund', 0, 3);
INSERT INTO PUBLIC.PFP(ID, CONTENT, DATE_CREATED, EMERGENCY_CONTACT, EMERGENCY_CONTACT_PHONE, EVENT_ID, GOAL, HERO_IMG_URL, IMG_URL, NAME, PFP_TYPE, PRIVATE_ACCT, SLUG, TEAM_ID, TITLE, TOTAL, USER_ADMIN_ID) VALUES
(34, STRINGDECODE('\r\n1 Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven&#39;t heard of them accusamus labore sustainable VHS.\r\n'), TIMESTAMP '2014-09-20 16:06:54.139', NULL, NULL, 33, 2000, 'https://scholasticchallenge-files.s3.amazonaws.com/images/defaultHeroSlider.jpg', NULL, 'Sponsor Fund', 3, FALSE, '5CH2z4@34', NULL, 'Sponsor Fund', 0, 3),
(41, 'I am participating in this years Great Jogathon event. I am asking you to join me in the effort to support education and our school by making a contribution to support my efforts. The money I raise will be supporting all the students in our school. Because education is so important to me I am challenging myself to raise 300. As my friends and family make donations to my personal fundraising page my apple tree will grow and flourish. I will be watching and working very hard to not only grow one tree but an entire orchard by exceeding my goal. With your help I will be successful. So please help me add an apple to my tree. To make a donation click the red donate button at the top of the page. Whatever you can give will help! Thank You! Landon Smith.', TIMESTAMP '2014-09-22 19:40:59.217', 'Danny Jonson', '9995551234', 1, 300, NULL, NULL, 'Landon Smith', 1, FALSE, '6H6qXQ@41', 1, 'Event - Landon Smith', 0, 4),
(42, 'I am participating in this years Harvest Run event. I am asking you to join me in the effort to support education and our school by making a contribution to support my efforts. The money I raise will be supporting all the students in our school. Because education is so important to me I am challenging myself to raise 150. As my friends and family make donations to my personal fundraising page my apple tree will grow and flourish. I will be watching and working very hard to not only grow one tree but an entire orchard by exceeding my goal. With your help I will be successful. So please help me add an apple to my tree. To make a donation click the red donate button at the top of the page. Whatever you can give will help! Thank You! Sandy Duncon.', TIMESTAMP '2014-09-22 19:41:21.906', 'Sample', '9995551234', 33, 150, NULL, NULL, 'Sandy Duncon', 1, FALSE, '6PxN3M@42', 33, 'Event - Sandy Duncon', 0, 4),
(43, 'I am participating in this years Harvest Run event. I am asking you to join me in the effort to support education and our school by making a contribution to support my efforts. The money I raise will be supporting all the students in our school. Because education is so important to me I am challenging myself to raise 340. As my friends and family make donations to my personal fundraising page my apple tree will grow and flourish. I will be watching and working very hard to not only grow one tree but an entire orchard by exceeding my goal. With your help I will be successful. So please help me add an apple to my tree. To make a donation click the red donate button at the top of the page. Whatever you can give will help! Thank You! Fill Jon.', TIMESTAMP '2014-09-22 19:41:36.349', 'Danny Jonson', '9995551234', 33, 340, NULL, NULL, 'Fill Jon', 1, FALSE, '6YntZI@43', 41, 'Event - Fill Jon', 0, 4),
(44, 'I am participating in this years Harvest Run event. I am asking you to join me in the effort to support education and our school by making a contribution to support my efforts. The money I raise will be supporting all the students in our school. Because education is so important to me I am challenging myself to raise 340. As my friends and family make donations to my personal fundraising page my apple tree will grow and flourish. I will be watching and working very hard to not only grow one tree but an entire orchard by exceeding my goal. With your help I will be successful. So please help me add an apple to my tree. To make a donation click the red donate button at the top of the page. Whatever you can give will help! Thank You! Wayne Jon.', TIMESTAMP '2014-09-22 19:41:49.537', 'Sample', '9995551234', 33, 340, NULL, NULL, 'Wayne Jon', 1, TRUE, '6jdQ5D@44', 33, 'Event - Wayne Jon', 0, 4);
INSERT INTO PUBLIC.PFP(ID, CONTENT, DATE_CREATED, EMERGENCY_CONTACT, EMERGENCY_CONTACT_PHONE, EVENT_ID, GOAL, HERO_IMG_URL, IMG_URL, NAME, PFP_TYPE, PRIVATE_ACCT, SLUG, TEAM_ID, TITLE, TOTAL, USER_ADMIN_ID) VALUES
(65, 'I am participating in this years Great Jogathon event. I am asking you to join me in the effort to support education and our school by making a contribution to support my efforts. The money I raise will be supporting all the students in our school. Because education is so important to me I am challenging myself to raise 500. As my friends and family make donations to my personal fundraising page my apple tree will grow and flourish. I will be watching and working very hard to not only grow one tree but an entire orchard by exceeding my goal. With your help I will be successful. So please help me add an apple to my tree. To make a donation click the red donate button at the top of the page. Whatever you can give will help! Thank You! Jay Pfp.', TIMESTAMP '2014-10-06 07:07:59.593', 'Danny Jonson', '9995551234', 1, 500, 'https://s3.amazonaws.com/scholasticchallenge-images/dynamic/1455200c-837f-4ca2-ba34-85dcea7a101b/delete_icon.jpg', NULL, 'Jay Pfp', 1, FALSE, '9vHmdW@65', 1, 'Event - Jay Pfp', 0, 4),
(66, 'I am participating in this years Great Jogathon event. I am asking you to join me in the effort to support education and our school by making a contribution to support my efforts. The money I raise will be supporting all the students in our school. Because education is so important to me I am challenging myself to raise 300. As my friends and family make donations to my personal fundraising page my apple tree will grow and flourish. I will be watching and working very hard to not only grow one tree but an entire orchard by exceeding my goal. With your help I will be successful. So please help me add an apple to my tree. To make a donation click the red donate button at the top of the page. Whatever you can give will help! Thank You! Skip Johnson.', TIMESTAMP '2014-10-06 07:08:32.656', 'Tammy Thompson', '9165559999', 1, 300, NULL, 'https://s3.amazonaws.com/scholasticchallenge-images/dynamic/3772863e-c022-45c0-a575-a1b3e67e6e92/Our_Mission.png', 'Skip Johnson', 1, TRUE, 'B46J8S@66', 34, 'Event - Skip Johnson', 0, 4),
(67, STRINGDECODE('\r\n1 Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven&#39;t heard of them accusamus labore sustainable VHS.\r\n'), TIMESTAMP '2014-10-06 07:10:54.174', NULL, NULL, 41, 2000, 'https://s3.amazonaws.com/scholasticchallenge-images/dynamic/bd0c6f0b-d284-4ac4-bf9b-7710eca18c95/delete_icon.jpg', 'https://s3.amazonaws.com/scholasticchallenge-images/dynamic/05564ee4-7f9f-46b9-9c1a-b0c5a878c944/Our_Story.png', 'General Fund', 2, FALSE, 'BDwpgO@67', NULL, 'General Fund', 0, 3),
(68, STRINGDECODE('\r\n1 Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven&#39;t heard of them accusamus labore sustainable VHS.\r\n'), TIMESTAMP '2014-10-06 07:10:54.184', NULL, NULL, 41, 2000, 'https://s3.amazonaws.com/scholasticchallenge-images/dynamic/bd0c6f0b-d284-4ac4-bf9b-7710eca18c95/delete_icon.jpg', 'https://s3.amazonaws.com/scholasticchallenge-images/dynamic/05564ee4-7f9f-46b9-9c1a-b0c5a878c944/Our_Story.png', 'Sponsor Fund', 3, FALSE, 'BNnMBK@68', NULL, 'Sponsor Fund', 0, 3);
CREATE INDEX PUBLIC.IX_PFP_EVENT_8 ON PUBLIC.PFP(EVENT_ID);
CREATE INDEX PUBLIC.IX_PFP_TEAM_9 ON PUBLIC.PFP(TEAM_ID);
CREATE INDEX PUBLIC.IX_PFP_USERADMIN_10 ON PUBLIC.PFP(USER_ADMIN_ID);
CREATE MEMORY TABLE PUBLIC.PRIZE(
    ID BIGINT NOT NULL,
    DESCRIPTION VARCHAR(255),
    AWARDS_ID BIGINT,
    INFO TEXT,
    NAME VARCHAR(255)
);
ALTER TABLE PUBLIC.PRIZE ADD CONSTRAINT PUBLIC.PK_PRIZE PRIMARY KEY(ID);
-- 3 +/- SELECT COUNT(*) FROM PUBLIC.PRIZE;
INSERT INTO PUBLIC.PRIZE(ID, DESCRIPTION, AWARDS_ID, INFO, NAME) VALUES
(1, '', 1, '<p><br /></p>', ''),
(33, 'Number 1 Prize Desc', 33, '<p>asfsd</p><p>asfd</p><p>sad</p><p>sfd</p><p>dsf</p>', 'iPod Touch'),
(34, 'Number 2 Prize Desc', 33, '<p>asdfadsf</p><p><br /></p><p>sdf</p><p>sda</p><p>sadfs</p>', 'Number 2 Prize');
CREATE INDEX PUBLIC.IX_PRIZE_AWARDS_11 ON PUBLIC.PRIZE(AWARDS_ID);
CREATE MEMORY TABLE PUBLIC.SECURITY_ROLE(
    ID BIGINT NOT NULL,
    ROLE_NAME VARCHAR(255)
);
ALTER TABLE PUBLIC.SECURITY_ROLE ADD CONSTRAINT PUBLIC.PK_SECURITY_ROLE PRIMARY KEY(ID);
-- 6 +/- SELECT COUNT(*) FROM PUBLIC.SECURITY_ROLE;
INSERT INTO PUBLIC.SECURITY_ROLE(ID, ROLE_NAME) VALUES
(1, 'rootAdmin'),
(2, 'sysAdmin'),
(3, 'eventAdmin'),
(4, 'eventAssistant'),
(5, 'pfpAdmin'),
(6, 'user');
CREATE MEMORY TABLE PUBLIC.SHIFT(
    ID BIGINT NOT NULL,
    DATE TIMESTAMP,
    DESCRIPTION VARCHAR(255),
    END_TIME TIMESTAMP,
    NAME VARCHAR(255),
    START_TIME TIMESTAMP,
    VOLUNTEER_COUNT INTEGER,
    VOLUNTEERS_ID BIGINT
);
ALTER TABLE PUBLIC.SHIFT ADD CONSTRAINT PUBLIC.PK_SHIFT PRIMARY KEY(ID);
-- 16 +/- SELECT COUNT(*) FROM PUBLIC.SHIFT;
INSERT INTO PUBLIC.SHIFT(ID, DATE, DESCRIPTION, END_TIME, NAME, START_TIME, VOLUNTEER_COUNT, VOLUNTEERS_ID) VALUES
(1, TIMESTAMP '2014-09-01 00:00:00.0', 'This is the fun run', TIMESTAMP '1970-01-01 20:35:00.0', 'Fun run', TIMESTAMP '1970-01-01 20:05:00.0', 5, 1),
(2, TIMESTAMP '2014-09-01 00:00:00.0', 'This is the fun run', TIMESTAMP '1970-01-01 20:35:00.0', 'Fun run 1', TIMESTAMP '1970-01-01 20:05:00.0', 4, 1),
(3, TIMESTAMP '2014-09-01 00:00:00.0', 'This is the fun run', TIMESTAMP '1970-01-01 20:35:00.0', 'Fun run 2', TIMESTAMP '1970-01-01 20:05:00.0', 3, 1),
(4, TIMESTAMP '2014-09-01 00:00:00.0', 'This is the fun run', TIMESTAMP '1970-01-01 20:35:00.0', 'Fun run 3', TIMESTAMP '1970-01-01 20:05:00.0', 2, 1),
(5, TIMESTAMP '2014-09-01 00:00:00.0', 'This is the fun run', TIMESTAMP '1970-01-01 20:35:00.0', 'Fun run 4', TIMESTAMP '1970-01-01 20:05:00.0', 1, 1),
(33, TIMESTAMP '2014-10-31 00:00:00.0', 'This is the fun run', TIMESTAMP '1970-01-01 08:40:00.0', 'Fun run', TIMESTAMP '1970-01-01 07:40:00.0', 3, 41),
(34, TIMESTAMP '2014-10-31 00:00:00.0', 'This is the fun run', TIMESTAMP '1970-01-01 08:40:00.0', 'Fun run 1', TIMESTAMP '1970-01-01 07:40:00.0', 3, 41),
(35, TIMESTAMP '2014-10-31 00:00:00.0', 'This is the fun run', TIMESTAMP '1970-01-01 08:40:00.0', 'Fun run 2', TIMESTAMP '1970-01-01 07:40:00.0', 3, 41),
(36, TIMESTAMP '2014-10-31 00:00:00.0', 'This is the fun run', TIMESTAMP '1970-01-01 08:40:00.0', 'Fun run 3', TIMESTAMP '1970-01-01 07:40:00.0', 3, 41),
(37, TIMESTAMP '2014-10-31 00:00:00.0', 'This is the fun run', TIMESTAMP '1970-01-01 08:40:00.0', 'Fun run 4', TIMESTAMP '1970-01-01 07:40:00.0', 3, 41),
(38, TIMESTAMP '2014-10-31 00:00:00.0', 'This is the fun run', TIMESTAMP '1970-01-01 08:40:00.0', 'Fun run 5', TIMESTAMP '1970-01-01 07:40:00.0', 3, 41),
(39, TIMESTAMP '2014-10-31 00:00:00.0', 'This is the fun run', TIMESTAMP '1970-01-01 08:40:00.0', 'Fun run 6', TIMESTAMP '1970-01-01 07:40:00.0', 3, 41),
(40, TIMESTAMP '2014-10-31 00:00:00.0', 'This is the fun run', TIMESTAMP '1970-01-01 08:40:00.0', 'Fun run 62', TIMESTAMP '1970-01-01 07:40:00.0', 3, 41),
(21, TIMESTAMP '2014-10-31 00:00:00.0', 'This is the fun run', TIMESTAMP '1970-01-01 08:40:00.0', 'Fun run 623', TIMESTAMP '1970-01-01 07:40:00.0', 3, 41),
(22, TIMESTAMP '2014-10-31 00:00:00.0', 'This is the fun run', TIMESTAMP '1970-01-01 08:40:00.0', 'Fun run 6234', TIMESTAMP '1970-01-01 07:40:00.0', 3, 41),
(23, TIMESTAMP '2014-10-31 00:00:00.0', 'This is the fun run', TIMESTAMP '1970-01-01 08:40:00.0', 'Fun run 62345', TIMESTAMP '1970-01-01 07:40:00.0', 3, 41);
CREATE INDEX PUBLIC.IX_SHIFT_VOLUNTEERS_12 ON PUBLIC.SHIFT(VOLUNTEERS_ID);
CREATE MEMORY TABLE PUBLIC.SPONSOR_ITEM(
    ID BIGINT NOT NULL,
    AMOUNT INTEGER,
    DESCRIPTION VARCHAR(255),
    DONATION_ID BIGINT,
    SPONSORS_ID BIGINT,
    TITLE VARCHAR(255)
);
ALTER TABLE PUBLIC.SPONSOR_ITEM ADD CONSTRAINT PUBLIC.PK_SPONSOR_ITEM PRIMARY KEY(ID);
-- 6 +/- SELECT COUNT(*) FROM PUBLIC.SPONSOR_ITEM;
INSERT INTO PUBLIC.SPONSOR_ITEM(ID, AMOUNT, DESCRIPTION, DONATION_ID, SPONSORS_ID, TITLE) VALUES
(1, 300, 'Bounce House', NULL, 1, 'Bounce'),
(2, 200, 'Another', NULL, 1, 'Another'),
(3, 400, 'test', NULL, 1, 'Third'),
(33, 300, 'Bounce House', NULL, 41, 'Bounce'),
(34, 400, 'Another', NULL, 41, 'Another'),
(35, 200, 'test', NULL, 41, 'Tester');
CREATE INDEX PUBLIC.IX_SPONSOR_ITEM_DONATION_13 ON PUBLIC.SPONSOR_ITEM(DONATION_ID);
CREATE INDEX PUBLIC.IX_SPONSOR_ITEM_SPONSORS_14 ON PUBLIC.SPONSOR_ITEM(SPONSORS_ID);
CREATE MEMORY TABLE PUBLIC.SPONSORS(
    ID BIGINT NOT NULL,
    CONTENT TEXT,
    EVENTID BIGINT,
    NAME VARCHAR(255),
    TITLE VARCHAR(255)
);
ALTER TABLE PUBLIC.SPONSORS ADD CONSTRAINT PUBLIC.PK_SPONSORS PRIMARY KEY(ID);
-- 3 +/- SELECT COUNT(*) FROM PUBLIC.SPONSORS;
INSERT INTO PUBLIC.SPONSORS(ID, CONTENT, EVENTID, NAME, TITLE) VALUES
(1, 'At this time there are no sponsorship opportunities available. If you are interested in becoming or having questions about sponsoring the Great Jogathon Please contact the event coordinator.', 1, 'Sponsor', 'Sponsor'),
(33, 'At this time there are no sponsorship opportunities available. If you are interested in becoming or having questions about sponsoring the Harvest Run Please contact the event coordinator.', 33, 'Sponsor', 'Sponsor'),
(41, 'At this time there are no sponsorship opportunities available. If you are interested in becoming or having questions about sponsoring the Hop-a-thon Please contact the event coordinator.', 41, 'Sponsor', 'Sponsor');
CREATE MEMORY TABLE PUBLIC.TEAM(
    ID BIGINT NOT NULL,
    CAPTAIN VARCHAR(255),
    CAPTAIN_EMAIL VARCHAR(255),
    CONTENT TEXT,
    EVENTID BIGINT,
    GOAL INTEGER,
    HERO_IMG_URL VARCHAR(255),
    IMG_URL VARCHAR(255),
    NAME VARCHAR(255),
    TITLE VARCHAR(255)
);
ALTER TABLE PUBLIC.TEAM ADD CONSTRAINT PUBLIC.PK_TEAM PRIMARY KEY(ID);
-- 9 +/- SELECT COUNT(*) FROM PUBLIC.TEAM;
INSERT INTO PUBLIC.TEAM(ID, CAPTAIN, CAPTAIN_EMAIL, CONTENT, EVENTID, GOAL, HERO_IMG_URL, IMG_URL, NAME, TITLE) VALUES
(1, 'Jon Smith', 'bad.bad@bad.com', STRINGDECODE('\r\nThank you for visiting Team &#34;Name&#34; fundraising page. Our goal is to have 100% student participation. If you are a student in our class, please take a moment, with your parents, to register for this year&#39;s Event and to create your own Personal Fundraising Page. Once you have completed the registration, you can get started with fundraising. You can visit your Personal Fundraising Page as you go to check on your own progress and to see messages from your supporters.\r\nWe have awesome raffle prizes for participants and top-fundraisers!\r\nIf you are a visitor to this fundraising page, please consider making a donation to a member of our team and helping them earn prizes or if you prefer you can make a donation to our team, either way the money we raise will go directly to helping our students.\r\nThis is our school&#39;s biggest fundraiser of the year. The funds we raise will be used to provide the best education possible for the students at (name of school) School. This year&#39;s fundraising profits will be used for (list what you the funds will be used for. The more specific you are the greater the likelihood of a visitor making a donation.)\r\nWe are looking forward to a great event on (date)!\r\nThank you for your support!\r\n'), 1, 2000, NULL, NULL, 'Tara Tonga', 'Welcome to the fundraising page for Tara Tonga'),
(33, 'Jon Smith', 'bad.bad@bad.com', STRINGDECODE('\r\nThank you for visiting Team &#34;Name&#34; fundraising page. Our goal is to have 100% student participation. If you are a student in our class, please take a moment, with your parents, to register for this year&#39;s Event and to create your own Personal Fundraising Page. Once you have completed the registration, you can get started with fundraising. You can visit your Personal Fundraising Page as you go to check on your own progress and to see messages from your supporters.\r\nWe have awesome raffle prizes for participants and top-fundraisers!\r\nIf you are a visitor to this fundraising page, please consider making a donation to a member of our team and helping them earn prizes or if you prefer you can make a donation to our team, either way the money we raise will go directly to helping our students.\r\nThis is our school&#39;s biggest fundraiser of the year. The funds we raise will be used to provide the best education possible for the students at (name of school) School. This year&#39;s fundraising profits will be used for (list what you the funds will be used for. The more specific you are the greater the likelihood of a visitor making a donation.)\r\nWe are looking forward to a great event on (date)!\r\nThank you for your support!\r\n'), 33, 2000, NULL, NULL, 'Team Lopez', 'Welcome to the fundraising page for Team Lopez'),
(34, 'Jon Smith', 'bad.bad@bad.com', STRINGDECODE('Thank you for visiting Team &#34;Name&#34; fundraising page. Our goal is to have 100% student participation. If you are a student in our class, please take a moment, with your parents, to register for this year&#39;s Event and to create your own Personal Fundraising Page. Once you have completed the registration, you can get started with fundraising. You can visit your Personal Fundraising Page as you go to check on your own progress and to see messages from your supporters.\r\nWe have awesome raffle prizes for participants and top-fundraisers!\r\nIf you are a visitor to this fundraising page, please consider making a donation to a member of our team and helping them earn prizes or if you prefer you can make a donation to our team, either way the money we raise will go directly to helping our students.\r\nThis is our school&#39;s biggest fundraiser of the year. The funds we raise will be used to provide the best education possible for the students at (name of school) School. This year&#39;s fundraising profits will be used for (list what you the funds will be used for. The more specific you are the greater the likelihood of a visitor making a donation.)\r\nWe are looking forward to a great event on (date)!\r\nThank you for your support!\r\n'), 1, 2000, NULL, NULL, 'Team Rocket', 'Welcome to the fundraising page for Team Rocket');
INSERT INTO PUBLIC.TEAM(ID, CAPTAIN, CAPTAIN_EMAIL, CONTENT, EVENTID, GOAL, HERO_IMG_URL, IMG_URL, NAME, TITLE) VALUES
(41, 'Jon Smith', 'bad.bad@bad.com', STRINGDECODE('Thank you for visiting Team &#34;Name&#34; fundraising page. Our goal is to have 100% student participation. If you are a student in our class, please take a moment, with your parents, to register for this year&#39;s Event and to create your own Personal Fundraising Page. Once you have completed the registration, you can get started with fundraising. You can visit your Personal Fundraising Page as you go to check on your own progress and to see messages from your supporters.\r\nWe have awesome raffle prizes for participants and top-fundraisers!\r\nIf you are a visitor to this fundraising page, please consider making a donation to a member of our team and helping them earn prizes or if you prefer you can make a donation to our team, either way the money we raise will go directly to helping our students.\r\nThis is our school&#39;s biggest fundraiser of the year. The funds we raise will be used to provide the best education possible for the students at (name of school) School. This year&#39;s fundraising profits will be used for (list what you the funds will be used for. The more specific you are the greater the likelihood of a visitor making a donation.)\r\nWe are looking forward to a great event on (date)!\r\nThank you for your support!\r\n'), 33, 2000, NULL, NULL, 'Team Teacher', 'Welcome to the fundraising page for Team Teacher'),
(65, 'New Captain', 'bad.bad@bad.com', STRINGDECODE('\r\nThank you for visiting Team &#34;Name&#34; fundraising page. Our goal is to have 100% student participation. If you are a student in our class, please take a moment, with your parents, to register for this year&#39;s Event and to create your own Personal Fundraising Page. Once you have completed the registration, you can get started with fundraising. You can visit your Personal Fundraising Page as you go to check on your own progress and to see messages from your supporters.\r\nWe have awesome raffle prizes for participants and top-fundraisers!\r\nIf you are a visitor to this fundraising page, please consider making a donation to a member of our team and helping them earn prizes or if you prefer you can make a donation to our team, either way the money we raise will go directly to helping our students.\r\nThis is our school&#39;s biggest fundraiser of the year. The funds we raise will be used to provide the best education possible for the students at (name of school) School. This year&#39;s fundraising profits will be used for (list what you the funds will be used for. The more specific you are the greater the likelihood of a visitor making a donation.)\r\nWe are looking forward to a great event on (date)!\r\nThank you for your support!\r\n'), 41, 2000, NULL, NULL, 'Team Rocket', 'Welcome to the fundraising page for Team Rocket'),
(66, 'New Captain', 'bad.bad@bad.com', STRINGDECODE('Thank you for visiting Team &#34;Name&#34; fundraising page. Our goal is to have 100% student participation. If you are a student in our class, please take a moment, with your parents, to register for this year&#39;s Event and to create your own Personal Fundraising Page. Once you have completed the registration, you can get started with fundraising. You can visit your Personal Fundraising Page as you go to check on your own progress and to see messages from your supporters.\r\nWe have awesome raffle prizes for participants and top-fundraisers!\r\nIf you are a visitor to this fundraising page, please consider making a donation to a member of our team and helping them earn prizes or if you prefer you can make a donation to our team, either way the money we raise will go directly to helping our students.\r\nThis is our school&#39;s biggest fundraiser of the year. The funds we raise will be used to provide the best education possible for the students at (name of school) School. This year&#39;s fundraising profits will be used for (list what you the funds will be used for. The more specific you are the greater the likelihood of a visitor making a donation.)\r\nWe are looking forward to a great event on (date)!\r\nThank you for your support!\r\n'), 41, 2000, NULL, NULL, 'Team 1', 'Welcome to the fundraising page for Team 1');
INSERT INTO PUBLIC.TEAM(ID, CAPTAIN, CAPTAIN_EMAIL, CONTENT, EVENTID, GOAL, HERO_IMG_URL, IMG_URL, NAME, TITLE) VALUES
(67, 'New Captain', 'bad.bad@bad.com', STRINGDECODE('Thank you for visiting Team &#34;Name&#34; fundraising page. Our goal is to have 100% student participation. If you are a student in our class, please take a moment, with your parents, to register for this year&#39;s Event and to create your own Personal Fundraising Page. Once you have completed the registration, you can get started with fundraising. You can visit your Personal Fundraising Page as you go to check on your own progress and to see messages from your supporters.\r\nWe have awesome raffle prizes for participants and top-fundraisers!\r\nIf you are a visitor to this fundraising page, please consider making a donation to a member of our team and helping them earn prizes or if you prefer you can make a donation to our team, either way the money we raise will go directly to helping our students.\r\nThis is our school&#39;s biggest fundraiser of the year. The funds we raise will be used to provide the best education possible for the students at (name of school) School. This year&#39;s fundraising profits will be used for (list what you the funds will be used for. The more specific you are the greater the likelihood of a visitor making a donation.)\r\nWe are looking forward to a great event on (date)!\r\nThank you for your support!\r\n'), 41, 2000, NULL, NULL, 'Tara Tonga', 'Welcome to the fundraising page for Tara Tonga'),
(68, 'New Captain', 'bad.bad@bad.com', STRINGDECODE('Thank you for visiting Team &#34;Name&#34; fundraising page. Our goal is to have 100% student participation. If you are a student in our class, please take a moment, with your parents, to register for this year&#39;s Event and to create your own Personal Fundraising Page. Once you have completed the registration, you can get started with fundraising. You can visit your Personal Fundraising Page as you go to check on your own progress and to see messages from your supporters.\r\nWe have awesome raffle prizes for participants and top-fundraisers!\r\nIf you are a visitor to this fundraising page, please consider making a donation to a member of our team and helping them earn prizes or if you prefer you can make a donation to our team, either way the money we raise will go directly to helping our students.\r\nThis is our school&#39;s biggest fundraiser of the year. The funds we raise will be used to provide the best education possible for the students at (name of school) School. This year&#39;s fundraising profits will be used for (list what you the funds will be used for. The more specific you are the greater the likelihood of a visitor making a donation.)\r\nWe are looking forward to a great event on (date)!\r\nThank you for your support!\r\n'), 41, 2000, NULL, NULL, 'Team Lopez', 'Welcome to the fundraising page for Team Lopez'),
(69, 'New Captain', 'bad.bad@bad.com', STRINGDECODE('Thank you for visiting Team &#34;Name&#34; fundraising page. Our goal is to have 100% student participation. If you are a student in our class, please take a moment, with your parents, to register for this year&#39;s Event and to create your own Personal Fundraising Page. Once you have completed the registration, you can get started with fundraising. You can visit your Personal Fundraising Page as you go to check on your own progress and to see messages from your supporters.\r\nWe have awesome raffle prizes for participants and top-fundraisers!\r\nIf you are a visitor to this fundraising page, please consider making a donation to a member of our team and helping them earn prizes or if you prefer you can make a donation to our team, either way the money we raise will go directly to helping our students.\r\nThis is our school&#39;s biggest fundraiser of the year. The funds we raise will be used to provide the best education possible for the students at (name of school) School. This year&#39;s fundraising profits will be used for (list what you the funds will be used for. The more specific you are the greater the likelihood of a visitor making a donation.)\r\nWe are looking forward to a great event on (date)!\r\nThank you for your support!\r\n'), 41, 2000, NULL, NULL, 'Team 2', 'Welcome to the fundraising page for Team 2');
CREATE MEMORY TABLE PUBLIC.TOKEN_ACTION(
    ID BIGINT NOT NULL,
    CREATED TIMESTAMP,
    EXPIRES TIMESTAMP,
    TARGET_USER_ID BIGINT,
    TOKEN VARCHAR(255),
    TYPE VARCHAR(2)
);
ALTER TABLE PUBLIC.TOKEN_ACTION ADD CONSTRAINT PUBLIC.PK_TOKEN_ACTION PRIMARY KEY(ID);
-- 0 +/- SELECT COUNT(*) FROM PUBLIC.TOKEN_ACTION;
CREATE INDEX PUBLIC.IX_TOKEN_ACTION_TARGETUSER_15 ON PUBLIC.TOKEN_ACTION(TARGET_USER_ID);
CREATE MEMORY TABLE PUBLIC.USERS(
    ID BIGINT NOT NULL,
    ACTIVE BOOLEAN,
    AGREE_TO_POLICY BOOLEAN,
    AGREE_TO_REPRESENT BOOLEAN,
    DATE_CREATED TIMESTAMP,
    EMAIL VARCHAR(255),
    EMAIL_VALIDATED BOOLEAN,
    FIRST_NAME VARCHAR(255),
    LAST_LOGIN TIMESTAMP,
    LAST_NAME VARCHAR(255),
    ORGANIZATION_ID BIGINT,
    PHONE VARCHAR(255),
    TAXID BIGINT,
    ZIP VARCHAR(255)
);
ALTER TABLE PUBLIC.USERS ADD CONSTRAINT PUBLIC.PK_USERS PRIMARY KEY(ID);
-- 4 +/- SELECT COUNT(*) FROM PUBLIC.USERS;
INSERT INTO PUBLIC.USERS(ID, ACTIVE, AGREE_TO_POLICY, AGREE_TO_REPRESENT, DATE_CREATED, EMAIL, EMAIL_VALIDATED, FIRST_NAME, LAST_LOGIN, LAST_NAME, ORGANIZATION_ID, PHONE, TAXID, ZIP) VALUES
(1, TRUE, TRUE, NULL, TIMESTAMP '2014-09-20 15:54:20.188', 'jay@scholasticchallenge.com', TRUE, 'Jay', TIMESTAMP '2014-09-20 16:43:50.166', 'Blanton', NULL, NULL, NULL, NULL),
(2, TRUE, TRUE, NULL, TIMESTAMP '2014-09-20 15:54:29.517', 'scott@scholasticchallenge.com', TRUE, 'Scott', TIMESTAMP '2014-09-20 15:54:28.842', 'Ciampi', NULL, NULL, NULL, NULL),
(3, TRUE, TRUE, TRUE, TIMESTAMP '2014-09-20 15:54:39.183', 'jay.blanton@sbcglobal.net', TRUE, 'Jay', TIMESTAMP '2014-10-06 07:16:07.086', 'Event', 1, '9167551111', 111222333, NULL),
(4, TRUE, TRUE, NULL, TIMESTAMP '2014-09-20 15:54:48.403', 'theblantons@sbcglobal.net', TRUE, 'PFP', TIMESTAMP '2014-10-06 07:07:13.309', 'Bmail', NULL, NULL, NULL, NULL);
CREATE INDEX PUBLIC.IX_USERS_ORGANIZATION_16 ON PUBLIC.USERS(ORGANIZATION_ID);
CREATE MEMORY TABLE PUBLIC.USER_PERMISSION(
    ID BIGINT NOT NULL,
    VALUE VARCHAR(255)
);
ALTER TABLE PUBLIC.USER_PERMISSION ADD CONSTRAINT PUBLIC.PK_USER_PERMISSION PRIMARY KEY(ID);
-- 13 +/- SELECT COUNT(*) FROM PUBLIC.USER_PERMISSION;
INSERT INTO PUBLIC.USER_PERMISSION(ID, VALUE) VALUES
(1, 'event.root.edit'),
(2, 'event.donation.edit'),
(3, 'event.sponsor.edit'),
(4, 'event.volunteer.edit'),
(5, 'event.content.edit'),
(6, 'event.pages.edit'),
(7, 'pfp.donation.edit'),
(8, 'pfp.root.edit'),
(9, 'sys.donation.edit'),
(10, 'sys.event.edit'),
(11, 'sys.pfp.edit'),
(12, 'sys.reports.edit'),
(13, 'default.user');
CREATE MEMORY TABLE PUBLIC.VOLUNTEER(
    ID BIGINT NOT NULL,
    ACTIVE BOOLEAN,
    DATE_CREATED TIMESTAMP,
    EMAIL VARCHAR(255),
    FIRST_NAME VARCHAR(255),
    LAST_NAME VARCHAR(255),
    MOBILE VARCHAR(255),
    NOTE VARCHAR(255),
    PHONE VARCHAR(255),
    SHIFT_ID BIGINT
);
ALTER TABLE PUBLIC.VOLUNTEER ADD CONSTRAINT PUBLIC.PK_VOLUNTEER PRIMARY KEY(ID);
-- 0 +/- SELECT COUNT(*) FROM PUBLIC.VOLUNTEER;
CREATE INDEX PUBLIC.IX_VOLUNTEER_SHIFT_17 ON PUBLIC.VOLUNTEER(SHIFT_ID);
CREATE MEMORY TABLE PUBLIC.VOLUNTEERS(
    ID BIGINT NOT NULL,
    CONTENT TEXT,
    EVENTID BIGINT,
    NAME VARCHAR(255),
    TITLE VARCHAR(255)
);
ALTER TABLE PUBLIC.VOLUNTEERS ADD CONSTRAINT PUBLIC.PK_VOLUNTEERS PRIMARY KEY(ID);
-- 3 +/- SELECT COUNT(*) FROM PUBLIC.VOLUNTEERS;
INSERT INTO PUBLIC.VOLUNTEERS(ID, CONTENT, EVENTID, NAME, TITLE) VALUES
(1, 'At this time there are no volunteering opportunities available. If you are interested in becoming or having questions about volunteering at the Great Jogathon Please contact the event coordinator.', 1, 'Volunteer', 'Volunteer'),
(33, 'At this time there are no volunteering opportunities available. If you are interested in becoming or having questions about volunteering at the Harvest Run Please contact the event coordinator.', 33, 'Volunteer', 'Volunteer'),
(41, 'At this time there are no volunteering opportunities available. If you are interested in becoming or having questions about volunteering at the Hop-a-thon Please contact the event coordinator.', 41, 'Volunteer', 'Volunteer');
CREATE MEMORY TABLE PUBLIC.USERS_USER_PERMISSION(
    USERS_ID BIGINT NOT NULL,
    USER_PERMISSION_ID BIGINT NOT NULL
);
ALTER TABLE PUBLIC.USERS_USER_PERMISSION ADD CONSTRAINT PUBLIC.PK_USERS_USER_PERMISSION PRIMARY KEY(USERS_ID, USER_PERMISSION_ID);
-- 33 +/- SELECT COUNT(*) FROM PUBLIC.USERS_USER_PERMISSION;
INSERT INTO PUBLIC.USERS_USER_PERMISSION(USERS_ID, USER_PERMISSION_ID) VALUES
(1, 7),
(1, 1),
(1, 2),
(1, 8),
(1, 13),
(1, 5),
(1, 6),
(1, 9),
(1, 12),
(1, 3),
(1, 10),
(1, 4),
(1, 11),
(2, 7),
(2, 1),
(2, 2),
(2, 8),
(2, 13),
(2, 5),
(2, 6),
(2, 9),
(2, 12),
(2, 3),
(2, 10),
(2, 4),
(2, 11),
(3, 1),
(3, 2),
(3, 3),
(3, 4),
(3, 5),
(3, 6),
(4, 8);
CREATE MEMORY TABLE PUBLIC.USERS_SECURITY_ROLE(
    USERS_ID BIGINT NOT NULL,
    SECURITY_ROLE_ID BIGINT NOT NULL
);
ALTER TABLE PUBLIC.USERS_SECURITY_ROLE ADD CONSTRAINT PUBLIC.PK_USERS_SECURITY_ROLE PRIMARY KEY(USERS_ID, SECURITY_ROLE_ID);
-- 4 +/- SELECT COUNT(*) FROM PUBLIC.USERS_SECURITY_ROLE;
INSERT INTO PUBLIC.USERS_SECURITY_ROLE(USERS_ID, SECURITY_ROLE_ID) VALUES
(1, 1),
(2, 1),
(3, 3),
(4, 5);
DROP TABLE IF EXISTS SYSTEM_LOB_STREAM;
CALL SYSTEM_COMBINE_BLOB(-1);
DROP ALIAS IF EXISTS SYSTEM_COMBINE_CLOB;
DROP ALIAS IF EXISTS SYSTEM_COMBINE_BLOB;
ALTER TABLE PUBLIC.DONATION ADD CONSTRAINT PUBLIC.CK_DONATION_STATUS CHECK(STATUS IN('1', '3', '2', '0')) NOCHECK;
ALTER TABLE PUBLIC.DONATION ADD CONSTRAINT PUBLIC.CK_DONATION_PAYMENT_TYPE CHECK(PAYMENT_TYPE IN('1', '2', '3')) NOCHECK;
ALTER TABLE PUBLIC.DONATION ADD CONSTRAINT PUBLIC.CK_DONATION_DONATION_TYPE CHECK(DONATION_TYPE IN('2', '1', '3')) NOCHECK;
ALTER TABLE PUBLIC.EVENT ADD CONSTRAINT PUBLIC.CK_EVENT_STATUS CHECK(STATUS IN('1', '2', '3', '4')) NOCHECK;
ALTER TABLE PUBLIC.TOKEN_ACTION ADD CONSTRAINT PUBLIC.CK_TOKEN_ACTION_TYPE CHECK(TYPE IN('EV', 'PR')) NOCHECK;
ALTER TABLE PUBLIC.PFP ADD CONSTRAINT PUBLIC.CK_PFP_PFP_TYPE CHECK(PFP_TYPE IN('2', '1', '3')) NOCHECK;
ALTER TABLE PUBLIC.USERS ADD CONSTRAINT PUBLIC.UQ_USERS_TAXID UNIQUE(TAXID);
ALTER TABLE PUBLIC.TOKEN_ACTION ADD CONSTRAINT PUBLIC.UQ_TOKEN_ACTION_TOKEN UNIQUE(TOKEN);
ALTER TABLE PUBLIC.EVENT ADD CONSTRAINT PUBLIC.FK_EVENT_GENERALFUND_3 FOREIGN KEY(GENERALPFPID) REFERENCES PUBLIC.PFP(ID) NOCHECK;
ALTER TABLE PUBLIC.SPONSOR_ITEM ADD CONSTRAINT PUBLIC.FK_SPONSOR_ITEM_DONATION_13 FOREIGN KEY(DONATION_ID) REFERENCES PUBLIC.DONATION(ID) NOCHECK;
ALTER TABLE PUBLIC.VOLUNTEER ADD CONSTRAINT PUBLIC.FK_VOLUNTEER_SHIFT_17 FOREIGN KEY(SHIFT_ID) REFERENCES PUBLIC.SHIFT(ID) NOCHECK;
ALTER TABLE PUBLIC.USERS ADD CONSTRAINT PUBLIC.FK_USERS_ORGANIZATION_16 FOREIGN KEY(ORGANIZATION_ID) REFERENCES PUBLIC.ORGANIZATION(ID) NOCHECK;
ALTER TABLE PUBLIC.USERS_USER_PERMISSION ADD CONSTRAINT PUBLIC.FK_USERS_USER_PERMISSION_USER_02 FOREIGN KEY(USER_PERMISSION_ID) REFERENCES PUBLIC.USER_PERMISSION(ID) NOCHECK;
ALTER TABLE PUBLIC.USERS_USER_PERMISSION ADD CONSTRAINT PUBLIC.FK_USERS_USER_PERMISSION_USER_01 FOREIGN KEY(USERS_ID) REFERENCES PUBLIC.USERS(ID) NOCHECK;
ALTER TABLE PUBLIC.DONATION ADD CONSTRAINT PUBLIC.FK_DONATION_PFP_2 FOREIGN KEY(PFP_ID) REFERENCES PUBLIC.PFP(ID) NOCHECK;
ALTER TABLE PUBLIC.DONATION ADD CONSTRAINT PUBLIC.FK_DONATION_EVENT_1 FOREIGN KEY(EVENT_ID) REFERENCES PUBLIC.EVENT(ID) NOCHECK;
ALTER TABLE PUBLIC.USERS_SECURITY_ROLE ADD CONSTRAINT PUBLIC.FK_USERS_SECURITY_ROLE_SECURI_02 FOREIGN KEY(SECURITY_ROLE_ID) REFERENCES PUBLIC.SECURITY_ROLE(ID) NOCHECK;
ALTER TABLE PUBLIC.LINKED_ACCOUNT ADD CONSTRAINT PUBLIC.FK_LINKED_ACCOUNT_USER_6 FOREIGN KEY(USER_ID) REFERENCES PUBLIC.USERS(ID) NOCHECK;
ALTER TABLE PUBLIC.SPONSOR_ITEM ADD CONSTRAINT PUBLIC.FK_SPONSOR_ITEM_SPONSORS_14 FOREIGN KEY(SPONSORS_ID) REFERENCES PUBLIC.SPONSORS(ID) NOCHECK;
ALTER TABLE PUBLIC.PRIZE ADD CONSTRAINT PUBLIC.FK_PRIZE_AWARDS_11 FOREIGN KEY(AWARDS_ID) REFERENCES PUBLIC.AWARDS(ID) NOCHECK;
ALTER TABLE PUBLIC.EVENT ADD CONSTRAINT PUBLIC.FK_EVENT_USERADMIN_5 FOREIGN KEY(USER_ADMIN_ID) REFERENCES PUBLIC.USERS(ID) NOCHECK;
ALTER TABLE PUBLIC.MERGED_ACCOUNT ADD CONSTRAINT PUBLIC.FK_MERGED_ACCOUNT_USERS_7 FOREIGN KEY(USER_ID) REFERENCES PUBLIC.USERS(ID) NOCHECK;
ALTER TABLE PUBLIC.EVENT ADD CONSTRAINT PUBLIC.FK_EVENT_SPONSORFUND_4 FOREIGN KEY(SPONSORPFPID) REFERENCES PUBLIC.PFP(ID) NOCHECK;
ALTER TABLE PUBLIC.USERS_SECURITY_ROLE ADD CONSTRAINT PUBLIC.FK_USERS_SECURITY_ROLE_USERS_01 FOREIGN KEY(USERS_ID) REFERENCES PUBLIC.USERS(ID) NOCHECK;
ALTER TABLE PUBLIC.PFP ADD CONSTRAINT PUBLIC.FK_PFP_EVENT_8 FOREIGN KEY(EVENT_ID) REFERENCES PUBLIC.EVENT(ID) NOCHECK;
ALTER TABLE PUBLIC.SHIFT ADD CONSTRAINT PUBLIC.FK_SHIFT_VOLUNTEERS_12 FOREIGN KEY(VOLUNTEERS_ID) REFERENCES PUBLIC.VOLUNTEERS(ID) NOCHECK;
ALTER TABLE PUBLIC.PFP ADD CONSTRAINT PUBLIC.FK_PFP_TEAM_9 FOREIGN KEY(TEAM_ID) REFERENCES PUBLIC.TEAM(ID) NOCHECK;
ALTER TABLE PUBLIC.TOKEN_ACTION ADD CONSTRAINT PUBLIC.FK_TOKEN_ACTION_TARGETUSER_15 FOREIGN KEY(TARGET_USER_ID) REFERENCES PUBLIC.USERS(ID) NOCHECK;
ALTER TABLE PUBLIC.PFP ADD CONSTRAINT PUBLIC.FK_PFP_USERADMIN_10 FOREIGN KEY(USER_ADMIN_ID) REFERENCES PUBLIC.USERS(ID) NOCHECK;
