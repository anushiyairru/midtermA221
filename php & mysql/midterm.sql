-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 06, 2023 at 01:28 AM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `midterm`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_homestays`
--

CREATE TABLE `tbl_homestays` (
  `homestay_id` int(5) NOT NULL,
  `user_id` varchar(10) NOT NULL,
  `homestay_name` varchar(100) NOT NULL,
  `homestay_desc` varchar(500) NOT NULL,
  `homestay_price` float NOT NULL,
  `homestay_delivery` float NOT NULL,
  `homestay_qty` int(6) NOT NULL,
  `homestay_state` varchar(20) NOT NULL,
  `homestay_local` varchar(50) NOT NULL,
  `homestay_lat` varchar(15) NOT NULL,
  `homestay_lng` varchar(15) NOT NULL,
  `homestay_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_homestays`
--

INSERT INTO `tbl_homestays` (`homestay_id`, `user_id`, `homestay_name`, `homestay_desc`, `homestay_price`, `homestay_delivery`, `homestay_qty`, `homestay_state`, `homestay_local`, `homestay_lat`, `homestay_lng`, `homestay_date`) VALUES
(1, '3', 'Anushiya Inn', 'Beautiful area with a scnenic view', 120, 35, 4, 'Kedah', 'Changlun', '6.4318283', '100.4299967', '0000-00-00 00:00:00.000000'),
(2, '3', 'Sha Homestay', 'Very clean place with a lot of food', 178, 10, 6, 'Kedah', 'Changlun', '6.4318283', '100.4299967', '0000-00-00 00:00:00.000000');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(5) NOT NULL,
  `user_email` varchar(50) NOT NULL,
  `user_name` varchar(50) NOT NULL,
  `user_phone` varchar(15) NOT NULL,
  `user_address` varchar(500) NOT NULL,
  `user_datereg` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `user_otp` int(5) NOT NULL,
  `user_password` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `user_email`, `user_name`, `user_phone`, `user_address`, `user_datereg`, `user_otp`, `user_password`) VALUES
(1, 'a@b.c', 'Debbie', '1234567890', 'na', '2023-01-06 02:39:56.597496', 86354, 'dca0a5afd0b457ee36f8862369c7fda58c162b25'),
(2, 'sha@a.c', 'sha', '1234567890', 'na', '2023-01-06 04:35:26.514617', 94210, 'dca0a5afd0b457ee36f8862369c7fda58c162b25'),
(3, 'anushiya@gmail.com', 'anushiya', '01116550117', 'na', '2023-01-06 08:21:30.089044', 58386, 'dca0a5afd0b457ee36f8862369c7fda58c162b25');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_homestays`
--
ALTER TABLE `tbl_homestays`
  ADD PRIMARY KEY (`homestay_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `user_email` (`user_email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_homestays`
--
ALTER TABLE `tbl_homestays`
  MODIFY `homestay_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
