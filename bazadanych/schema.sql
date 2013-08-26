-- phpMyAdmin SQL Dump
-- version 4.0.5
-- http://www.daniex0r.pl
--
-- Host: localhost
-- Czas wygenerowania: 26 Sie 2013, 19:11
-- Wersja serwera: 5.5.31-1~dotdeb.0
-- Wersja PHP: 5.3.27-1~dotdeb.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Baza danych: `schema`
--

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `accounts`
--

CREATE TABLE IF NOT EXISTS `accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` text CHARACTER SET latin1,
  `password` text CHARACTER SET latin1,
  `registerdate` datetime DEFAULT NULL,
  `lastlogin` datetime DEFAULT NULL,
  `ip` text CHARACTER SET latin1,
  `admin` tinyint(3) DEFAULT '0',
  `hiddenadmin` tinyint(3) unsigned DEFAULT '0',
  `adminduty` tinyint(3) unsigned DEFAULT '0',
  `adminjail` tinyint(3) unsigned DEFAULT '0',
  `adminjail_time` int(11) DEFAULT NULL,
  `adminjail_by` text CHARACTER SET latin1,
  `adminjail_reason` text CHARACTER SET latin1,
  `banned` tinyint(3) unsigned DEFAULT '0',
  `banned_by` text CHARACTER SET latin1,
  `banned_reason` text CHARACTER SET latin1,
  `muted` tinyint(3) unsigned DEFAULT '0',
  `globalooc` tinyint(3) unsigned DEFAULT '1',
  `country` text CHARACTER SET latin1,
  `friendsmessage` text CHARACTER SET latin1,
  `adminjail_permanent` tinyint(3) unsigned DEFAULT '0',
  `adminreports` int(11) DEFAULT '0',
  `warns` tinyint(3) unsigned DEFAULT '0',
  `chatbubbles` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `adminnote` text CHARACTER SET latin1,
  `appstate` tinyint(1) DEFAULT '3',
  `appdatetime` datetime DEFAULT NULL,
  `appreason` longtext CHARACTER SET latin1,
  `email` text CHARACTER SET latin1,
  `help` int(1) NOT NULL DEFAULT '1',
  `adblocked` int(1) NOT NULL DEFAULT '0',
  `newsblocked` int(1) NOT NULL DEFAULT '0',
  `mtaserial` text CHARACTER SET latin1,
  `d_addiction` text CHARACTER SET latin1,
  `loginhash` varchar(64) CHARACTER SET latin1 DEFAULT NULL,
  `credits` int(11) DEFAULT '0',
  `transfers` int(11) DEFAULT '0',
  `monitored` varchar(255) CHARACTER SET latin1 NOT NULL DEFAULT 'Nowy Gracz',
  `premiumHours` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `adminhistory`
--

CREATE TABLE IF NOT EXISTS `adminhistory` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user` int(10) unsigned NOT NULL,
  `user_char` text NOT NULL,
  `admin` int(10) unsigned NOT NULL,
  `admin_char` text NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `action` tinyint(3) unsigned NOT NULL,
  `duration` int(10) unsigned NOT NULL,
  `reason` text NOT NULL,
  `hiddenadmin` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `applications`
--

CREATE TABLE IF NOT EXISTS `applications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `accountID` int(11) NOT NULL,
  `dateposted` datetime NOT NULL,
  `content` text NOT NULL,
  `datereviewed` datetime DEFAULT NULL,
  `adminID` int(11) DEFAULT NULL,
  `adminNote` text,
  `adminAction` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `atms`
--

CREATE TABLE IF NOT EXISTS `atms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` decimal(10,6) DEFAULT '0.000000',
  `y` decimal(10,6) DEFAULT '0.000000',
  `z` decimal(10,6) DEFAULT '0.000000',
  `rotation` decimal(10,6) DEFAULT '0.000000',
  `dimension` int(5) DEFAULT '0',
  `interior` int(5) DEFAULT '0',
  `deposit` tinyint(3) unsigned DEFAULT '0',
  `limit` int(10) unsigned DEFAULT '5000',
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `characters`
--

