/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     12/10/2019 5:53:13 PM                        */
/*==============================================================*/


drop trigger ON_DELETE_KUPON;

drop trigger ON_INSERT_KUPON;

drop trigger ON_UPDATE_KUPON;

drop trigger ON_DELETE_ITEM_PESANAN;

drop trigger ON_INSERT_ITEM_PESANAN;

drop trigger ON_UPDATE_ITEM_PESANAN;

drop procedure if exists RECALCULATE_TOTAL_ITEM;

alter table ITEM_KUPON 
   drop foreign key FK_ITEM_KUP_MERUPAKAN_PESANAN;

alter table ITEM_KUPON 
   drop foreign key FK_ITEM_KUP_RELATIONS_KUPON;

alter table ITEM_PESANAN 
   drop foreign key FK_ITEM_PES_MEMILIKI__PESANAN;

alter table KUPON 
   drop foreign key FK_KUPON_DIPAKAI_P_PESANAN;

alter table KUPON 
   drop foreign key FK_KUPON_MEMILIKI__CUSTOMER;

alter table PESANAN 
   drop foreign key FK_PESANAN_MEMILIKI__CUSTOMER;

drop table if exists CUSTOMER;


alter table ITEM_KUPON 
   drop foreign key FK_ITEM_KUP_MERUPAKAN_PESANAN;

alter table ITEM_KUPON 
   drop foreign key FK_ITEM_KUP_RELATIONS_KUPON;

drop table if exists ITEM_KUPON;


alter table ITEM_PESANAN 
   drop foreign key FK_ITEM_PES_MEMILIKI__PESANAN;

drop table if exists ITEM_PESANAN;


alter table KUPON 
   drop foreign key FK_KUPON_MEMILIKI__CUSTOMER;

alter table KUPON 
   drop foreign key FK_KUPON_DIPAKAI_P_PESANAN;

drop table if exists KUPON;

drop table if exists PENGELUARAN;


alter table PESANAN 
   drop foreign key FK_PESANAN_MEMILIKI__CUSTOMER;

drop table if exists PESANAN;

/*==============================================================*/
/* Table: CUSTOMER                                              */
/*==============================================================*/
create table CUSTOMER
(
   ID_CUSTOMER          int not null auto_increment  comment '',
   NAMA_CUSTOMER        varchar(50) not null  comment '',
   ALAMAT_CUSTOMER      varchar(100)  comment '',
   TELEPON_CUSTOMER     varchar(16)  comment '',
   primary key (ID_CUSTOMER)
);

/*==============================================================*/
/* Table: ITEM_KUPON                                            */
/*==============================================================*/
create table ITEM_KUPON
(
   ID_PESANAN           int not null  comment '',
   ID_KUPON             int not null  comment '',
   primary key (ID_PESANAN)
);

/*==============================================================*/
/* Table: ITEM_PESANAN                                          */
/*==============================================================*/
create table ITEM_PESANAN
(
   ID_ITEM              int not null auto_increment  comment '',
   ID_PESANAN           int not null  comment '',
   PAKET                varchar(16) not null  comment '',
   UNIT                 varchar(16)  comment '',
   QTY                  int  comment '',
   HARGA                int not null  comment '',
   primary key (ID_ITEM)
);

/*==============================================================*/
/* Table: KUPON                                                 */
/*==============================================================*/
create table KUPON
(
   ID_KUPON             int not null auto_increment  comment '',
   ID_PESANAN           int  comment '',
   ID_CUSTOMER          int  comment '',
   POTONGAN             int not null  comment '',
   primary key (ID_KUPON)
);

/*==============================================================*/
/* Table: PENGELUARAN                                           */
/*==============================================================*/
create table PENGELUARAN
(
   ID_PENGELUARAN       int not null auto_increment  comment '',
   TANGGAL_PENGELUARAN  date not null  comment '',
   ITEM_PENGELUARAN     varchar(50) not null  comment '',
   JUMLAH_PENGELUARAN   int not null  comment '',
   primary key (ID_PENGELUARAN)
);

