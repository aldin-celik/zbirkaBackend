-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Apr 20, 2020 at 05:22 PM
-- Server version: 8.0.13-4
-- PHP Version: 7.2.24-0ubuntu0.18.04.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cHY9cZAHWV`
--

-- --------------------------------------------------------

--
-- Table structure for table `grupa`
--

CREATE TABLE `grupa` (
  `id` int(32) NOT NULL,
  `naziv` varchar(64) NOT NULL,
  `id_korisnik` int(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `grupa`
--

INSERT INTO `grupa` (`id`, `naziv`, `id_korisnik`) VALUES
(1, 'grupica', 1),
(3, 'grupica3', 1),
(4, 'grupica4', 2),
(8, 'grupica8', 2),
(10, 'grupica9', 2),
(16, 'urađeni', 3);

-- --------------------------------------------------------

--
-- Table structure for table `kategorija`
--

CREATE TABLE `kategorija` (
  `id` int(32) NOT NULL,
  `naziv` varchar(64) NOT NULL,
  `nadkategorija` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `kategorija`
--

INSERT INTO `kategorija` (`id`, `naziv`, `nadkategorija`) VALUES
(1, 'jednacine', NULL),
(2, 'polinomi', NULL),
(3, 'dobre jednacine', 1),
(4, 'jako dobre jednacine', 1);

-- --------------------------------------------------------

--
-- Table structure for table `korisnik`
--

CREATE TABLE `korisnik` (
  `id` int(32) NOT NULL,
  `username` varchar(32) NOT NULL,
  `password` varchar(256) NOT NULL,
  `email` varchar(32) NOT NULL,
  `privilegija` int(10) NOT NULL,
  `banovan` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `korisnik`
--

INSERT INTO `korisnik` (`id`, `username`, `password`, `email`, `privilegija`, `banovan`) VALUES
(1, 'u', '$2b$10$6qbk3wxkziHryjfZc6vjn.QJQvXN4.VDKkE3OKwwO4tWDEQ6kzsfe', 'aaa@aa.aa', 1, 0),
(2, 'zz', '$2b$10$DhjtBAXiids7z7kQjNgrRelX1yzxJpX4Qhldv4.VcnmJQv1sL30.O', 'bb@bb.bb', 3, 0),
(3, 'admin', '$2b$10$yGmmthAGY9Nc8Zzyd/CKy.xYE9MDiLk2lUdqxrw3GDsByS27TJuXW', 'aa@aa.aa', 3, 0),
(4, 'moderator', '$2b$10$jRsIkGgh8OWVoSCikF4XaeS0ifWNvB65KrEF.HjAYVUC8ziFBWNxm', 'aa@aa.bb', 2, 0),
(5, 'korisnik', '$2b$10$LIXGNJAY9lj5VH/XA485ceXe/c8xT96FTXeP8DfbmyeGrXin9qA2a', 'bb@cc.cc', 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `sesija`
--

CREATE TABLE `sesija` (
  `id` int(32) NOT NULL,
  `id_korisnik` int(11) NOT NULL,
  `token` varchar(256) NOT NULL,
  `datum_isteka` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `sesija`
--

INSERT INTO `sesija` (`id`, `id_korisnik`, `token`, `datum_isteka`) VALUES
(1, 1, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNTc3Mzg2MTIwfQ.HXcyiMSgQmeRkjJg1xqSadmWCCoJLHAcBiSDP1bQLos', '2019-12-26'),
(2, 2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiaWF0IjoxNTc3Mzg2MjcwfQ.BvKlyKAcOngJ04i1CiVd47WGOv-80qD2UGiwNuDyhq4', '2019-12-26'),
(3, 2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiaWF0IjoxNTc4NzgyNDg2fQ.tL5H7KkiEy0knWXQNtwFO7nIfGVBSnif-ni-bxmle-c', '2020-01-11'),
(4, 2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiaWF0IjoxNTc4NzgyNzA2fQ.S2_AZuwUWgoZ6KiPVxkG2xuMJOmnhTXHvF3oguSer4Y', '2020-01-11'),
(5, 1, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNTgxNDY4NjgwfQ.4fP2sW7utmKlkon63uq9hK2TVcOXxmKQR-ge9EmpX00', '2020-02-12'),
(6, 2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiaWF0IjoxNTgxNTI0Mjg0fQ.KMT3OSWjnePgIts_kv-LNPaaQrrTx0N0GAJfhqcP3Pg', '2020-02-12'),
(7, 2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiaWF0IjoxNTgxNTI0NjM1fQ.XrTZujoIp4SAapzrEAHmBYdq9JDRLRWBR6zePBCvdoo', '2020-02-12'),
(8, 2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiaWF0IjoxNTgxODIxNTc4fQ.MHakQLFd4MqQoNiMrSaSMG3hr5BixGAoYVrYLFJ4XMA', '2020-02-16'),
(9, 2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwicHJpdmlsZWdpamEiOjIsImlhdCI6MTU4MjA2OTQ5Mn0.h7hGGJe3ZqLv40Ii36e71gcpwXaBrT5kwRejWkGO0Q0', '2020-02-18'),
(10, 2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwicHJpdmlsZWdpamEiOjIsImlhdCI6MTU4MjA2OTU1NX0.ocFSKI9LeOu1jUlavlJEFB-MNgJsO6Qo4HrDUbgU578', '2020-02-19'),
(11, 2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwicHJpdmlsZWdpamEiOjIsImlhdCI6MTU4MjA2OTYxNn0.gfGeGRYxRa2o2R6b0m6k6kvikM_O0RUiRSRPcA2NrAA', '2020-02-19'),
(12, 2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwicHJpdmlsZWdpamEiOjIsImlhdCI6MTU4MjA2OTY3MH0.lA1CkjkIa4K-mNOnX_u5APWHX4HlDBnGa7Pwn-5NJFg', '2020-02-19'),
(13, 2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwicHJpdmlsZWdpamEiOjIsImlhdCI6MTU4MjA2OTY3OH0.pFFQGh0iFASaw7sr6ut9UrsS09JhVA3WV8XRJM7XStQ', '2020-02-19'),
(14, 2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwicHJpdmlsZWdpamEiOjIsImlhdCI6MTU4MjA2OTc5M30.ab2uNhBLFCzonJE147fAQ7WjNfvprQ4JSAxwOiXeXO0', '2020-02-19'),
(15, 2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwicHJpdmlsZWdpamEiOjIsImlhdCI6MTU4MjA2OTkxNX0.Nwpb7KzsdHN2N-KIcc15yHwmyb77mGAV4dP0L2z0rtg', '2020-02-19'),
(16, 2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwicHJpdmlsZWdpamEiOjIsImlhdCI6MTU4MjA3MDAxNn0.CDsqwYMhfO6pABpXBV3Sg8CSTfFRUWZuX7oVhsJ2PyI', '2020-02-19'),
(17, 2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwicHJpdmlsZWdpamEiOjIsImlhdCI6MTU4MjA3MDA2NX0.NphoTZjchN4IHEyfTu26QuiB_HJIsSIcRAkLuw3mzkk', '2020-02-19'),
(18, 2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwicHJpdmlsZWdpamEiOjIsImlhdCI6MTU4MjQ2ODk1Mn0.BwpCBV6D4SSnaJwO4zeQlHELilC0gXG_V2eh3bVTfaU', '2020-02-23'),
(19, 2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwicHJpdmlsZWdpamEiOjIsImlhdCI6MTU4MjQ2OTA4OX0.RfX7S1HQCxBWwbzcIhdQhlwFAcs5YG3cfENm1Z_F56c', '2020-02-23'),
(20, 2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwicHJpdmlsZWdpamEiOjIsImlhdCI6MTU4MjkzNjY4N30.MssL2pftxpXruVNIweYY4_v4-n_KVxwLR6li6EHyXvA', '2020-02-29'),
(21, 2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwicHJpdmlsZWdpamEiOjMsImlhdCI6MTU4MzEwODU2NH0.TzVHMG1aLtKk3nCclxxGAM8-eNV02_e4xfpHiYzwiUk', '2020-03-02'),
(22, 2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwicHJpdmlsZWdpamEiOjMsImlhdCI6MTU4MzEwOTQzNn0.GQMW8LbVUUXixitQ3sBQ5QeIsENqp0iJs9Q47Q3Vmr4', '2020-03-02'),
(23, 2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwicHJpdmlsZWdpamEiOjMsImlhdCI6MTU4MzM2MTI2NX0.rgC7QhSQVLrGN1jVwE4YPcdScCKLWRZ-vbf0dIjKg0k', '2020-03-04'),
(24, 2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwicHJpdmlsZWdpamEiOjMsImlhdCI6MTU4MzM2MTI4Nn0.RhdCarNId-gu-YNil0TbULSGc0JsEw7lxKKKzAX5u-Q', '2020-03-04'),
(25, 2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwicHJpdmlsZWdpamEiOjMsImlhdCI6MTU4MzM2MTMyMn0.KDTX3XVa4ZqAXzzWT4VOWb6piThHe_QY4tEnHMhou04', '2020-03-04'),
(26, 2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwicHJpdmlsZWdpamEiOjMsImlhdCI6MTU4NzIyNTI5NX0.Hslrt6bsuX7xpafpkvZStJgla7eRbE2_0OCKh1ivCak', '2020-04-18'),
(27, 2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwicHJpdmlsZWdpamEiOjMsImlhdCI6MTU4NzIyNzMyN30.FtCalMU9kcxtQcs9G_GlB8k6eDoigM9WLnNvhkjoZVY', '2020-04-18'),
(28, 3, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywicHJpdmlsZWdpamEiOjEsImlhdCI6MTU4NzIyNzc4OH0.mUYwo33EkXc2FsYXXn0Cz-jOj7RdCkhI4FelyZeFGIY', '2020-04-18'),
(29, 4, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicHJpdmlsZWdpamEiOjEsImlhdCI6MTU4NzIyNzgxNH0.YkuPIJGowfYWHJlc8qc4Sws_D-MSyReLbElbmXt1rSw', '2020-04-18'),
(30, 5, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwicHJpdmlsZWdpamEiOjEsImlhdCI6MTU4NzIyNzgyOX0.otWXUvh1CILP44VRKr-V6qpdzvjCQ5ekK2QzubuTYoI', '2020-04-18'),
(31, 5, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwicHJpdmlsZWdpamEiOjEsImlhdCI6MTU4NzIyNzkzM30.D7OU-DJe9rNAUTL4Jbv1s3fovWwa6kYxKRnOt7BrvjI', '2020-04-18'),
(32, 4, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicHJpdmlsZWdpamEiOjIsImlhdCI6MTU4NzMyMjI0OH0.tOIzcZJnWqXuQ2BQ4l3I9a9nWNWG9VcmdXYxkcq58ow', '2020-04-19'),
(33, 3, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywicHJpdmlsZWdpamEiOjMsImlhdCI6MTU4NzMyMjQzOX0.8INzlCVennIbyjidpd0zAgoaOTmVVObn2q5SszjY9pQ', '2020-04-19'),
(34, 3, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywicHJpdmlsZWdpamEiOjMsImlhdCI6MTU4NzMyMjkyMH0.mhGrqQS-1JPYhKv4iGju86jz8nZcayzc0pdbK1fh5fc', '2020-04-19'),
(35, 3, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywicHJpdmlsZWdpamEiOjMsImlhdCI6MTU4NzM3NDMwOX0.LWj6Tt_uoaz4Br7ul866F8DoJ_pOHCgmD9x5gl_KTag', '2020-04-20'),
(36, 3, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywicHJpdmlsZWdpamEiOjMsImlhdCI6MTU4NzM4MzYzNn0.-54Thrsh8MsNt6677HzrQwe8VrJPzmrh9sXshZ5w10I', '2020-04-20');

-- --------------------------------------------------------

--
-- Table structure for table `zadatak`
--

CREATE TABLE `zadatak` (
  `id` int(32) NOT NULL,
  `id_korisnik` int(32) NOT NULL,
  `postavka` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `zagonetka` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `rjesenje` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `hint` varchar(3000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `obrisan` tinyint(1) NOT NULL,
  `datum_kreiranja` date NOT NULL,
  `zadnja_promjena` datetime DEFAULT NULL,
  `kategorija` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `zadatak`
--

INSERT INTO `zadatak` (`id`, `id_korisnik`, `postavka`, `zagonetka`, `rjesenje`, `hint`, `obrisan`, `datum_kreiranja`, `zadnja_promjena`, `kategorija`) VALUES
(1, 1, 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst1.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 0, '2020-02-01', NULL, 3),
(2, 1, 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 0, '2020-02-01', NULL, 3),
(3, 1, 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 0, '2020-02-01', NULL, 3),
(4, 1, 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 0, '2020-02-01', NULL, 3),
(5, 1, 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 0, '2020-02-01', NULL, 3),
(6, 1, 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 0, '2020-02-01', NULL, 3),
(7, 1, 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 0, '2020-02-01', NULL, 3),
(8, 1, 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 0, '2020-02-01', NULL, 3),
(9, 1, 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 0, '2020-02-01', NULL, 3),
(10, 1, 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 0, '2020-02-01', NULL, 3),
(11, 1, 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 0, '2020-02-01', NULL, 3),
(12, 1, 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 0, '2020-02-01', NULL, 3),
(13, 1, 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 0, '2020-02-01', NULL, 3),
(14, 1, 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 0, '2020-02-01', NULL, 3),
(15, 1, 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 0, '2020-02-01', NULL, 3),
(16, 1, 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 0, '2020-02-01', NULL, 3),
(17, 1, 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 0, '2020-02-01', NULL, 3),
(18, 1, 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 0, '2020-02-01', NULL, 3),
(19, 1, 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 0, '2020-02-01', NULL, 3),
(20, 1, 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 0, '2020-02-01', NULL, 3),
(21, 1, 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 0, '2020-02-01', NULL, 3),
(22, 1, 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 0, '2020-02-01', NULL, 3),
(23, 1, 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 0, '2020-02-01', NULL, 3),
(24, 1, 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 0, '2020-02-01', NULL, 3),
(25, 1, 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 'Ovo je neki LaTeX $(3\\times 4) \\div (5-3)$ tekst.', 0, '2020-02-01', NULL, 3),
(26, 2, 'postavkaaaaa', 'zagonetkaaaaaa', 'rjesenjeeeeee', 'hintaaaaaaaaa', 0, '2020-02-25', '2020-02-25 22:59:30', 3),
(27, 2, 'postavkaaaaa', 'zagonetkaaaaaa', 'rjesenjeeeeee', 'hintaaaaaaaaa', 0, '2020-02-25', '2020-02-25 23:00:15', 3),
(28, 2, 'postavkaaaaa', 'zagonetkaaaaaa', 'rjesenjeeeeee', 'hintaaaaaaaaa', 0, '2020-02-25', '2020-02-25 23:00:38', 3),
(29, 2, 'postavkaaaaa', 'zagonetkaaaaaa', 'rjesenjeeeeee', 'hintaaaaaaaaa', 0, '2020-02-25', '2020-02-25 23:02:38', 3),
(30, 2, 'postavkaaaaa', 'zagonetkaaaaaa', 'rjesenjeeeeee', 'hintaaaaaaaaa', 0, '2020-02-25', '2020-02-25 23:03:12', 3),
(31, 2, 'postavkaaaaa $5+\\sqrt{33}$', 'zagonetkaaaaaa', 'rjesenjeeeeeea', 'hintaaaaaaaaa', 0, '2020-02-25', '2020-04-18 16:26:29', 3),
(32, 2, 'Rješi sistem jednačina metodom determinante\n$\\newline2x+y-z=1\\newline x+2y+z=8\\newline3x-y-z=-2$', 'Kada saberete x,y i z a zatim dobijeni broj stepenujete sa 4, dobićete broj čija je prva cifra 1, a zadnja 6.', 'Tražimo determinantu sistema\n$\\newline D= \n\\begin{vmatrix}\n2 & 1 & -1 & 2 & 1 \\\\\n1 & 2 & 1 & 1 & 2 \\\\\n3 & -1 & -1 & 3 & -1\n\\end{vmatrix} = \\newline =\\biggl[\\Bigl[2\\cdot2\\cdot(-1)+1\\cdot1\\cdot3+(-1)\\cdot1\\cdot(-1)\\Bigl]-\\Bigl[3\\cdot2\\cdot(-1)+(-1)\\cdot1\\cdot2+(-1)\\cdot1\\cdot1\\Bigl]\\biggl]=\\newline =(-4+3+1)-(-6-2-1)=0+9=9\\newline$\nMala napomena: kada rješavamo sistem sa 3 nepoznate pomoću determinante, potrebno je prve dvije kolone \"prepisati\" i onda tek množiti po dijagonalama. Imamo tri dijagonale odozgo prema dole i tri odozdo prema gore . Potrebno je sabrati prve tri dijagonale i onda od njih oduzeti druge tri dijagonale. Gore je ispred druge tri dijagonale izvučen minus tako da nemoj da te zbuni što su dijagonale unutar zagrada sabirane. U prvoj determinanti je detaljno prikazano kako se množe pojedinačni članovi.\n$\\newline Dx=\n\\begin{vmatrix}\n1 & 1 & -1 & 1 & 1 \\\\\n8 & 2 & 1 & 8 & 2 \\\\\n-2 & -1 & -1 & -2 & -1\n\\end{vmatrix} = (-2-2+8)-(4-1-8)=4+5=9\\newline$\n$\\newline Dy=\n\\begin{vmatrix}\n2 & 1 & -1 & 2 & 1 \\\\\n1 & 8 & 1 & 1 & 8 \\\\\n3 & -2 & -1 & 3 & -2\n\\end{vmatrix} = (-16+3+2)-(-24-4-1)=-11+29=18\\newline$\n$\\newline Dz=\n\\begin{vmatrix}\n2 & 1 & 1 & 2 & 1 \\\\\n1 & 2 & 8 & 1 & 2 \\\\\n3 & -1 & -2 & 3 & -1\n\\end{vmatrix} = (-8+24-1)-(6-16-2)=15+12=27\\newline$\n$x=\\frac{Dx}{D}=\\frac{9}{9}=1, y=\\frac{Dy}{D}=\\frac{18}{9}=2, z=\\frac{Dz}{D}=\\frac{27}{9}=3\\newline$\nKonačno rješenje $(x,y,z) = (1,2,3)$\n', 'Obratite pažnju na Sarusovo pravilo!', 0, '2020-02-25', '2020-04-20 11:06:40', 3),
(33, 2, 'Svedi sistem na standardni oblik uvođenjem smjene, a onda riješi Gaussovom eliminacijom.\n$\\newline\\frac{3}{5x-2y-9}-\\frac{4}{3x-4y+5}=\\frac{5}{6}\\newline$\n$\\frac{2}{5x-2y-9}-\\frac{5}{3x-4y+5}=\\frac{1}{6}$', 'Ukoliko saberete x i y i pronađete kvadratni korijen tog broja, prve dvije cifre tog decimalnog broja biće y i x respektivno.', 'Vidimo da su nazivnici u prvoj i drugoj jednačini identični pa uvodimo sljedeću smjenu:\n$m=\\frac{1}{5x-2y+9}, n=\\frac{1}{3x-4y+5}\\newline$\nDobijamo sljedeći sistem:\n$\\newline3m-4n=\\frac{5}{6}/\\cdot2\\newline$\n$2m-5n=\\frac{1}{6}/\\cdot(-3)\\newline$\nPomnožili smo prvu jednačinu sa 2, a drugu sa -3 kako bi koeficijenti uz x bili suprotni.\n$\\newline6m-8n=\\frac{10}{6}\\newline$\n$-6m+15n=-\\frac{3}{6}\\newline$\nNakon što saberemo jednačine dobijamo sljedeći izraz:\n$7n=\\frac{7}{6}\\Rightarrow n=\\frac{1}{6}\\newline$\nUvrštavamo nazad u $2m-5n=\\frac{1}{6}$ da bi dobili m:\n$\\newline2m=\\frac{1}{6}+\\frac{5}{6}\\Rightarrow m=\\frac{1}{2}\\newline$\nSada kada smo pronašli m i n moramo da dobijene rezultate uvrstimo u početnu smjenu:\n$m=\\frac{1}{5x-2y-9}, n=\\frac{1}{3x-4y+5}\\newline$\n$\\newline5x-2y-9=\\frac{1}{m}, 3x-4y+5=\\frac{1}{n}\\newline$\n$\\newline5x-2y-9=2/\\cdot(-2)\\newline3x-4y+5=6\\newline$\nMnožimo prvu jednačinu sa -2 kako bi koeficijenti uz y bili različiti.\n$\\newline-10x+4y+18=-4\\newline3x-4y+5=6\\newline$\nSaberemo jednačine i dobijamo:\n$\\newline-7x+23=2\\newline-7x=-21\\newline x=3\\newline$\nNakon što smo dobili x uvrstimo nazad u \n$5x-2y-9=2\\newline-2y=2+9-5\\cdot3\\newline-2y=-4\\newline y=2\\newline$\nKonačno rješenje je $(x,y)=(3,2)$.\n', 'Pogledajte brojnike i nazivnike u obje jednačine.', 0, '2020-02-25', '2020-04-20 10:48:05', 3),
(34, 2, 'postavkaaaaaaaaaaaaaaaaaa', 'zagonetkaaaaaaaaaaaa', 'rjesenjeeeeeeeeeeeee', 'hintaaaaaaaaaaaaaaaaaa', 1, '2020-02-25', '2020-03-03 23:38:38', 3),
(35, 2, 'postavkaaaaa', 'zagonetkaaaaaa', 'rjesenjeeeeee', 'hintaaaaaaaaa', 1, '2020-02-25', '2020-02-25 23:46:49', 3),
(36, 2, 'postavkaaaaa', 'zagonetkaaaaaa', 'rjesenjeeeeee', 'hintaaaaaaaaa', 1, '2020-02-25', '2020-02-25 23:47:20', 3),
(37, 2, 'saffff$3\\times5$', 'fasfsafsa', 'asdasf', 'gsdgsdfgsd', 1, '2020-02-25', '2020-02-25 23:53:02', 3);

-- --------------------------------------------------------

--
-- Table structure for table `zapamcenje`
--

CREATE TABLE `zapamcenje` (
  `id_grupa` int(32) NOT NULL,
  `id_zadatak` int(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `zapamcenje`
--

INSERT INTO `zapamcenje` (`id_grupa`, `id_zadatak`) VALUES
(2, 2),
(1, 1),
(2, 1),
(4, 1),
(4, 2),
(4, 3),
(4, 4),
(4, 5),
(4, 7),
(4, 9),
(4, 10),
(4, 11),
(4, 12),
(4, 14),
(8, 1),
(10, 33),
(16, 33);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `grupa`
--
ALTER TABLE `grupa`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `kategorija`
--
ALTER TABLE `kategorija`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `korisnik`
--
ALTER TABLE `korisnik`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sesija`
--
ALTER TABLE `sesija`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `zadatak`
--
ALTER TABLE `zadatak`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `grupa`
--
ALTER TABLE `grupa`
  MODIFY `id` int(32) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `kategorija`
--
ALTER TABLE `kategorija`
  MODIFY `id` int(32) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `korisnik`
--
ALTER TABLE `korisnik`
  MODIFY `id` int(32) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `sesija`
--
ALTER TABLE `sesija`
  MODIFY `id` int(32) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `zadatak`
--
ALTER TABLE `zadatak`
  MODIFY `id` int(32) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
