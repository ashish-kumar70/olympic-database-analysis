USE [master]
GO
/****** Object:  Database [olympic_database]    Script Date: 24-05-2023 12:25:30 ******/
CREATE DATABASE [olympic_database]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'olympic_database', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\olympic_database.mdf' , SIZE = 204800KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'olympic_database_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\olympic_database_log.ldf' , SIZE = 270336KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [olympic_database] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [olympic_database].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [olympic_database] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [olympic_database] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [olympic_database] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [olympic_database] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [olympic_database] SET ARITHABORT OFF 
GO
ALTER DATABASE [olympic_database] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [olympic_database] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [olympic_database] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [olympic_database] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [olympic_database] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [olympic_database] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [olympic_database] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [olympic_database] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [olympic_database] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [olympic_database] SET  ENABLE_BROKER 
GO
ALTER DATABASE [olympic_database] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [olympic_database] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [olympic_database] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [olympic_database] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [olympic_database] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [olympic_database] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [olympic_database] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [olympic_database] SET RECOVERY FULL 
GO
ALTER DATABASE [olympic_database] SET  MULTI_USER 
GO
ALTER DATABASE [olympic_database] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [olympic_database] SET DB_CHAINING OFF 
GO
ALTER DATABASE [olympic_database] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [olympic_database] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [olympic_database] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [olympic_database] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'olympic_database', N'ON'
GO
ALTER DATABASE [olympic_database] SET QUERY_STORE = ON
GO
ALTER DATABASE [olympic_database] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [olympic_database]
GO
/****** Object:  Table [dbo].[olympic_history]    Script Date: 24-05-2023 12:25:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[olympic_history](
	[ID] [int] NOT NULL,
	[Name] [nvarchar](250) NOT NULL,
	[Sex] [nvarchar](10) NOT NULL,
	[Age] [tinyint] NULL,
	[Height] [tinyint] NULL,
	[Weight] [float] NULL,
	[Team] [nvarchar](50) NOT NULL,
	[NOC] [nvarchar](50) NOT NULL,
	[Games] [nvarchar](50) NOT NULL,
	[Year] [smallint] NOT NULL,
	[Season] [nvarchar](20) NOT NULL,
	[City] [nvarchar](50) NOT NULL,
	[Sport] [nvarchar](50) NOT NULL,
	[Event] [nvarchar](100) NOT NULL,
	[Medal] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[regions]    Script Date: 24-05-2023 12:25:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[regions](
	[NOC] [nvarchar](50) NOT NULL,
	[region] [nvarchar](50) NOT NULL,
	[notes] [nvarchar](50) NULL
) ON [PRIMARY]
GO
USE [master]
GO
ALTER DATABASE [olympic_database] SET  READ_WRITE 
GO
