-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1
-- Üretim Zamanı: 01 Oca 2021, 16:14:23
-- Sunucu sürümü: 10.1.36-MariaDB
-- PHP Sürümü: 7.2.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `copchase`
--

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `hesaplar`
--

CREATE TABLE `hesaplar` (
  `ID` int(11) NOT NULL,
  `isim` varchar(24) NOT NULL,
  `sifre` char(64) NOT NULL,
  `sifresakla` char(16) NOT NULL,
  `skor` int(11) NOT NULL DEFAULT '0',
  `pkiyafet` int(11) NOT NULL,
  `skiyafet` int(11) NOT NULL,
  `ipadresi` varchar(16) NOT NULL,
  `yonetici` tinyint(4) NOT NULL DEFAULT '0',
  `helper` tinyint(1) NOT NULL DEFAULT '0',
  `polisarac` smallint(6) NOT NULL,
  `susturdakika` tinyint(4) NOT NULL DEFAULT '0',
  `olum` int(11) NOT NULL DEFAULT '0',
  `oldurme` int(11) NOT NULL DEFAULT '0',
  `hapisdakika` int(11) NOT NULL DEFAULT '0',
  `suspectkazanma` int(11) NOT NULL DEFAULT '0',
  `donator` tinyint(1) NOT NULL DEFAULT '0',
  `isimhak` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin5;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `yasaklar`
--

CREATE TABLE `yasaklar` (
  `yasakID` int(11) NOT NULL,
  `yasaklanan` varchar(24) NOT NULL,
  `yasaklayan` varchar(24) NOT NULL,
  `sebep` varchar(50) NOT NULL,
  `yasakip` varchar(16) NOT NULL,
  `bitis` int(15) NOT NULL,
  `islemtarih` int(15) NOT NULL,
  `bitistarih` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin5;

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `hesaplar`
--
ALTER TABLE `hesaplar`
  ADD PRIMARY KEY (`ID`);

--
-- Tablo için indeksler `yasaklar`
--
ALTER TABLE `yasaklar`
  ADD PRIMARY KEY (`yasakID`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `hesaplar`
--
ALTER TABLE `hesaplar`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
