-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jul 20, 2024 at 02:43 AM
-- Server version: 8.0.30
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `library_management`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_new_book` (IN `book_title` VARCHAR(255), IN `pub_year` INT)   BEGIN
    INSERT INTO books (title, publication_year) VALUES (book_title, pub_year);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `list_all_books` ()   BEGIN
    SELECT * FROM books;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_return_date` (IN `p_borrow_id` INT, IN `p_return_date` DATE)   BEGIN
    DECLARE current_return_date DATE;
    
    -- Pastikan hanya mengembalikan satu baris
    SELECT return_date INTO current_return_date 
    FROM borrowed_books 
    WHERE borrow_id = p_borrow_id
    LIMIT 1;
    
    IF current_return_date IS NULL THEN
        UPDATE borrowed_books 
        SET return_date = p_return_date 
        WHERE borrow_id = p_borrow_id;
    ELSE
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Book has already been returned';
    END IF;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `count_borrowed_books` (`member_id` INT, `status` BOOLEAN) RETURNS INT DETERMINISTIC READS SQL DATA BEGIN
    DECLARE total INT;
    IF status THEN
        SELECT COUNT(*) INTO total FROM borrowed_books WHERE member_id = member_id AND return_date IS NOT NULL;
    ELSE
        SELECT COUNT(*) INTO total FROM borrowed_books WHERE member_id = member_id AND return_date IS NULL;
    END IF;
    RETURN total;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `total_books` () RETURNS INT DETERMINISTIC READS SQL DATA BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM books;
    RETURN total;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `authors`
--