CREATE TABLE IF NOT EXISTS `characters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `charactername` text,
  `account` int(11) DEFAULT '0',
  `x` float DEFAULT '1742.19',
  `y` float DEFAULT '-1861.36',
  `z` float DEFAULT '13.5776',
  `rotation` float DEFAULT '0.986053',
  `interior_id` int(5) DEFAULT '0',
  `dimension_id` int(5) DEFAULT '0',
  `health` float DEFAULT '100',
  `armor` float DEFAULT '0',
  `skin` int(3) DEFAULT '264',
  `money` bigint(20) DEFAULT '250',
  `gender` int(1) DEFAULT '0',
  `cuffed` int(11) DEFAULT '0',
  `duty` int(3) DEFAULT '0',
  `cellnumber` int(30) DEFAULT '0',
  `fightstyle` int(2) DEFAULT '4',
  `pdjail` int(1) DEFAULT '0',
  `pdjail_time` int(11) DEFAULT '0',
  `job` int(3) DEFAULT '0',
  `cked` int(1) DEFAULT '0',
  `lastarea` text,
  `age` int(3) DEFAULT '18',
  `faction_id` int(11) DEFAULT '-1',
  `faction_rank` int(2) DEFAULT '1',
  `faction_perks` text,
  `skincolor` int(1) DEFAULT '0',
  `weight` int(3) DEFAULT '180',
  `height` int(3) DEFAULT '180',
  `description` text,
  `deaths` int(11) DEFAULT '0',
  `faction_leader` int(1) DEFAULT '0',
  `fingerprint` text,
  `casualskin` int(3) DEFAULT '0',
  `bankmoney` bigint(20) DEFAULT '500',
  `car_license` int(1) DEFAULT '0',
  `gun_license` int(1) DEFAULT '0',
  `tag` int(3) DEFAULT '1',
  `hoursplayed` int(11) DEFAULT '0',
  `pdjail_station` int(1) DEFAULT '0',
  `timeinserver` int(2) DEFAULT '0',
  `restrainedobj` int(11) DEFAULT '0',
  `restrainedby` int(11) DEFAULT '0',
  `dutyskin` int(3) DEFAULT '-1',
  `fish` int(10) unsigned NOT NULL DEFAULT '0',
  `truckingruns` int(10) unsigned NOT NULL DEFAULT '0',
  `truckingwage` int(10) unsigned NOT NULL DEFAULT '0',
  `blindfold` tinyint(4) NOT NULL DEFAULT '0',
  `lang1` tinyint(2) DEFAULT '1',
  `lang1skill` tinyint(3) DEFAULT '100',
  `lang2` tinyint(2) DEFAULT '0',
  `lang2skill` tinyint(3) DEFAULT '0',
  `lang3` tinyint(2) DEFAULT '0',
  `lang3skill` tinyint(3) DEFAULT '0',
  `currlang` tinyint(1) DEFAULT '1',
  `lastlogin` datetime DEFAULT NULL,
  `creationdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `election_candidate` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `election_canvote` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `election_votedfor` int(10) unsigned NOT NULL DEFAULT '0',
  `jobcontract` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `marriedto` int(10) unsigned NOT NULL DEFAULT '0',
  `photos` int(10) unsigned NOT NULL DEFAULT '0',
  `maxvehicles` int(4) unsigned NOT NULL DEFAULT '5',
  `ck_info` text,
  `alcohollevel` float NOT NULL DEFAULT '0',
  `active` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `kasabezdomny` int(11) NOT NULL DEFAULT '-1',
  `pracedorywcze` int(11) NOT NULL DEFAULT '0',
  `wyplataMinuty` int(11) NOT NULL DEFAULT '0',
  `wyplataMinutyKasa` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `computers`
--

