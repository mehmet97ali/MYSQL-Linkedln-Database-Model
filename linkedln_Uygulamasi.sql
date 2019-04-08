CREATE DATABASE linkedln_Uygulamasi;

USE linkedln_Uygulamasi;

CREATE TABLE `linkedln_Uygulamasi`.`users` (
  `user_id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(256) NOT NULL,
  `lname` VARCHAR(256) NOT NULL,
  `password` VARCHAR(256) NOT NULL,
  `language` VARCHAR(256) NOT NULL,
  `email` VARCHAR(256) NOT NULL,
   CONSTRAINT `unique_users` UNIQUE (`email`),
   PRIMARY KEY (`user_id`),
   CONSTRAINT `languageFK` FOREIGN KEY (`language`)
   REFERENCES diller(`dil`)
   ON DELETE CASCADE
   ON UPDATE CASCADE
);

CREATE TABLE `linkedln_Uygulamasi`.`diller` (
  `dil` VARCHAR(256) NOT NULL,
  PRIMARY KEY (`dil`)
);

CREATE TABLE `linkedln_Uygulamasi`.`user_profiles` 
(
	`profile_id` INT(10) UNSIGNED NOT NULL,
    `user_id` INT(10) UNSIGNED NOT NULL,
    `baslik` VARCHAR(256) NOT NULL,
	`yasadigi_yer` VARCHAR(256) NOT NULL,
	`sektor` VARCHAR(256) NOT NULL,
	`ozet` VARCHAR(256) NOT NULL,
	CONSTRAINT `unique_users` UNIQUE (`user_id`),
    PRIMARY KEY (`profile_id`),
    CONSTRAINT `profile_user_idFK` FOREIGN KEY (`user_id`)
    REFERENCES users(`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    CONSTRAINT `yasadigi_yerFK` FOREIGN KEY (`yasadigi_yer`)
    REFERENCES Sehir_Ulke(`sehir_ulke`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    CONSTRAINT `sektorFK` FOREIGN KEY (`sektor`)
    REFERENCES sektorler(`sektor_adi`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);  

CREATE TABLE `linkedln_Uygulamasi`.`yetenekler` (
  `profile_id` INT UNSIGNED NOT NULL,
  `yetenek` VARCHAR(256) NOT NULL,
   CONSTRAINT `unique_yetenekler` UNIQUE (`profile_id`,`yetenek`),
   CONSTRAINT `profilFK` FOREIGN KEY (`profile_id`)
   REFERENCES user_profiles(`profile_id`)
   ON DELETE CASCADE
   ON UPDATE CASCADE
);

CREATE TABLE `linkedln_Uygulamasi`.`egitimler` (
  `profile_id` INT UNSIGNED NOT NULL,
  `okul` VARCHAR(256) NOT NULL,
  `bolum` VARCHAR(256) NOT NULL,
  `basladıgı_tarih` date  NOT NULL,
  `bitirdigi_tarih` date  NOT NULL,
  `acıklama` VARCHAR(256) ,
   CONSTRAINT `profil_FK` FOREIGN KEY (`profile_id`)
   REFERENCES user_profiles(`profile_id`)
   ON DELETE CASCADE
   ON UPDATE CASCADE
);

CREATE TABLE `linkedln_Uygulamasi`.`is_deneyimleri`
(
  `profile_id` INT UNSIGNED NOT NULL,
  `unvan` VARCHAR(256) NOT NULL,
  `sirket_adi` VARCHAR(256) NOT NULL,
  `sektor` VARCHAR(256) NOT NULL,
  `baslangic_tarihi` date NOT NULL,
  `konum` VARCHAR(256) NOT NULL,
  `aciklama` VARCHAR(256) NOT NULL,
   CONSTRAINT `profile_FK` FOREIGN KEY (`profile_id`)
   REFERENCES user_profiles(`profile_id`)
   ON DELETE CASCADE
   ON UPDATE CASCADE,
   CONSTRAINT `konum_deneyimFK` FOREIGN KEY (`konum`)
   REFERENCES Sehir_Ulke(`sehir_ulke`)
   ON DELETE CASCADE
   ON UPDATE CASCADE,
   CONSTRAINT `sektor_is_deneyimFK` FOREIGN KEY (`sektor`)
   REFERENCES sektorler(`sektor_adi`)
   ON DELETE CASCADE
   ON UPDATE CASCADE
);

CREATE TABLE `linkedln_Uygulamasi`.`yetkin_diller`
(
  `profile_id` INT UNSIGNED NOT NULL,
  `dil` VARCHAR(256) NOT NULL,
  `duzey` TINYINT(4) UNSIGNED NOT NULL DEFAULT '0',
   CONSTRAINT `unique_yetkin_diller` UNIQUE (`profile_id`,`dil`),
   CONSTRAINT `dilFK` FOREIGN KEY (`dil`)
   REFERENCES diller(`dil`)
   ON DELETE CASCADE
   ON UPDATE CASCADE,
   CONSTRAINT `diller_profilFK` FOREIGN KEY (`profile_id`)
   REFERENCES user_profiles(`profile_id`)
   ON DELETE CASCADE
   ON UPDATE CASCADE
);


CREATE TABLE `linkedln_Uygulamasi`.`Sehir_Ulke` (
  `sehir_ulke` VARCHAR(256) NOT NULL,
  PRIMARY KEY (`sehir_ulke`)
);

CREATE TABLE `linkedln_Uygulamasi`.`is_ilanlari`
( 
   `is_ilani_id` INT UNSIGNED NOT NULL,
   `user_id` INT UNSIGNED NOT NULL,
   `sirket_adi` VARCHAR(256) NOT NULL,
   `is_basligi` VARCHAR(256) NOT NULL,
   `konum` VARCHAR(256) NOT NULL,
   `sektor` VARCHAR(256) NOT NULL,
   `calisan_turu` TINYINT(4) UNSIGNED NOT NULL DEFAULT '0',
   `aciklama` VARCHAR(256) NOT NULL,
    PRIMARY KEY (`is_ilani_id`),
    CONSTRAINT `is_ilanlari_user_idFK` FOREIGN KEY (`user_id`)
    REFERENCES users(`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    CONSTRAINT `konumFK` FOREIGN KEY (`konum`)
    REFERENCES Sehir_Ulke(`sehir_ulke`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    CONSTRAINT `sektor_is_ilaniFK` FOREIGN KEY (`sektor`)
    REFERENCES sektorler(`sektor_adi`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE  `linkedln_Uygulamasi`.`is_ilani_basvuranlar` 
( 
  `is_ilani_id` INT(10) UNSIGNED NOT NULL,
  `user_id` INT(10) UNSIGNED NOT NULL,
   CONSTRAINT `unique_followed_pages` UNIQUE (`is_ilani_id`,`user_id`),
   CONSTRAINT `is_ilani_idFK` FOREIGN KEY (`is_ilani_id`)
   REFERENCES is_ilanlari(`is_ilani_id`)
   ON DELETE CASCADE
   ON UPDATE CASCADE,
   CONSTRAINT `user_id_basvuruFK` FOREIGN KEY (`user_id`)
   REFERENCES users(`user_id`)
   ON DELETE CASCADE
   ON UPDATE CASCADE
);

DELIMITER //
CREATE TRIGGER is_ilani BEFORE INSERT
ON is_ilani_basvuranlar
FOR EACH ROW
BEGIN
     if exists(select user_id 
               from linkedln_Uygulamasi.is_ilanlari
               where  is_ilanlari.user_id = new.user_id 
               and is_ilanlari.is_ilani_id=new.is_ilani_id) then
        signal sqlstate '45000' set message_text=" iş ilanı yayınlayan kişi kendi ilanına basvuramaz ";
     end if;
   
END//
DELIMITER ;


CREATE TABLE `linkedln_Uygulamasi`.`ayarlar` (
  `user_id` INT UNSIGNED NOT NULL,
  `baglantilari_kimler_gorebilir` TINYINT(3) UNSIGNED NOT NULL DEFAULT '0',
  `epostanizi_kimler_gorebilir` TINYINT(3) UNSIGNED NOT NULL DEFAULT '0',
  `soyadinizi_kimler_gorebilir` TINYINT(3) UNSIGNED NOT NULL DEFAULT '0',
  `profil_gorunurlugu` TINYINT(3) UNSIGNED NOT NULL DEFAULT '0',
  `kullanicilar_sizi_etiketliyebilirmi` TINYINT(3) UNSIGNED NOT NULL DEFAULT '0',
  CONSTRAINT `unique_ayarlar` UNIQUE (`user_id`),
  CONSTRAINT `ayarlar_user_idFK` FOREIGN KEY (`user_id`)
  REFERENCES users(`user_id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
);

CREATE TABLE  `linkedln_Uygulamasi`.`baglantilar` 
( 
  `istek_gonderen_user_id` INT(10) UNSIGNED NOT NULL,
  `istegi_alan_user_id` INT(10) UNSIGNED NOT NULL,
  `arkadaslik_durumu` TINYINT(3) UNSIGNED NOT NULL DEFAULT '0',
  CONSTRAINT `unique_friends` UNIQUE (`istek_gonderen_user_id`,`istegi_alan_user_id`),
  CONSTRAINT `action_user_idFK` FOREIGN KEY (`istek_gonderen_user_id`)
  REFERENCES users(`user_id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  CONSTRAINT `other_user_idFK` FOREIGN KEY (`istegi_alan_user_id`)
  REFERENCES users(`user_id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
);

DELIMITER //
CREATE TRIGGER connections BEFORE INSERT
ON baglantilar
FOR EACH ROW
BEGIN
   IF (new.istek_gonderen_user_id = new.istegi_alan_user_id) 
   THEN
   signal sqlstate '45000' set message_text="iki kullanıcı aynıdır";
   END IF;
   
   if exists(select istegi_alan_user_id,istek_gonderen_user_id,arkadaslik_durumu from baglantilar 
   where new.istek_gonderen_user_id=istegi_alan_user_id and new.istegi_alan_user_id=istek_gonderen_user_id)
   then
   signal sqlstate '45000' set message_text="bu kayıt daha onceden eklenmis";
   END IF;
   
   
END//
DELIMITER ;

DROP TRIGGER connections;


CREATE TABLE  `linkedln_Uygulamasi`.`message` 
( 
  `alici_user_id` INT(10) UNSIGNED NOT NULL,
  `gonderici_user_id` INT(10) UNSIGNED NOT NULL,
  `spam_status` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0',
  `archived_status` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0',
  `unread_status` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0',
  `icerik` VARCHAR(256) NOT NULL,
  `mesaj_turu` TINYINT(3) UNSIGNED NOT NULL DEFAULT '0',
  `arkadas_mesaji` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0',
  CONSTRAINT `alici_user_idFK` FOREIGN KEY (`alici_user_id`)
  REFERENCES users(`user_id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  CONSTRAINT `gonderici_user_idFK` FOREIGN KEY (`gonderici_user_id`)
  REFERENCES users(`user_id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
);

DELIMITER //
CREATE TRIGGER messages BEFORE INSERT
ON message
FOR EACH ROW
BEGIN
  IF (new.mesaj_turu=0)  THEN 
     if exists(select istegi_alan_user_id,istek_gonderen_user_id  from linkedln_Uygulamasi.baglantilar 
               where ((baglantilar.istek_gonderen_user_id = new.alici_user_id or
                      baglantilar.istegi_alan_user_id = new.alici_user_id) and 
                      (baglantilar.istek_gonderen_user_id = new.gonderici_user_id or
                      baglantilar.istegi_alan_user_id = new.gonderici_user_id)  and 
                      baglantilar.arkadaslik_durumu=3)) then
        signal sqlstate '45000' set message_text=" engelli kullanıcı,mesaj gönderemezsiniz";
     end if;
   END IF;
    
   IF (new.mesaj_turu=1)  THEN 
     if not exists(select kurucu_user_id from linkedln_Uygulamasi.company_page where kurucu_user_id = new.alici_user_id) then
        signal sqlstate '45000' set message_text=" mesajı alan kayıtlı sayfa admini yok";
     end if;
   END IF;
   
   IF (new.mesaj_turu=2)  THEN 
     if not exists(select kurucu_user_id from linkedln_Uygulamasi.linkedln_gruplari where kurucu_user_id = new.alici_user_id) then
        signal sqlstate '45000' set message_text=" mesajı alan kayıtlı grup admini yok";
     end if;
   END IF;
   
   IF (new.arkadas_mesaji=1)  THEN 
     if not exists(select istek_gonderen_user_id,istegi_alan_user_id,arkadaslik_durumu from linkedln_Uygulamasi.baglantilar where (istek_gonderen_user_id =new.alici_user_id
     or istek_gonderen_user_id = new.gonderici_user_id) and (istegi_alan_user_id = new.alici_user_id or istegi_alan_user_id = new.gonderici_user_id) and baglantilar.arkadaslik_durumu=1) 
     then
        signal sqlstate '45000' set message_text=" bu kişi arkadaşınız değildir";
     end if;
   END IF;
   
END//
DELIMITER ;

DROP TRIGGER messages;

CREATE TABLE `linkedln_Uygulamasi`.`sektorler`
(
 `sektor_adi` VARCHAR(256) NOT NULL,
  PRIMARY KEY (`sektor_adi`)
);

CREATE TABLE `linkedln_Uygulamasi`.`sirket_turu`
(
 `sirket_turu_adi` VARCHAR(256) NOT NULL,
  PRIMARY KEY (`sirket_turu_adi`)
); 

CREATE TABLE  `linkedln_Uygulamasi`.`company_page` 
(  
  `page_id` INT(10) UNSIGNED NOT NULL,
  `kurucu_user_id` INT(10) UNSIGNED NOT NULL,
  `page_name` VARCHAR(256) NOT NULL,
  `hakkında` VARCHAR(256) NOT NULL,
  `sayfa_turu` TINYINT(3) UNSIGNED NOT NULL DEFAULT '0',
  `sektor` VARCHAR(256) NOT NULL,
  `sirket_turu` VARCHAR(256) NOT NULL,
   PRIMARY KEY (`page_id`),
   CONSTRAINT `unique_pages` UNIQUE (kurucu_user_id),
   CONSTRAINT `kurucu_user_idFK` FOREIGN KEY (`kurucu_user_id`)
   REFERENCES users(`user_id`)
   ON DELETE CASCADE
   ON UPDATE CASCADE,
   CONSTRAINT `company_sektorFK` FOREIGN KEY (`sektor`)
   REFERENCES sektorler(`sektor_adi`)
   ON DELETE CASCADE
   ON UPDATE CASCADE,
   CONSTRAINT `sirket_turuFK` FOREIGN KEY (`sirket_turu`)
   REFERENCES sirket_turu(`sirket_turu_adi`)
   ON DELETE CASCADE
   ON UPDATE CASCADE
);


CREATE TABLE  `linkedln_Uygulamasi`.`company_page_takipciler` 
( 
  `page_id` INT(10) UNSIGNED NOT NULL,
  `user_id` INT(10) UNSIGNED NOT NULL,
   CONSTRAINT `unique_followed_pages` UNIQUE (`page_id`,`user_id`),
   CONSTRAINT `page_idFK` FOREIGN KEY (`page_id`)
   REFERENCES company_page(`page_id`)
   ON DELETE CASCADE
   ON UPDATE CASCADE,
   CONSTRAINT `user_idFK` FOREIGN KEY (`user_id`)
   REFERENCES users(`user_id`)
   ON DELETE CASCADE
   ON UPDATE CASCADE
);

DELIMITER //
CREATE TRIGGER company_page_takipci BEFORE INSERT
ON company_page_takipciler
FOR EACH ROW
BEGIN
     if exists(select kurucu_user_id 
               from linkedln_Uygulamasi.company_page
               where  kurucu_user_id = new.user_id 
               and company_page.page_id=new.page_id) then
        signal sqlstate '45000' set message_text=" sayfanın kurucusunu normal takipçi olarak ekleyemezsiniz";
     end if;
   
END//
DELIMITER ;

DROP TRIGGER company_page_takipci;

CREATE TABLE  `linkedln_Uygulamasi`.`linkedln_gruplari` 
( 
  `group_id` INT(10) UNSIGNED NOT NULL,
  `kurucu_user_id` INT(10) UNSIGNED NOT NULL,
  `group_name` VARCHAR(256) NOT NULL,
  `hakkında` VARCHAR(256) NOT NULL,
   PRIMARY KEY (`group_id`),
   CONSTRAINT `unique_groups` UNIQUE (kurucu_user_id),
   CONSTRAINT `kurucu_user_id_grupFK` FOREIGN KEY (`kurucu_user_id`)
   REFERENCES users(`user_id`)
   ON DELETE CASCADE
   ON UPDATE CASCADE
);


CREATE TABLE  `linkedln_Uygulamasi`.`linkedln_grup_takipcileri` 
( 
  `group_id` INT(10) UNSIGNED NOT NULL,
  `user_id` INT(10) UNSIGNED NOT NULL,
   CONSTRAINT `unique_followed_group` UNIQUE (`group_id`,`user_id`),
   CONSTRAINT `group_idFK` FOREIGN KEY (`group_id`)
   REFERENCES linkedln_gruplari(`group_id`)
   ON DELETE CASCADE
   ON UPDATE CASCADE,
   CONSTRAINT `user_id_groupFK` FOREIGN KEY (`user_id`)
   REFERENCES users(`user_id`)
   ON DELETE CASCADE
   ON UPDATE CASCADE
);


DELIMITER //
CREATE TRIGGER linkedln_grup_takipci BEFORE INSERT
ON linkedln_grup_takipcileri
FOR EACH ROW
BEGIN
     if exists(select kurucu_user_id 
               from linkedln_Uygulamasi.linkedln_gruplari 
               where  kurucu_user_id = new.user_id 
               and linkedln_gruplari.group_id=new.group_id) then
        signal sqlstate '45000' set message_text=" grubun kurucusunu normal üye olarak ekleyemezsiniz";
     end if;
   
END//
DELIMITER ;

DROP TRIGGER linkedln_grup_takipci;

CREATE TABLE  `linkedln_Uygulamasi`.`posts` 
( 
  `post_id` INT(10) UNSIGNED NOT NULL,
  `user_id` INT(10) UNSIGNED NOT NULL,
  `icerik` VARCHAR(256) NOT NULL,
  `date` date  NOT NULL,
  `paylasim_turu` TINYINT(3) UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`post_id`),
  CONSTRAINT `user_id_postFK` FOREIGN KEY (`user_id`)
  REFERENCES users(`user_id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
);

DELIMITER //
CREATE TRIGGER postlar BEFORE INSERT
ON posts
FOR EACH ROW
BEGIN
   IF (new.paylasim_turu=1)  THEN 
     if not exists(select kurucu_user_id from linkedln_Uygulamasi.company_page where kurucu_user_id = new.user_id)
	 then
        signal sqlstate '45000' set message_text=" kayıtlı sayfa admini yok";
     end if;
   END IF;
   
   IF (new.paylasim_turu=2)  THEN 
     if not exists(select kurucu_user_id from linkedln_Uygulamasi.linkedln_gruplari where kurucu_user_id = new.user_id) 
     then
        signal sqlstate '45000' set message_text=" kayıtlı grup admini yok";
     end if;
   END IF;
   
END//
DELIMITER ;

DROP TRIGGER postlar;
 
CREATE TABLE  `linkedln_Uygulamasi`.`post_favs` 
( 
  `post_id` INT(10) UNSIGNED NOT NULL,
  `user_id` INT(10) UNSIGNED NOT NULL,
   CONSTRAINT `unique_followed_pages` UNIQUE (`post_id`,`user_id`),
  CONSTRAINT `post_idFK` FOREIGN KEY (`post_id`)
  REFERENCES posts(`post_id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  CONSTRAINT `user_id_post_favFK` FOREIGN KEY (`user_id`)
  REFERENCES users(`user_id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
);

CREATE TABLE  `linkedln_Uygulamasi`.`posts_comments` 
( 
  `comment_id` INT(10) UNSIGNED NOT NULL,
  `post_id` INT(10) UNSIGNED NOT NULL,
  `user_id` INT(10) UNSIGNED NOT NULL,
  `icerik` VARCHAR(256) NOT NULL,
  `date` date  NOT NULL,
  PRIMARY KEY (`comment_id`),
  CONSTRAINT `post_id_commentsFK` FOREIGN KEY (`post_id`)
  REFERENCES posts(`post_id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  CONSTRAINT `user_id_commentsFK` FOREIGN KEY (`user_id`)
  REFERENCES users(`user_id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
);

CREATE TABLE  `linkedln_Uygulamasi`.`post_comment_favs` 
( 
  `comment_id` INT(10) UNSIGNED NOT NULL,
  `user_id` INT(10) UNSIGNED NOT NULL,
  CONSTRAINT `unique_followed_pages` UNIQUE (`comment_id`,`user_id`),
  CONSTRAINT `comment_idFK` FOREIGN KEY (`comment_id`)
  REFERENCES posts_comments(`comment_id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  CONSTRAINT `user_id_comment_favsFK` FOREIGN KEY (`user_id`)
  REFERENCES users(`user_id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
);

                                   /* SİLME VE GÜNCELLEME */
                                   
                                   

DELETE FROM is_ilanlari WHERE is_ilani_id=5 AND sirket_adi="petkim";

UPDATE ayarlar SET epostanizi_kimler_gorebilir=0 WHERE user_id=15;

DELETE FROM posts_comments WHERE comment_id=7 AND post_id=11;

UPDATE user_profiles SET yasadigi_yer="ankara,turkey" WHERE profile_id=8 AND user_id=8;
	
DELETE FROM yetenekler WHERE profile_id=5 AND yetenek="Kullanıcı Arayüzü Tasarımı";

UPDATE linkedln_gruplari SET group_name="ODTÜ ÖGRENCİ" WHERE group_id=3 AND kurucu_user_id=6;




                                   /*  KAYITLAR  */
                                 
                                 
    /*USERS KAYIT EKLEME */
    
INSERT INTO `users` (user_id,name,lname,password,language,email)
VALUES (15,"john","bonjovi",sha2('john', 256),"English",'john@gmail.com' );

SELECT * FROM users;



    /*DİLLER KAYIT EKLEME */
    
INSERT INTO `diller` (dil)
VALUES
("Russian"),("turkce"),("English"),("German"),("Spanish");

SELECT * FROM diller;



   /*PROFILES KAYIT EKLEME */
   
INSERT INTO `user_profiles` (profile_id,user_id,baslik,yasadigi_yer,sektor,ozet)
VALUES (15,15,"-","izmir,turkey","kimya","-" );

SELECT * FROM user_profiles;



   /* SEKTOR KAYIT EKLEME*/
   
INSERT INTO `sektorler` (sektor_adi)
VALUES
("bilgisayar yazilimi"),("eczacilik"),("kimya"),("muzik"),("makina");

SELECT * FROM sektorler;


   /* SEHİR-ULKE KAYIT EKLEME*/

INSERT INTO `Sehir_Ulke` (sehir_ulke)
VALUES
("izmir,turkey"),("ankara,turkey"),("istanbul,turkey"),("london,england"),("berlin,germany");

SELECT * FROM sehir_ulke;



   /* YETENEK KAYIT EKLEME*/
   
INSERT INTO `yetenekler` (profile_id,yetenek)
VALUES (14,"Mac, Linux ve Unix Sistemleri");

SELECT * FROM yetenekler; 




   /* EĞİTİM KAYIT EKLEME */
   
INSERT INTO `egitimler` (profile_id,okul,bolum,basladıgı_tarih,bitirdigi_tarih,acıklama)
VALUES (14,"Oxford university","Chemical engineering","2005-10-10","2008-05-28","");

SELECT * FROM egitimler;



   /* IS DENEYİMLERİ KAYIT EKLME */
   
INSERT INTO `is_deneyimleri` (profile_id,unvan,sirket_adi,sektor,baslangic_tarihi,konum,aciklama)
VALUES (14,"kimyager","bayer","eczacilik","2010-12-15","london,england","");

SELECT * FROM is_deneyimleri;



    /* YETKİN DİLLER KAYIT EKLEME */
    
INSERT INTO `yetkin_diller` (profile_id,dil,duzey)
VALUES (13,"German",1);

SELECT * FROM yetkin_diller;


   /* İŞ İLANLARI KAYIT EKLEME */
   
INSERT INTO `is_ilanlari` (is_ilani_id,user_id,sirket_adi,is_basligi,konum,sektor,calisan_turu,aciklama)
VALUES (5,13,"petkim","kimya muhendisi aranıyor","izmir,turkey","kimya",4,"");

SELECT * FROM is_ilanlari;



   /* İŞ İLANI BAŞVURANLAR KAYIT EKLEME */
   
   /* iş ilanı yayınlayanlar:(1,1)/(2,8)/(3,4)/(4,7)/(5,13) (kendi yayınladıgı iş ilanına basvuramaz)*/
   
INSERT INTO `is_ilani_basvuranlar` (is_ilani_id,user_id)
VALUES (5,13);

SELECT * FROM is_ilani_basvuranlar;




   /* AYARLAR KAYIT EKLEME */
   
INSERT INTO `ayarlar` (user_id,baglantilari_kimler_gorebilir,epostanizi_kimler_gorebilir,soyadinizi_kimler_gorebilir,
profil_gorunurlugu,kullanicilar_sizi_etiketliyebilirmi)
VALUES (15,1,1,1,2,1);

SELECT * FROM ayarlar;



   /* BAĞLANTILAR KAYIT EKLEME */
   /*aynı iki kullanıcı eklenemez,girilen bir kayıt tekrar girilemez(orn: 2 1 / 1 2)*/
   
INSERT INTO `baglantilar` (istek_gonderen_user_id,istegi_alan_user_id,arkadaslik_durumu)
VALUES (2,1,0);

SELECT * FROM baglantilar;




   /* MESAJLAR KAYIT EKLEME */
   
     /* (1,3),(2,8),(3,13),(4,14) nolu  kullanıcılar sayfaların yoneticisidir */
	 /* (1,1),(2,3),(3,6) nolu  kullanıcılar grupların yoneticisidir */
     /*  9,10 / 13,14 arasındaki kayıtlar girilemez(aralarında engellenmis ilişkisi vardır)*/ 

INSERT INTO `message` (alici_user_id,gonderici_user_id,spam_status,archived_status,unread_status,icerik,mesaj_turu,arkadas_mesaji)
VALUES (14,13,1,0,0,"merhabaa",0,0);

SELECT * FROM message;



   /* ŞİRKET TURU KAYIT EKLEME */
   
INSERT INTO `sirket_turu`(sirket_turu_adi)
VALUES
("halka acik sirket"),("ozel sirket"),("devlet dairesi"),("kendi isimde calisiyorum"),("sahis isletmesi");

SELECT * FROM sirket_turu;



  /* ŞİRKET SAYFASI KAYIT EKLEME */
  
INSERT INTO `company_page` (page_id,kurucu_user_id,page_name,hakkında,sayfa_turu,sektor,sirket_turu)
VALUES (16,3,"Ankara Eczanesi","ankara eczanesi 2012'de acilmistir..",0,"eczacilik","sahis isletmesi");

SELECT * FROM company_page;



  /* ŞİRKET SAYFASI TAKİPÇİLERİ KAYIT EKLEME*/
  
   /* (1,3),(2,8),(3,13),(4,14) nolu  kullanıcılar sayfaların yoneticisidir */
  
INSERT INTO `company_page_takipciler` (page_id,user_id)
VALUES (3,13);

SELECT * FROM company_page_takipciler;



  /* LINKEDIN GRUPLARI KAYIT EKLEME */
  
INSERT INTO `linkedln_gruplari` (group_id,kurucu_user_id,group_name,hakkında)
VALUES (3,6,"odtü ögrencileri","odtü 'den bilgiler");

SELECT * FROM linkedln_gruplari;



  /* LINKEDIN GRUPLARI TAKİPÇİLERİ KAYIT EKLEME */
  
  /* (1,1),(2,3),(3,6) nolu  kullanıcılar grupların yoneticisidir */
  
INSERT INTO `linkedln_grup_takipcileri` (group_id,user_id)
VALUES (2,3);

SELECT * FROM linkedln_grup_takipcileri;


  /* POST KAYIT EKLEME */
  
  /* 3,8,13,14 nolu  kullanıcılar sayfaların yoneticisidir */
   /* 1,3,6 nolu  kullanıcılar grupların yoneticisidir */
  
INSERT INTO `posts` (post_id,user_id,icerik,date,paylasim_turu)
VALUES (15,11,"Eczane vardiyaları hakkında","2018-09-12",1);

SELECT * FROM posts;


  /*POST BEĞENİLERİ  KAYIT EKLEME */
  
INSERT INTO `post_favs` (post_id,user_id)
VALUES (15,14);

SELECT * FROM post_favs;


   /*POST YORUMLARI  KAYIT EKLEME */
  
INSERT INTO `posts_comments` (comment_id,post_id,user_id,icerik,date)
VALUES (10,14,6,"wow","2015-05-01");

SELECT * FROM posts_comments;


  /*POST YORUM BEĞENİLERİ  KAYIT EKLEME */

  
INSERT INTO `post_comment_favs` (comment_id,user_id)
VALUES
(10,1);

SELECT * FROM post_comment_favs;


                                     /* SORGULAR */ 
                                     
									
/* bölümü bilgisayar mühendisliği olup aynı zamanda yaşadığı yer izmir,turkey olan kullanıcıların isimlerini ve mezun olduğu okulu listeleyiniz*/
SELECT users.name,users.lname,user_profiles.yasadigi_yer,egitimler.okul,egitimler.bolum
FROM   users,user_profiles,egitimler
WHERE  egitimler.bolum="bilgisayar muhendisligi" and egitimler.profile_id=user_profiles.profile_id
       and user_profiles.yasadigi_yer="izmir,turkey" and user_profiles.user_id=users.user_id ;



/* ingilizceyi en az 3 düzeyinde bilen, kimya sektorunde çalışan kullanıcıların isimleri ve e-mail adreslerini listeleyiniz*/
SELECT users.name,users.lname,users.email
FROM   user_profiles,yetkin_diller,users
WHERE  yetkin_diller.dil="english" and yetkin_diller.duzey>2
       and yetkin_diller.profile_id=user_profiles.profile_id 
       and user_profiles.sektor="makina" and user_profiles.user_id=users.user_id;



/* 5 numaralı iş ilanı için iş ilanının konumu ile başvuran kişilerin konumu aynı olan ve
başvuran adayların sektoru kimya olanların isim,soyisim,yaşadığı yer ve e-mail adresini listeleme*/
SELECT users.name,users.lname,user_profiles.yasadigi_yer,users.email
FROM   is_ilani_basvuranlar,user_profiles,users,is_ilanlari
WHERE  is_ilani_basvuranlar.is_ilani_id=5 and is_ilanlari.is_ilani_id=5 
	   and is_ilani_basvuranlar.user_id=users.user_id
       and users.user_id=user_profiles.user_id and is_ilanlari.konum=user_profiles.yasadigi_yer 
       and is_ilanlari.sektor=user_profiles.sektor;




/* daha önce bilgisayar yazilimi sektorunde iş deneyimi olmuş insanların eğitim bilgieri listesi (okul-bolum) ve isimleri*/
SELECT users.name,users.lname,egitimler.okul,egitimler.bolum 
FROM   user_profiles,egitimler,is_deneyimleri,users
WHERE  is_deneyimleri.sektor="bilgisayar yazilimi" AND is_deneyimleri.profile_id = user_profiles.profile_id
       AND user_profiles.profile_id = egitimler.profile_id AND user_profiles.user_id = users.user_id;



/* her sayfanın takipci sayısını görüntüleyiniz*/
SELECT company_page.page_id,page_name, COUNT(company_page_takipciler.page_id) AS takipci_sayisi
FROM   company_page,company_page_takipciler
WHERE  company_page.page_id=company_page_takipciler.page_id
GROUP BY company_page.page_id;



/* rusça bilen kullanıcıların takip ettiği sayfa bilgilerini ve kullanıcı ismini gösteren query*/
SELECT users.name,users.lname,company_page.page_id,company_page.page_name,company_page.hakkında
FROM   company_page,users
WHERE  page_id IN
			(SELECT company_page_takipciler.page_id
             FROM   company_page_takipciler
             WHERE  users.user_id = company_page_takipciler.user_id
             AND    users.language = "Russian");



/* begeni sayısı 0 dan çok olan her grup postunu ve postu paylaşan grup bilgisini görüntüleyiniz */
SELECT posts.post_id,posts.icerik AS paylasım,COUNT(post_favs.post_id) AS begeni_sayisi,
linkedln_gruplari.group_name AS paylasımı_yapan_grup_adi
FROM  posts,post_favs,linkedln_gruplari
WHERE posts.post_id=post_favs.post_id AND posts.paylasim_turu=2 AND posts.user_id=linkedln_gruplari.kurucu_user_id
GROUP BY posts.post_id
HAVING  COUNT(post_favs.post_id)>0;



/* en az 3 dil bilenlerin kullanıcı bilgileri*/
select users.name,users.lname,users.email,COUNT(yetkin_diller.profile_id) AS toplam_bilinen_dil_sayisi
from   users,yetkin_diller,user_profiles
where  yetkin_diller.profile_id = user_profiles.profile_id AND user_profiles.user_id = users.user_id
group by users.user_id
HAVING COUNT(yetkin_diller.profile_id)>2;



/* egitim bilgilerinde ege üniversitesi yazanların isimleri ve paylaştıkları postların içeriklerinin listesi*/
SELECT users.name,users.lname,egitimler.okul,posts.icerik
FROM   users,posts,egitimler,user_profiles
WHERE  egitimler.okul = "Ege universitesi" AND egitimler.profile_id = user_profiles.profile_id AND 
user_profiles.user_id = users.user_id AND users.user_id = posts.user_id;
                                     
               
               
/*her  postun begeni sayısını görüntüleyiniz*/ 
SELECT posts.post_id,posts.icerik AS postun_içeriği, COUNT(post_favs.post_id) AS begeni_sayisi,
users.name AS paylasım_yapan_isim,users.lname AS paylasım_yapan_soyisim
FROM   posts,post_favs,users
WHERE  post_favs.post_id=posts.post_id  and users.user_id=posts.user_id
GROUP BY posts.post_id;
                                     
                                     
                                     
                                     
