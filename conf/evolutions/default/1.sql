# --- Created by Ebean DDL
# To stop Ebean DDL generation, remove this comment and start using Evolutions

# --- !Ups

create table awards (
  id                        bigint not null,
  content                   TEXT,
  eventid                   bigint,
  img_url                   varchar(255),
  name                      varchar(255),
  title                     varchar(255),
  constraint pk_awards primary key (id))
;

create table donation (
  id                        bigint not null,
  amount                    integer,
  check_num                 varchar(255),
  cc_digits                 varchar(255),
  date_created              timestamp,
  date_paid                 timestamp,
  donor_message             varchar(255),
  donor_name                varchar(255),
  donation_type             integer,
  email                     varchar(255),
  event_id                  bigint not null,
  first_name                varchar(255),
  last_name                 varchar(255),
  pay_by_check              boolean,
  pfp_id                    bigint,
  phone                     varchar(255),
  status                    integer,
  payment_type              integer,
  transaction_number        varchar(255),
  invoice_number            varchar(255),
  zip_code                  varchar(255),
  constraint ck_donation_donation_type check (donation_type in ('2','1','3')),
  constraint ck_donation_status check (status in ('1','3','2','0')),
  constraint ck_donation_payment_type check (payment_type in ('1','2','3')),
  constraint pk_donation primary key (id))
;



create table event (
  id                        bigint not null,
  city                      varchar(255),
  content                   TEXT,
  date_created              timestamp,
  event_start               timestamp,
  event_end                 timestamp,
  fundraising_end           timestamp,
  fundraising_start         timestamp,
  goal                      integer,
  hero_img_url              varchar(255),
  img_url                   varchar(255),
  name                      varchar(255),
  school_id                 varchar(255),
  slug                      varchar(255),
  state                     varchar(255),
  status                    integer,
  title                     varchar(255),
  total                     integer,
  generalPfpId              bigint,
  sponsorPfpId              bigint,
  user_admin_id             bigint not null,
  zip_code                  varchar(255),
  constraint ck_event_status check (status in ('1','2','3','4')),
  constraint pk_event primary key (id))
;

create table event_pages (
  id                        bigint not null,
  content                   TEXT,
  eventid                   bigint,
  name                      varchar(255),
  title                     varchar(255),
  constraint pk_event_pages primary key (id))
;

create table linked_account (
  id                        bigint not null,
  provider_key              varchar(255),
  provider_user_id          varchar(255),
  user_id                   bigint,
  constraint pk_linked_account primary key (id))
;

create table merged_account (
  id                        bigint not null,
  user_id                   bigint not null,
  auth_user_id              bigint,
  email                     varchar(255),
  constraint pk_merged_account primary key (id))
;

create table organization (
  id                        bigint not null,
  address                   varchar(255),
  city                      varchar(255),
  name                      varchar(255),
  phone                     varchar(255),
  state                     varchar(255),
  tax_id                    bigint,
  zip                       varchar(255),
  constraint pk_organization primary key (id))
;

create table pfp (
  id                        bigint not null,
  content                   TEXT,
  date_created              timestamp,
  emergency_contact         varchar(255),
  emergency_contact_phone   varchar(255),
  event_id                  bigint not null,
  goal                      integer,
  hero_img_url              varchar(255),
  img_url                   varchar(255),
  name                      varchar(255),
  pfp_type                  integer,
  private_acct              boolean,
  slug                      varchar(255),
  team_id                   bigint,
  title                     varchar(255),
  total                     integer,
  user_admin_id             bigint not null,
  constraint ck_pfp_pfp_type check (pfp_type in ('2','1','3')),
  constraint pk_pfp primary key (id))
;

create table prize (
  id                        bigint not null,
  description               varchar(255),
  awards_id                 bigint,
  info                      TEXT,
  name                      varchar(255),
  constraint pk_prize primary key (id))
;

create table security_role (
  id                        bigint not null,
  role_name                 varchar(255),
  constraint pk_security_role primary key (id))
;

create table shift (
  id                        bigint not null,
  date                      timestamp,
  description               varchar(255),
  end_time                  timestamp,
  name                      varchar(255),
  start_time                timestamp,
  volunteer_count           integer,
  volunteers_id             bigint,
  constraint pk_shift primary key (id))
;

create table sponsor_item (
  id                        bigint not null,
  amount                    integer,
  description               varchar(255),
  donation_id               bigint,
  sponsors_id               bigint,
  title                     varchar(255),
  constraint pk_sponsor_item primary key (id))
;