CREATE TABLE IF NOT EXISTS `computers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `posX` float(10,5) NOT NULL,
  `posY` float(10,5) NOT NULL,
  `posZ` float(10,5) NOT NULL,
  `rotX` float(10,5) NOT NULL,
  `rotY` float(10,5) NOT NULL,
  `rotZ` float(10,5) NOT NULL,
  `interior` int(8) NOT NULL,
  `dimension` int(8) NOT NULL,
  `model` int(8) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `dancers`
--

CREATE TABLE IF NOT EXISTS `dancers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `rotation` float NOT NULL,
  `skin` smallint(5) unsigned NOT NULL,
  `type` tinyint(3) unsigned NOT NULL,
  `interior` int(10) unsigned NOT NULL,
  `dimension` int(10) unsigned NOT NULL,
  `offset` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `donators`
--

CREATE TABLE IF NOT EXISTS `donators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `accountID` int(11) NOT NULL,
  `charID` int(11) NOT NULL DEFAULT '-1',
  `perkID` int(4) NOT NULL,
  `perkValue` varchar(10) NOT NULL DEFAULT '1',
  `expirationDate` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `don_transactions`
--

CREATE TABLE IF NOT EXISTS `don_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transaction_id` varchar(64) NOT NULL,
  `donator_email` varchar(255) NOT NULL,
  `amount` double NOT NULL,
  `original_request` text,
  `dt` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  `handled` smallint(1) DEFAULT '0',
  `username` varchar(50) NOT NULL,
  `realamount` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `don_transaction_failed`
--

CREATE TABLE IF NOT EXISTS `don_transaction_failed` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `output` text NOT NULL,
  `ip` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `elevators`
--

CREATE TABLE IF NOT EXISTS `elevators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` decimal(10,6) DEFAULT '0.000000',
  `y` decimal(10,6) DEFAULT '0.000000',
  `z` decimal(10,6) DEFAULT '0.000000',
  `tpx` decimal(10,6) DEFAULT '0.000000',
  `tpy` decimal(10,6) DEFAULT '0.000000',
  `tpz` decimal(10,6) DEFAULT '0.000000',
  `dimensionwithin` int(5) DEFAULT '0',
  `interiorwithin` int(5) DEFAULT '0',
  `dimension` int(5) DEFAULT '0',
  `interior` int(5) DEFAULT '0',
  `car` tinyint(3) unsigned DEFAULT '0',
  `disabled` tinyint(3) unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `emailaccounts`
--

CREATE TABLE IF NOT EXISTS `emailaccounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` text,
  `password` text,
  `creator` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `emails`
--

CREATE TABLE IF NOT EXISTS `emails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL,
  `sender` text,
  `receiver` text,
  `subject` text,
  `message` text,
  `inbox` int(1) NOT NULL DEFAULT '0',
  `outbox` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `factions`
--

CREATE TABLE IF NOT EXISTS `factions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text,
  `bankbalance` bigint(20) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `rank_1` text,
  `rank_2` text,
  `rank_3` text,
  `rank_4` text,
  `rank_5` text,
  `rank_6` text,
  `rank_7` text,
  `rank_8` text,
  `rank_9` text,
  `rank_10` text,
  `rank_11` text,
  `rank_12` text,
  `rank_13` text,
  `rank_14` text,
  `rank_15` text,
  `rank_16` text,
  `rank_17` text,
  `rank_18` text,
  `rank_19` text,
  `rank_20` text,
  `wage_1` int(11) DEFAULT '100',
  `wage_2` int(11) DEFAULT '100',
  `wage_3` int(11) DEFAULT '100',
  `wage_4` int(11) DEFAULT '100',
  `wage_5` int(11) DEFAULT '100',
  `wage_6` int(11) DEFAULT '100',
  `wage_7` int(11) DEFAULT '100',
  `wage_8` int(11) DEFAULT '100',
  `wage_9` int(11) DEFAULT '100',
  `wage_10` int(11) DEFAULT '100',
  `wage_11` int(11) DEFAULT '100',
  `wage_12` int(11) DEFAULT '100',
  `wage_13` int(11) DEFAULT '100',
  `wage_14` int(11) DEFAULT '100',
  `wage_15` int(11) DEFAULT '100',
  `wage_16` int(11) DEFAULT '100',
  `wage_17` int(11) DEFAULT '100',
  `wage_18` int(11) DEFAULT '100',
  `wage_19` int(11) DEFAULT '100',
  `wage_20` int(11) DEFAULT '100',
  `motd` text,
  `note` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `forgotdetails`
--

CREATE TABLE IF NOT EXISTS `forgotdetails` (
  `uniquekey` varchar(32) NOT NULL,
  `account` int(11) DEFAULT '0',
  `keytimestamp` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `friends`
--

CREATE TABLE IF NOT EXISTS `friends` (
  `id` int(10) unsigned NOT NULL,
  `friend` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`,`friend`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `fuelpeds`
