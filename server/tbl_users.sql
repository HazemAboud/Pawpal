-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 05, 2025 at 04:33 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pawpal_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(11) NOT NULL COMMENT 'Unique ID',
  `name` varchar(100) NOT NULL COMMENT 'User’s full name',
  `email` varchar(100) NOT NULL COMMENT 'User login email',
  `password` varchar(255) NOT NULL COMMENT 'Hashed password',
  `phone` varchar(20) NOT NULL COMMENT 'Required',
  `reg_date` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `name`, `email`, `password`, `phone`, `reg_date`) VALUES
(35, 'Hazem', 'hazem@gmail.com', 'e87acbc52d009d6a1d619f235198765c663e4ebe', '01209283874', '2025-11-25 22:22:44.345830'),
(36, 'Hazem', 'hazem2@gmail.com', 'e87acbc52d009d6a1d619f235198765c663e4ebe', '012984758', '2025-11-25 22:25:12.080833'),
(37, 'testUser', 'test@gmail.com', '6ceae1b3340e6bf8972a3369956c3ab35d052e36', '0192382832', '2025-11-25 22:41:52.510528'),
(38, 'test', 'test2@gmail.com', 'bab9d247bd4ff44ee7ef77bc21db2e17784e9116', '+203423123123', '2025-11-25 22:42:48.834514'),
(39, 'new', 'new@gmail.com', 'f2c57870308dc87f432e5912d4de6f8e322721ba', '0123123123', '2025-11-25 22:53:07.236039'),
(40, 'hhhh', 'haze3m@gmail.com', '88ea39439e74fa27c09a4fc0bc8ebe6d00978392', '123123123', '2025-11-25 23:25:46.071630'),
(41, 'testing@gmail.com', 'testing@gmail.com', 'b9f87d81ccb9795c4a8b82055610334e3881ca80', '123123123', '2025-11-26 19:35:50.455840'),
(42, 'gmail@gmail.com', 'gmail@gmail.com', 'da39a3ee5e6b4b0d3255bfef95601890afd80709', '01123123123', '2025-11-26 19:37:20.607664'),
(43, 'hello', 'hello@gmail.com', 'da39a3ee5e6b4b0d3255bfef95601890afd80709', '0121293123', '2025-11-26 22:24:19.413976'),
(44, 'hello2', 'hello2@gmail.com', 'da39a3ee5e6b4b0d3255bfef95601890afd80709', '0123123123', '2025-11-26 22:25:09.105002'),
(45, 'hi', 'hi@gmail.com', 'fd4744a8258c22aa3a1f758f536a99efbedb0fab', '0987654431', '2025-11-26 22:25:52.461112'),
(46, 'Try', 'try@gmail.com', 'dea38e64cded884fd9e1d36ff8e2e33fb6799eab', '0123123123123', '2025-12-05 19:03:41.396902'),
(47, 'Newacc', 'newacc@gmail.com', 'fd01a8bc41ef28a2b801c56095427bd242571982', '0123123123', '2025-12-05 22:41:57.676215');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique ID', AUTO_INCREMENT=48;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