create table sponsors (
  id                        bigint not null,
  content                   TEXT,
  eventid                   bigint,
  name                      varchar(255),
  title                     varchar(255),
  constraint pk_sponsors primary key (id))
;

create table team (
  id                        bigint not null,
  captain                   varchar(255),
  captain_email             varchar(255),
  content                   TEXT,
  eventid                   bigint,
  goal                      integer,
  hero_img_url              varchar(255),
  img_url                   varchar(255),
  name                      varchar(255),
  title                     varchar(255),
  constraint pk_team primary key (id))
;

create table token_action (
  id                        bigint not null,
  created                   timestamp,
  expires                   timestamp,
  target_user_id            bigint,
  token                     varchar(255),
  type                      varchar(2),
  constraint ck_token_action_type check (type in ('EV','PR')),
  constraint uq_token_action_token unique (token),
  constraint pk_token_action primary key (id))
;

create table users (
  id                        bigint not null,
  active                    boolean,
  agree_to_policy           boolean,
  agree_to_represent        boolean,
  date_created              timestamp,
  email                     varchar(255),
  email_validated           boolean,
  first_name                varchar(255),
  last_login                timestamp,
  last_name                 varchar(255),
  organization_id           bigint,
  phone                     varchar(255),
  taxid                     bigint,
  zip                       varchar(255),
  constraint uq_users_taxid unique (taxid),
  constraint pk_users primary key (id))
;
<!--===========start=====rimi table creation  for worldpay transaction 27.07.2015=====================---->
create table user_transaction (
id                           bigint not null,
users_id                     bigint not null,
amount                       varchar(255),
transaction_date             varchar(255),
constraint pk_user_transaction primary key (id)



)

<!--===========end=====rimi table creation  for worldpay transaction 27.07.2015=====================---->

create table user_permission (
  id                        bigint not null,

  value                     varchar(255),
  constraint pk_user_permission primary key (id))
;

create table volunteer (
  id                        bigint not null,
  active                    boolean,
  date_created              timestamp,
  email                     varchar(255),
  first_name                varchar(255),
  last_name                 varchar(255),
  mobile                    varchar(255),
  note                      varchar(255),
  phone                     varchar(255),
  shift_id                  bigint,
  constraint pk_volunteer primary key (id))
;

create table volunteers (
  id                        bigint not null,
  content                   TEXT,
  eventid                   bigint,
  name                      varchar(255),
  title                     varchar(255),
  constraint pk_volunteers primary key (id))
;


create table users_user_permission (
  users_id                       bigint not null,
  user_permission_id             bigint not null,
  constraint pk_users_user_permission primary key (users_id, user_permission_id))
;

create table users_security_role (
  users_id                       bigint not null,
  security_role_id               bigint not null,
  constraint pk_users_security_role primary key (users_id, security_role_id))
;
create sequence awards_seq;

create sequence donation_seq;

create sequence event_seq;

create sequence event_pages_seq;

create sequence linked_account_seq;

create sequence merged_account_seq;

create sequence organization_seq;

create sequence pfp_seq;

create sequence prize_seq;

create sequence security_role_seq;

create sequence shift_seq;

create sequence sponsor_item_seq;

create sequence sponsors_seq;

create sequence team_seq;

create sequence token_action_seq;

create sequence users_seq;

create sequence user_permission_seq;

create sequence volunteer_seq;

create sequence volunteers_seq;