--

CREATE TABLE IF NOT EXISTS `fuelpeds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `posX` float NOT NULL,
  `posY` float NOT NULL,
  `posZ` float NOT NULL,
  `rotZ` float NOT NULL,
  `skin` int(3) NOT NULL,
  `priceratio` int(3) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `fuelstations`
--

CREATE TABLE IF NOT EXISTS `fuelstations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` decimal(10,6) DEFAULT '0.000000',
  `y` decimal(10,6) DEFAULT '0.000000',
  `z` decimal(10,6) DEFAULT '0.000000',
  `interior` int(5) DEFAULT '0',
  `dimension` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `gates`
--

CREATE TABLE IF NOT EXISTS `gates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `objectID` int(11) NOT NULL,
  `startX` float NOT NULL,
  `startY` float NOT NULL,
  `startZ` float NOT NULL,
  `startRX` float NOT NULL,
  `startRY` float NOT NULL,
  `startRZ` float NOT NULL,
  `endX` float NOT NULL,
  `endY` float NOT NULL,
  `endZ` float NOT NULL,
  `endRX` float NOT NULL,
  `endRY` float NOT NULL,
  `endRZ` float NOT NULL,
  `gateType` tinyint(3) unsigned NOT NULL,
  `autocloseTime` int(4) NOT NULL,
  `movementTime` int(4) NOT NULL,
  `objectDimension` int(11) NOT NULL,
  `objectInterior` int(11) NOT NULL,
  `gateSecurityParameters` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `interiors`
--

CREATE TABLE IF NOT EXISTS `interiors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` float DEFAULT '0',
  `y` float DEFAULT '0',
  `z` float DEFAULT '0',
  `type` int(1) DEFAULT '0',
  `owner` int(11) DEFAULT '-1',
  `locked` int(1) DEFAULT '0',
  `cost` int(11) DEFAULT '0',
  `name` text,
  `interior` int(5) DEFAULT '0',
  `interiorx` float DEFAULT '0',
  `interiory` float DEFAULT '0',
  `interiorz` float DEFAULT '0',
  `dimensionwithin` int(5) DEFAULT '0',
  `interiorwithin` int(5) DEFAULT '0',
  `angle` float DEFAULT '0',
  `angleexit` float DEFAULT '0',
  `supplies` int(11) DEFAULT '100',
  `safepositionX` float DEFAULT NULL,
  `safepositionY` float DEFAULT NULL,
  `safepositionZ` float DEFAULT NULL,
  `safepositionRZ` float DEFAULT NULL,
  `fee` int(10) unsigned DEFAULT '0',
  `disabled` tinyint(3) unsigned DEFAULT '0',
  `lastused` datetime DEFAULT NULL,
  `webmap_x` float NOT NULL,
  `webmap_y` float NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `items`
--