/*==============================================================*/
/* Table: PESANAN                                               */
/*==============================================================*/
create table PESANAN
(
   ID_PESANAN           int not null auto_increment  comment '',
   ID_CUSTOMER          int not null  comment '',
   TANGGAL_PESANAN      date not null  comment '',
   TANGGAL_LUNAS        date not null  comment '',
   TANGGAL_AMBIL        date not null  comment '',
   SUBTOTAL             int not null  comment '',
   TOTAL                int not null  comment '',
   KETERANGAN           varchar(255)  comment '',
   primary key (ID_PESANAN)
);

alter table ITEM_KUPON add constraint FK_ITEM_KUP_MERUPAKAN_PESANAN foreign key (ID_PESANAN)
      references PESANAN (ID_PESANAN) on delete restrict on update restrict;

alter table ITEM_KUPON add constraint FK_ITEM_KUP_RELATIONS_KUPON foreign key (ID_KUPON)
      references KUPON (ID_KUPON) on delete restrict on update restrict;

alter table ITEM_PESANAN add constraint FK_ITEM_PES_MEMILIKI__PESANAN foreign key (ID_PESANAN)
      references PESANAN (ID_PESANAN) on delete restrict on update restrict;

alter table KUPON add constraint FK_KUPON_DIPAKAI_P_PESANAN foreign key (ID_PESANAN)
      references PESANAN (ID_PESANAN) on delete restrict on update restrict;

alter table KUPON add constraint FK_KUPON_MEMILIKI__CUSTOMER foreign key (ID_CUSTOMER)
      references CUSTOMER (ID_CUSTOMER) on delete restrict on update restrict;

alter table PESANAN add constraint FK_PESANAN_MEMILIKI__CUSTOMER foreign key (ID_CUSTOMER)
      references CUSTOMER (ID_CUSTOMER) on delete restrict on update restrict;


DELIMITER //
create procedure RECALCULATE_TOTAL_ITEM(ID_PESANAN INTEGER)
begin
    UPDATE pesanan p
    SET p.subtotal = (
            SELECT SUM(ip.HARGA) 
            FROM item_pesanan ip 
            WHERE ip.ID_PESANAN=ID_PESANAN
        ),
        p.total = p.subtotal - IF(
            EXISTS(
                SELECT TRUE
                FROM kupon k
                WHERE k.ID_PESANAN=ID_PESANAN
            ), (
                SELECT k.POTONGAN
                FROM kupon k
                WHERE k.ID_PESANAN=ID_PESANAN
            ), 0
        )
    WHERE p.ID_PESANAN=ID_PESANAN;
end//
DELIMITER ;


DELIMITER //
create trigger ON_DELETE_KUPON after delete
on ITEM_KUPON for each row
begin
    CALL RECALCULATE_TOTAL_ITEM(OLD.ID_PESANAN);
end//
DELIMITER ;


DELIMITER //
create trigger ON_INSERT_KUPON after insert
on ITEM_KUPON for each row
begin
    CALL RECALCULATE_TOTAL_ITEM(NEW.ID_PESANAN);
end//
DELIMITER ;


DELIMITER //
create trigger ON_UPDATE_KUPON after update
on ITEM_KUPON for each row
begin
    CALL RECALCULATE_TOTAL_ITEM(NEW.ID_PESANAN);
end//
DELIMITER ;


DELIMITER //
create trigger ON_DELETE_ITEM_PESANAN after delete
on ITEM_PESANAN for each row
begin
    CALL RECALCULATE_TOTAL_ITEM(OLD.ID_PESANAN);
end//
DELIMITER ;


DELIMITER //
create trigger ON_INSERT_ITEM_PESANAN after insert
on ITEM_PESANAN for each row
begin
    CALL RECALCULATE_TOTAL_ITEM(NEW.ID_PESANAN);
end//
DELIMITER ;


DELIMITER //
create trigger ON_UPDATE_ITEM_PESANAN after update
on ITEM_PESANAN for each row
begin
    CALL RECALCULATE_TOTAL_ITEM(NEW.ID_PESANAN);
end//
DELIMITER ;