CREATE TABLE `authors` (
  `author_id` int NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `authors`
--

INSERT INTO `authors` (`author_id`, `name`) VALUES
(1, 'J.K. Rowling'),
(3, 'J.R.R. Tolkien'),
(4, 'Agatha Christie'),
(5, 'Stephen King');

--
-- Triggers `authors`
--
DELIMITER $$
CREATE TRIGGER `before_delete_authors` BEFORE DELETE ON `authors` FOR EACH ROW BEGIN
    INSERT INTO log (action, description) VALUES ('DELETE', CONCAT('Deleting author: ', OLD.name));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `authors_books`
--

CREATE TABLE `authors_books` (
  `author_id` int NOT NULL,
  `book_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `authors_books`
--

INSERT INTO `authors_books` (`author_id`, `book_id`) VALUES
(1, 1),
(3, 3),
(4, 4),
(5, 5);

-- --------------------------------------------------------

--
-- Table structure for table `author_details`
--

CREATE TABLE `author_details` (
  `author_id` int NOT NULL,
  `biography` text,
  `birth_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE `books` (
  `book_id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `publication_year` int DEFAULT NULL,
  `genre` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `books`
--

INSERT INTO `books` (`book_id`, `title`, `publication_year`, `genre`) VALUES
(1, 'New Book Title Update', 1997, 'Fantasy'),
(2, 'A Game of Thrones', 1996, 'Fantasy'),
(3, 'The Hobbit', 1937, 'Fantasy'),
(4, 'Murder on the Orient Express', 1934, 'Mystery'),
(5, 'The Shining', 1977, 'Horror'),
(6, 'Harry Potter and the Philosopher\'s Stone', 1997, 'Fantasy'),
(7, 'A Game of Thrones', 1996, 'Fantasy'),
(8, 'The Hobbit', 1937, 'Fantasy'),
(9, 'Murder on the Orient Express', 1934, 'Mystery'),
(10, 'The Shining', 1977, 'Horror'),
(11, 'Harry Potter and the Philosopher\'s Stone', 1997, 'Fantasy'),
(12, 'A Game of Thrones', 1996, 'Fantasy'),
(13, 'The Hobbit', 1937, 'Fantasy'),
(14, 'Murder on the Orient Express', 1934, 'Mystery'),
(15, 'The Shining', 1977, 'Horror'),
(16, 'Minions', 2024, NULL),
(17, 'Minions', 2024, 'Science Fiction'),
(18, 'New Book Title Update', NULL, NULL),
(19, 'The Great Gatsby', 1925, NULL);

--
-- Triggers `books`
--
DELIMITER $$
CREATE TRIGGER `before_insert_books` BEFORE INSERT ON `books` FOR EACH ROW BEGIN
    INSERT INTO log (action, description) VALUES ('INSERT', CONCAT('Inserting book: ', NEW.title));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `book_titles`
-- (See below for the actual view)
--
CREATE TABLE `book_titles` (
`book_id` int
,`title` varchar(255)
);

-- --------------------------------------------------------

--
-- Table structure for table `borrowed_books`
--

CREATE TABLE `borrowed_books` (
  `borrow_id` int NOT NULL,
  `member_id` int DEFAULT NULL,
  `book_id` int DEFAULT NULL,
  `borrow_date` date DEFAULT NULL,
  `return_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `borrowed_books`
--

INSERT INTO `borrowed_books` (`borrow_id`, `member_id`, `book_id`, `borrow_date`, `return_date`) VALUES
(2, 2, 2, '2024-06-15', '2024-07-10'),
(3, 3, 3, '2024-07-05', NULL),
(4, 4, 4, '2024-06-25', '2024-07-12'),
(5, 5, 5, '2024-07-10', NULL),
(17, 2, 1, '2024-01-15', NULL),
(18, 1, 2, '2024-07-20', NULL);

--
-- Triggers `borrowed_books`
--
DELIMITER $$
CREATE TRIGGER `after_delete_borrowed_books` AFTER DELETE ON `borrowed_books` FOR EACH ROW BEGIN
    INSERT INTO log (action, description) VALUES ('DELETE', CONCAT('Borrow record deleted: ', OLD.borrow_id));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_insert_borrowed_books` AFTER INSERT ON `borrowed_books` FOR EACH ROW BEGIN
    INSERT INTO log (action, description) VALUES ('INSERT', CONCAT('Book borrowed by member: ', NEW.member_id, ', book: ', NEW.book_id));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `borrowed_books_recent_view`
-- (See below for the actual view)
--
CREATE TABLE `borrowed_books_recent_view` (
`book_title` varchar(255)
,`borrow_date` date
,`borrow_id` int
,`member_name` varchar(255)
,`return_date` date
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `borrowed_books_view`
-- (See below for the actual view)
--
CREATE TABLE `borrowed_books_view` (
`book_title` varchar(255)
,`borrow_date` date
,`borrow_id` int
,`member_name` varchar(255)
,`return_date` date
);

-- --------------------------------------------------------

--
-- Table structure for table `libraries`
--

CREATE TABLE `libraries` (
  `library_id` int NOT NULL,
  `member_id` int DEFAULT NULL,
  `library_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `libraries`
--

INSERT INTO `libraries` (`library_id`, `member_id`, `library_name`) VALUES
(1, 1, 'Oxford'),
(2, 2, 'West End Library'),
(3, 3, 'East Side Library'),
(4, 4, 'North Branch Library'),
(5, 5, 'South Branch Library');

--
-- Triggers `libraries`
--
DELIMITER $$
CREATE TRIGGER `after_update_libraries` AFTER UPDATE ON `libraries` FOR EACH ROW BEGIN
    INSERT INTO log (action, description) VALUES ('UPDATE', CONCAT('Library updated: ', OLD.library_name, ' to ', NEW.library_name));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `log`
--

CREATE TABLE `log` (
  `log_id` int NOT NULL,
  `action` varchar(255) DEFAULT NULL,
  `description` text,
  `action_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `log`
--

INSERT INTO `log` (`log_id`, `action`, `description`, `action_time`) VALUES
(10, 'INSERT', 'Inserting book: The Great Gatsby', '2024-07-20 00:58:00'),
(11, 'INSERT', 'Book borrowed by member: 1, book: 2', '2024-07-20 01:01:29'),
(12, 'UPDATE', 'Updating member: Alice Johnson to John Doe Jr.', '2024-07-20 01:03:28'),
(13, 'UPDATE', 'Library updated: Central Library to Oxford', '2024-07-20 01:04:23'),
(14, 'DELETE', 'Deleting author: George R.R. Martin', '2024-07-20 01:05:21'),
(15, 'DELETE', 'Borrow record deleted: 1', '2024-07-20 01:06:21');

-- --------------------------------------------------------

--
-- Table structure for table `members`
--

CREATE TABLE `members` (
  `member_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `address` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `members`
--

INSERT INTO `members` (`member_id`, `name`, `address`) VALUES
(1, 'John Doe Jr.', '123 Elm St.'),
(2, 'Bob Smith', '456 Oak St.'),
(3, 'Carol White', '789 Pine St.'),
(4, 'David Brown', '101 Maple St.'),
(5, 'Eve Davis', '202 Birch St.');

--
-- Triggers `members`
--
DELIMITER $$
CREATE TRIGGER `before_update_members` BEFORE UPDATE ON `members` FOR EACH ROW BEGIN
    INSERT INTO log (action, description) VALUES ('UPDATE', CONCAT('Updating member: ', OLD.name, ' to ', NEW.name));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `recent_books`
-- (See below for the actual view)
--
CREATE TABLE `recent_books` (
`book_id` int
,`genre` varchar(100)
,`publication_year` int
,`title` varchar(255)
);

-- --------------------------------------------------------

--
-- Structure for view `book_titles`
--
DROP TABLE IF EXISTS `book_titles`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `book_titles`  AS SELECT `books`.`book_id` AS `book_id`, `books`.`title` AS `title` FROM `books` ;

-- --------------------------------------------------------

--
-- Structure for view `borrowed_books_recent_view`
--
DROP TABLE IF EXISTS `borrowed_books_recent_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `borrowed_books_recent_view`  AS SELECT `borrowed_books_view`.`borrow_id` AS `borrow_id`, `borrowed_books_view`.`member_name` AS `member_name`, `borrowed_books_view`.`book_title` AS `book_title`, `borrowed_books_view`.`borrow_date` AS `borrow_date`, `borrowed_books_view`.`return_date` AS `return_date` FROM `borrowed_books_view` WHERE (`borrowed_books_view`.`borrow_date` > '2020-01-01')WITH CASCADED CHECK OPTION  ;

-- --------------------------------------------------------

--
-- Structure for view `borrowed_books_view`
--
DROP TABLE IF EXISTS `borrowed_books_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `borrowed_books_view`  AS SELECT `bb`.`borrow_id` AS `borrow_id`, `m`.`name` AS `member_name`, `b`.`title` AS `book_title`, `bb`.`borrow_date` AS `borrow_date`, `bb`.`return_date` AS `return_date` FROM ((`borrowed_books` `bb` join `members` `m` on((`bb`.`member_id` = `m`.`member_id`))) join `books` `b` on((`bb`.`book_id` = `b`.`book_id`))) ;

-- --------------------------------------------------------

--
-- Structure for view `recent_books`
--
DROP TABLE IF EXISTS `recent_books`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `recent_books`  AS SELECT `books`.`book_id` AS `book_id`, `books`.`title` AS `title`, `books`.`publication_year` AS `publication_year`, `books`.`genre` AS `genre` FROM `books` WHERE (`books`.`publication_year` > 2010) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `authors`
--
ALTER TABLE `authors`
  ADD PRIMARY KEY (`author_id`);

--
-- Indexes for table `authors_books`
--
ALTER TABLE `authors_books`
  ADD PRIMARY KEY (`author_id`,`book_id`),
  ADD KEY `book_id` (`book_id`);

--
-- Indexes for table `author_details`
--
ALTER TABLE `author_details`
  ADD PRIMARY KEY (`author_id`),
  ADD KEY `birth_date` (`birth_date`);

--
-- Indexes for table `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`book_id`),
  ADD KEY `idx_books_genre_year` (`genre`,`publication_year`);

--
-- Indexes for table `borrowed_books`
--
ALTER TABLE `borrowed_books`
  ADD PRIMARY KEY (`borrow_id`),
  ADD KEY `book_id` (`book_id`),
  ADD KEY `idx_member_book` (`member_id`,`book_id`);

--
-- Indexes for table `libraries`
--
ALTER TABLE `libraries`
  ADD PRIMARY KEY (`library_id`),
  ADD KEY `member_id` (`member_id`);

--
-- Indexes for table `log`
--
ALTER TABLE `log`
  ADD PRIMARY KEY (`log_id`);

--
-- Indexes for table `members`
--
ALTER TABLE `members`
  ADD PRIMARY KEY (`member_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `authors`
--
ALTER TABLE `authors`
  MODIFY `author_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `books`
--
ALTER TABLE `books`
  MODIFY `book_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `borrowed_books`
--
ALTER TABLE `borrowed_books`
  MODIFY `borrow_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `libraries`
--
ALTER TABLE `libraries`
  MODIFY `library_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `log`
--
ALTER TABLE `log`
  MODIFY `log_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `members`
--
ALTER TABLE `members`
  MODIFY `member_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `authors_books`
--
ALTER TABLE `authors_books`
  ADD CONSTRAINT `authors_books_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `authors` (`author_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `authors_books_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`) ON DELETE CASCADE;

--
-- Constraints for table `borrowed_books`
--
ALTER TABLE `borrowed_books`
  ADD CONSTRAINT `borrowed_books_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `members` (`member_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `borrowed_books_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`) ON DELETE CASCADE;

--
-- Constraints for table `libraries`
--
ALTER TABLE `libraries`
  ADD CONSTRAINT `libraries_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `members` (`member_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