alter table donation add constraint fk_donation_event_1 foreign key (event_id) references event (id) on delete restrict on update restrict;
create index ix_donation_event_1 on donation (event_id);
alter table donation add constraint fk_donation_pfp_2 foreign key (pfp_id) references pfp (id) on delete restrict on update restrict;
create index ix_donation_pfp_2 on donation (pfp_id);
alter table event add constraint fk_event_generalFund_3 foreign key (generalPfpId) references pfp (id) on delete restrict on update restrict;
create index ix_event_generalFund_3 on event (generalPfpId);
alter table event add constraint fk_event_sponsorFund_4 foreign key (sponsorPfpId) references pfp (id) on delete restrict on update restrict;
create index ix_event_sponsorFund_4 on event (sponsorPfpId);
alter table event add constraint fk_event_userAdmin_5 foreign key (user_admin_id) references users (id) on delete restrict on update restrict;
create index ix_event_userAdmin_5 on event (user_admin_id);
alter table linked_account add constraint fk_linked_account_user_6 foreign key (user_id) references users (id) on delete restrict on update restrict;
create index ix_linked_account_user_6 on linked_account (user_id);
alter table merged_account add constraint fk_merged_account_users_7 foreign key (user_id) references users (id) on delete restrict on update restrict;
create index ix_merged_account_users_7 on merged_account (user_id);
alter table pfp add constraint fk_pfp_event_8 foreign key (event_id) references event (id) on delete restrict on update restrict;
create index ix_pfp_event_8 on pfp (event_id);
alter table pfp add constraint fk_pfp_team_9 foreign key (team_id) references team (id) on delete restrict on update restrict;
create index ix_pfp_team_9 on pfp (team_id);
alter table pfp add constraint fk_pfp_userAdmin_10 foreign key (user_admin_id) references users (id) on delete restrict on update restrict;
create index ix_pfp_userAdmin_10 on pfp (user_admin_id);
alter table prize add constraint fk_prize_awards_11 foreign key (awards_id) references awards (id) on delete restrict on update restrict;
create index ix_prize_awards_11 on prize (awards_id);
alter table shift add constraint fk_shift_volunteers_12 foreign key (volunteers_id) references volunteers (id) on delete restrict on update restrict;
create index ix_shift_volunteers_12 on shift (volunteers_id);
alter table sponsor_item add constraint fk_sponsor_item_donation_13 foreign key (donation_id) references donation (id) on delete restrict on update restrict;
create index ix_sponsor_item_donation_13 on sponsor_item (donation_id);
alter table sponsor_item add constraint fk_sponsor_item_sponsors_14 foreign key (sponsors_id) references sponsors (id) on delete restrict on update restrict;
create index ix_sponsor_item_sponsors_14 on sponsor_item (sponsors_id);
alter table token_action add constraint fk_token_action_targetUser_15 foreign key (target_user_id) references users (id) on delete restrict on update restrict;
create index ix_token_action_targetUser_15 on token_action (target_user_id);
alter table users add constraint fk_users_organization_16 foreign key (organization_id) references organization (id) on delete restrict on update restrict;
create index ix_users_organization_16 on users (organization_id);
alter table volunteer add constraint fk_volunteer_shift_17 foreign key (shift_id) references shift (id) on delete restrict on update restrict;
create index ix_volunteer_shift_17 on volunteer (shift_id);



alter table users_user_permission add constraint fk_users_user_permission_user_01 foreign key (users_id) references users (id) on delete restrict on update restrict;

alter table users_user_permission add constraint fk_users_user_permission_user_02 foreign key (user_permission_id) references user_permission (id) on delete restrict on update restrict;

alter table users_security_role add constraint fk_users_security_role_users_01 foreign key (users_id) references users (id) on delete restrict on update restrict;

alter table users_security_role add constraint fk_users_security_role_securi_02 foreign key (security_role_id) references security_role (id) on delete restrict on update restrict;
<!--new addition by rimi
alter table user_transaction add constraint fk_user_transaction foreign key (users_id) references users (id) on delete restrict on update restrict;



--alter table donation add participant_name  varchar(255),add participant_id  varchar(255),add team_name  varchar(255),
 --add donor_country  varchar(255),add  card_description  varchar(255),add approval_code  varchar(255),add amount  varchar(255);

# --- !Downs

SET REFERENTIAL_INTEGRITY FALSE;

drop table if exists awards;

drop table if exists donation;

drop table if exists event;

drop table if exists event_pages;

drop table if exists linked_account;

drop table if exists merged_account;

drop table if exists organization;

drop table if exists pfp;

drop table if exists prize;

drop table if exists security_role;

drop table if exists shift;

drop table if exists sponsor_item;

drop table if exists sponsors;

drop table if exists team;

drop table if exists token_action;

drop table if exists users;

drop table if exists users_user_permission;

drop table if exists users_security_role;

drop table if exists user_permission;

drop table if exists volunteer;

drop table if exists volunteers;

SET REFERENTIAL_INTEGRITY TRUE;

drop sequence if exists awards_seq;

drop sequence if exists donation_seq;

drop sequence if exists event_seq;

drop sequence if exists event_pages_seq;

drop sequence if exists linked_account_seq;

drop sequence if exists merged_account_seq;

drop sequence if exists organization_seq;

drop sequence if exists pfp_seq;

drop sequence if exists prize_seq;

drop sequence if exists security_role_seq;

drop sequence if exists shift_seq;

drop sequence if exists sponsor_item_seq;

drop sequence if exists sponsors_seq;

drop sequence if exists team_seq;

drop sequence if exists token_action_seq;

drop sequence if exists users_seq;

drop sequence if exists user_permission_seq;

drop sequence if exists volunteer_seq;

drop sequence if exists volunteers_seq;

