USE [master]
GO
/****** Object:  Database [Pongshore]    Script Date: 8/15/2013 5:00:37 PM ******/
CREATE DATABASE [Pongshore]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Pongshore', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\Pongshore.mdf' , SIZE = 3136KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Pongshore_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\Pongshore_log.ldf' , SIZE = 784KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Pongshore] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Pongshore].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Pongshore] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Pongshore] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Pongshore] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Pongshore] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Pongshore] SET ARITHABORT OFF 
GO
ALTER DATABASE [Pongshore] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [Pongshore] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [Pongshore] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Pongshore] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Pongshore] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Pongshore] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Pongshore] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Pongshore] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Pongshore] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Pongshore] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Pongshore] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Pongshore] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Pongshore] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Pongshore] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Pongshore] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Pongshore] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Pongshore] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Pongshore] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Pongshore] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Pongshore] SET  MULTI_USER 
GO
ALTER DATABASE [Pongshore] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Pongshore] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Pongshore] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Pongshore] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [Pongshore]
GO
/****** Object:  StoredProcedure [dbo].[Add_Game_Played]    Script Date: 8/15/2013 5:00:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Add_Game_Played] 
	@Email varchar(50)
AS
BEGIN
	update Users set gamesPlayed = (
		select gamesPlayed+1 from Users u1
		where u1.id = Users.id
	)
	where email = @Email
END

GO
/****** Object:  StoredProcedure [dbo].[Add_Player_Win]    Script Date: 8/15/2013 5:00:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Add_Player_Win] 
	@Email varchar(50)
AS
BEGIN
	update Users set gamesWon = (
		select gamesWon+1 from Users u1
		where u1.id = Users.id
	)
	where email = @Email
END

GO
/****** Object:  StoredProcedure [dbo].[Create_Game]    Script Date: 8/15/2013 5:00:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Create_Game] 
	@WinnerID int
	,@LoserID int
	,@WinnerScore int
	,@LoserScore int
	,@Date datetime
AS
BEGIN
	insert into Games values (
		@WinnerID
		,@LoserID
		,@WinnerScore
		,@LoserScore
		,@Date
	)
END

GO
/****** Object:  StoredProcedure [dbo].[Get_All_Games]    Script Date: 8/15/2013 5:00:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_All_Games]
	@WinnerScore int
	,@LoserScore int
	,@Date datetime
AS
BEGIN
	select WinnerScore, LoserScore, [Date]
		   ,winner.email, winner.gamesWon, winner.gamesPlayed
		   ,loser.email, loser.gamesWon, loser.gamesPlayed from Games
	join Users winner
	on winner.id = WinnerID
	join Users loser
	on loser.id = LoserID
END

GO
/****** Object:  StoredProcedure [dbo].[Get_Games_By_User]    Script Date: 8/15/2013 5:00:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_Games_By_User]
	@ID int
AS
BEGIN
	select * from Games
	where LoserID = @ID
	union
	select * from Games
	where WinnerID = @ID
END

GO
/****** Object:  StoredProcedure [dbo].[Get_Games_Lost_By_User]    Script Date: 8/15/2013 5:00:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_Games_Lost_By_User]
	@ID int
AS
BEGIN
	select * from Games
	where LoserID = @ID
END

GO
/****** Object:  StoredProcedure [dbo].[Get_Games_Won_By_User]    Script Date: 8/15/2013 5:00:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_Games_Won_By_User]
	@ID int
AS
BEGIN
	select * from Games
	where WinnerID = @ID
END

GO
/****** Object:  StoredProcedure [dbo].[Get_User]    Script Date: 8/15/2013 5:00:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_User] 
	@Email varchar(50)
AS
BEGIN
	select * from Users
	where email = @Email
END

GO
/****** Object:  StoredProcedure [dbo].[Insert_User]    Script Date: 8/15/2013 5:00:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Insert_User] 
	@Email varchar(50)
	,@Password varchar(20)
AS
BEGIN
	insert into Users values (
		@Email
		,@Password
		,null
		,null
		)
END

GO
/****** Object:  StoredProcedure [dbo].[Update_User]    Script Date: 8/15/2013 5:00:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Update_User] 
	@OldEmail varchar(50)
	,@NewEmail varchar(50)
	,@Password varchar(20)
AS
BEGIN
	update Users set Email = @NewEmail
					 ,[Password] = @Password
				 where Email = @OldEmail
END

GO
/****** Object:  Table [dbo].[Games]    Script Date: 8/15/2013 5:00:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Games](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[WinnerID] [int] NULL,
	[LoserID] [int] NULL,
	[WinnerScore] [int] NOT NULL,
	[LoserScore] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Users]    Script Date: 8/15/2013 5:00:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Users](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[email] [varchar](50) NOT NULL,
	[password] [varchar](20) NOT NULL,
	[gamesWon] [int] NULL,
	[gamesPlayed] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Games]  WITH CHECK ADD FOREIGN KEY([LoserID])
REFERENCES [dbo].[Users] ([id])
GO
ALTER TABLE [dbo].[Games]  WITH CHECK ADD FOREIGN KEY([WinnerID])
REFERENCES [dbo].[Users] ([id])
GO
USE [master]
GO
ALTER DATABASE [Pongshore] SET  READ_WRITE 
GO