CREATE TABLE IF NOT EXISTS `items` (
  `index` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint(3) unsigned NOT NULL,
  `owner` int(10) unsigned NOT NULL,
  `itemID` int(10) NOT NULL,
  `itemValue` text NOT NULL,
  PRIMARY KEY (`index`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `logtable`
--

CREATE TABLE IF NOT EXISTS `logtable` (
  `time` datetime NOT NULL,
  `action` int(2) NOT NULL,
  `source` varchar(12) NOT NULL,
  `affected` text NOT NULL,
  `content` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `lottery`
--

CREATE TABLE IF NOT EXISTS `lottery` (
  `characterid` int(255) NOT NULL,
  `ticketnumber` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `mdcUsers`
--

CREATE TABLE IF NOT EXISTS `mdcUsers` (
  `user_name` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL DEFAULT '123',
  `high_command` int(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `objects`
--

CREATE TABLE IF NOT EXISTS `objects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` int(6) NOT NULL DEFAULT '0',
  `posX` float(12,7) NOT NULL DEFAULT '0.0000000',
  `posY` float(12,7) NOT NULL DEFAULT '0.0000000',
  `posZ` float(12,7) NOT NULL DEFAULT '0.0000000',
  `rotX` float(12,7) NOT NULL DEFAULT '0.0000000',
  `rotY` float(12,7) NOT NULL DEFAULT '0.0000000',
  `rotZ` float(12,7) NOT NULL DEFAULT '0.0000000',
  `interior` int(5) NOT NULL,
  `dimension` int(5) NOT NULL,
  `comment` varchar(50) DEFAULT NULL,
  `solid` int(1) NOT NULL DEFAULT '1',
  `doublesided` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `onlinesystem`
--

CREATE TABLE IF NOT EXISTS `onlinesystem` (
  `online` varchar(300) COLLATE utf8_polish_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `paynspray`
--

CREATE TABLE IF NOT EXISTS `paynspray` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` decimal(10,6) DEFAULT '0.000000',
  `y` decimal(10,6) DEFAULT '0.000000',
  `z` decimal(10,6) DEFAULT '0.000000',
  `dimension` int(5) DEFAULT '0',
  `interior` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `phone_contacts`
--

CREATE TABLE IF NOT EXISTS `phone_contacts` (
  `phone` int(11) NOT NULL,
  `entryName` varchar(30) NOT NULL,
  `entryNumber` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `phone_settings`
--

CREATE TABLE IF NOT EXISTS `phone_settings` (
  `phonenumber` int(1) NOT NULL,
  `turnedon` smallint(1) unsigned NOT NULL DEFAULT '1',
  `secretnumber` smallint(1) unsigned NOT NULL DEFAULT '0',
  `ringtone` smallint(1) NOT NULL DEFAULT '1',
  `phonebook` varchar(40) DEFAULT NULL,
  `boughtby` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`phonenumber`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `publicphones`
--

CREATE TABLE IF NOT EXISTS `publicphones` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `dimension` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `settings`
--

CREATE TABLE IF NOT EXISTS `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text,
  `value` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `shops`
--

CREATE TABLE IF NOT EXISTS `shops` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` float DEFAULT '0',
  `y` float DEFAULT '0',
  `z` float DEFAULT '0',
  `dimension` int(5) DEFAULT '0',
  `interior` int(5) DEFAULT '0',
  `shoptype` tinyint(4) DEFAULT '0',
  `rotation` float NOT NULL DEFAULT '0',
  `skin` int(11) DEFAULT '-1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `speedcams`
--

CREATE TABLE IF NOT EXISTS `speedcams` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` float(11,7) NOT NULL DEFAULT '0.0000000',
  `y` float(11,7) NOT NULL DEFAULT '0.0000000',
  `z` float(11,7) NOT NULL DEFAULT '0.0000000',
  `interior` int(3) NOT NULL DEFAULT '0' COMMENT 'Stores the location of the pernament speedcams',
  `dimension` int(5) NOT NULL DEFAULT '0',
  `maxspeed` int(4) NOT NULL DEFAULT '120',
  `radius` int(4) NOT NULL DEFAULT '2',
  `enabled` smallint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `speedingviolations`
--

CREATE TABLE IF NOT EXISTS `speedingviolations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `carID` int(11) NOT NULL,
  `time` datetime NOT NULL,
  `speed` int(5) NOT NULL,
  `area` varchar(50) NOT NULL,
  `personVisible` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `suspectCrime`
--

CREATE TABLE IF NOT EXISTS `suspectCrime` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `suspect_name` text,
  `time` text,
  `date` text,
  `officers` text,
  `ticket` int(11) DEFAULT NULL,
  `arrest` int(11) DEFAULT NULL,
  `fine` int(11) DEFAULT NULL,
  `ticket_price` text,
  `arrest_price` text,
  `fine_price` text,
  `illegal_items` text,
  `details` text,
  `done_by` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `suspectDetails`
--

CREATE TABLE IF NOT EXISTS `suspectDetails` (
  `suspect_name` text,
  `birth` text,
  `gender` text,
  `ethnicy` text,
  `cell` int(5) DEFAULT '0',
  `occupation` text,
  `address` text,
  `other` text,
  `is_wanted` int(1) DEFAULT '0',
  `wanted_reason` text,
  `wanted_punishment` text,
  `wanted_by` text,
  `photo` text,
  `done_by` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `tags`
--

CREATE TABLE IF NOT EXISTS `tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` decimal(10,6) DEFAULT NULL,
  `y` decimal(10,6) DEFAULT NULL,
  `z` decimal(10,6) DEFAULT NULL,
  `interior` int(5) DEFAULT NULL,
  `dimension` int(5) DEFAULT NULL,
  `rx` decimal(10,6) DEFAULT NULL,
  `ry` decimal(10,6) DEFAULT NULL,
  `rz` decimal(10,6) DEFAULT NULL,
  `modelid` int(5) DEFAULT NULL,
  `creationdate` datetime DEFAULT NULL,
  `creator` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `tc_comments`
--

CREATE TABLE IF NOT EXISTS `tc_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `poster` int(11) NOT NULL,
  `ip` varchar(50) NOT NULL,
  `message` text NOT NULL,
  `posted` int(25) NOT NULL,
  `type` int(1) NOT NULL,
  `ticket` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `tc_tickets`
--

CREATE TABLE IF NOT EXISTS `tc_tickets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `creator` int(11) NOT NULL,
  `posted` int(25) NOT NULL,
  `subject` varchar(100) NOT NULL,
  `message` text NOT NULL,
  `status` int(1) NOT NULL,
  `lastpost` int(25) NOT NULL,
  `assigned` int(11) NOT NULL,
  `IP` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `tempinteriors`
--

CREATE TABLE IF NOT EXISTS `tempinteriors` (
  `id` int(11) NOT NULL,
  `posX` float NOT NULL,
  `posY` float DEFAULT NULL,
  `posZ` float DEFAULT NULL,
  `interior` int(5) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `tempobjects`
--

CREATE TABLE IF NOT EXISTS `tempobjects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` int(6) NOT NULL DEFAULT '0',
  `posX` float(12,7) NOT NULL DEFAULT '0.0000000',
  `posY` float(12,7) NOT NULL DEFAULT '0.0000000',
  `posZ` float(12,7) NOT NULL DEFAULT '0.0000000',
  `rotX` float(12,7) NOT NULL DEFAULT '0.0000000',
  `rotY` float(12,7) NOT NULL DEFAULT '0.0000000',
  `rotZ` float(12,7) NOT NULL DEFAULT '0.0000000',
  `interior` int(5) NOT NULL,
  `dimension` int(5) NOT NULL,
  `comment` varchar(50) DEFAULT NULL,
  `solid` int(1) NOT NULL DEFAULT '1',
  `doublesided` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `vehicles`
--

CREATE TABLE IF NOT EXISTS `vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` int(3) DEFAULT '0',
  `x` decimal(10,6) DEFAULT '0.000000',
  `y` decimal(10,6) DEFAULT '0.000000',
  `z` decimal(10,6) DEFAULT '0.000000',
  `rotx` decimal(10,6) DEFAULT '0.000000',
  `roty` decimal(10,6) DEFAULT '0.000000',
  `rotz` decimal(10,6) DEFAULT '0.000000',
  `currx` decimal(10,6) DEFAULT '0.000000',
  `curry` decimal(10,6) DEFAULT '0.000000',
  `currz` decimal(10,6) DEFAULT '0.000000',
  `currrx` decimal(10,6) DEFAULT '0.000000',
  `currry` decimal(10,6) DEFAULT '0.000000',
  `currrz` decimal(10,6) NOT NULL DEFAULT '0.000000',
  `fuel` int(3) DEFAULT '100',
  `engine` int(1) DEFAULT '0',
  `locked` int(1) DEFAULT '0',
  `lights` int(1) DEFAULT '0',
  `sirens` int(1) DEFAULT '0',
  `paintjob` int(11) DEFAULT '0',
  `hp` float DEFAULT '1000',
  `color1` varchar(50) DEFAULT '0',
  `color2` varchar(50) DEFAULT '0',
  `color3` varchar(50) DEFAULT NULL,
  `color4` varchar(50) DEFAULT NULL,
  `plate` text,
  `faction` int(11) DEFAULT '-1',
  `owner` int(11) DEFAULT '-1',
  `job` int(11) DEFAULT '-1',
  `tintedwindows` int(1) DEFAULT '0',
  `dimension` int(5) DEFAULT '0',
  `interior` int(5) DEFAULT '0',
  `currdimension` int(5) DEFAULT '0',
  `currinterior` int(5) DEFAULT '0',
  `enginebroke` int(1) DEFAULT '0',
  `items` text,
  `itemvalues` text,
  `Impounded` int(3) DEFAULT '0',
  `handbrake` int(1) DEFAULT '0',
  `safepositionX` float DEFAULT NULL,
  `safepositionY` float DEFAULT NULL,
  `safepositionZ` float DEFAULT NULL,
  `safepositionRZ` float DEFAULT NULL,
  `upgrades` varchar(150) DEFAULT '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]',
  `wheelStates` varchar(30) DEFAULT '[ [ 0, 0, 0, 0 ] ]',
  `panelStates` varchar(40) DEFAULT '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]',
  `doorStates` varchar(30) DEFAULT '[ [ 0, 0, 0, 0, 0, 0 ] ]',
  `odometer` int(15) DEFAULT '0',
  `headlights` varchar(30) DEFAULT '[ [ 255, 255, 255 ] ]',
  `variant1` tinyint(3) unsigned NOT NULL DEFAULT '255',
  `variant2` tinyint(3) unsigned NOT NULL DEFAULT '255',
  `neony` int(11) NOT NULL DEFAULT '0',
  `maxspeed` int(11) NOT NULL DEFAULT '0',
  `acceleration` int(11) NOT NULL DEFAULT '0',
  `steeringlock` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `neony` (`neony`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `wiretransfers`
--

CREATE TABLE IF NOT EXISTS `wiretransfers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `from` int(11) NOT NULL,
  `to` int(11) NOT NULL,
  `amount` int(11) NOT NULL,
  `reason` text NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `type` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `worlditems`
--

CREATE TABLE IF NOT EXISTS `worlditems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `itemid` int(11) DEFAULT '0',
  `itemvalue` text,
  `x` float DEFAULT '0',
  `y` float DEFAULT '0',
  `z` float DEFAULT '0',
  `dimension` int(5) DEFAULT '0',
  `interior` int(5) DEFAULT '0',
  `creationdate` datetime DEFAULT NULL,
  `rz` float DEFAULT '0',
  `creator` int(10) unsigned DEFAULT '0',
  `protected` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
