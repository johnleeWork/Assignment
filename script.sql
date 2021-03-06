USE [master]
GO
/****** Object:  Database [ASSC]    Script Date: 3/17/2021 11:38:41 AM ******/
CREATE DATABASE [ASSC]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ASSC', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\ASSC.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'ASSC_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\ASSC_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [ASSC] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ASSC].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ASSC] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ASSC] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ASSC] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ASSC] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ASSC] SET ARITHABORT OFF 
GO
ALTER DATABASE [ASSC] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ASSC] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ASSC] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ASSC] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ASSC] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ASSC] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ASSC] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ASSC] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ASSC] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ASSC] SET  ENABLE_BROKER 
GO
ALTER DATABASE [ASSC] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ASSC] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ASSC] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ASSC] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ASSC] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ASSC] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ASSC] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ASSC] SET RECOVERY FULL 
GO
ALTER DATABASE [ASSC] SET  MULTI_USER 
GO
ALTER DATABASE [ASSC] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ASSC] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ASSC] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ASSC] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [ASSC] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [ASSC] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'ASSC', N'ON'
GO
ALTER DATABASE [ASSC] SET QUERY_STORE = OFF
GO
USE [ASSC]
GO
/****** Object:  Table [dbo].[tblCategory]    Script Date: 3/17/2021 11:38:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCategory](
	[categoryID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[categoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblOrderDetails]    Script Date: 3/17/2021 11:38:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblOrderDetails](
	[detailID] [int] IDENTITY(1,1) NOT NULL,
	[orderID] [int] NOT NULL,
	[phoneID] [int] NOT NULL,
	[quantity] [int] NOT NULL,
	[price] [float] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[detailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblOrders]    Script Date: 3/17/2021 11:38:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblOrders](
	[orderID] [int] NOT NULL,
	[userID] [varchar](50) NOT NULL,
	[total] [float] NOT NULL,
	[dateBuy] [datetime] NULL,
	[address] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[orderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblProduct]    Script Date: 3/17/2021 11:38:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblProduct](
	[phoneID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](500) NOT NULL,
	[quantity] [int] NOT NULL,
	[price] [float] NOT NULL,
	[categoryID] [int] NOT NULL,
	[imagePath] [nvarchar](max) NOT NULL,
	[status] [bit] NULL,
 CONSTRAINT [PK__tblPhone__960F2E751536DF47] PRIMARY KEY CLUSTERED 
(
	[phoneID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblRoles]    Script Date: 3/17/2021 11:38:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblRoles](
	[roleID] [varchar](10) NOT NULL,
	[name] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[roleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblUsers]    Script Date: 3/17/2021 11:38:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUsers](
	[userID] [varchar](50) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[email] [varchar](50) NOT NULL,
	[password] [varchar](50) NULL,
	[address] [nvarchar](500) NOT NULL,
	[roleID] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[userID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[tblCategory] ON 

INSERT [dbo].[tblCategory] ([categoryID], [name]) VALUES (1, N'Apple')
INSERT [dbo].[tblCategory] ([categoryID], [name]) VALUES (2, N'Samsung')
INSERT [dbo].[tblCategory] ([categoryID], [name]) VALUES (3, N'Xiaomi')
INSERT [dbo].[tblCategory] ([categoryID], [name]) VALUES (5, N'OPPO')
SET IDENTITY_INSERT [dbo].[tblCategory] OFF
GO
SET IDENTITY_INSERT [dbo].[tblProduct] ON 

INSERT [dbo].[tblProduct] ([phoneID], [name], [Description], [quantity], [price], [categoryID], [imagePath], [status]) VALUES (1, N'Iphone 11', N'tinh nang moi nhieu uu dai', 20, 200, 1, N'/Content/upload/iphone11.jpg', 1)
INSERT [dbo].[tblProduct] ([phoneID], [name], [Description], [quantity], [price], [categoryID], [imagePath], [status]) VALUES (2, N'Iphone 11 pro max', N'tinh nang moi nhieu uu dai', 20, 300, 1, N'/Content/upload/iphone11ProMax.jpg', 1)
INSERT [dbo].[tblProduct] ([phoneID], [name], [Description], [quantity], [price], [categoryID], [imagePath], [status]) VALUES (3, N'Iphone 12', N'tinh nang moi nhieu uu dai', 20, 400, 1, N'/Content/upload/iphone12.jpg', 1)
INSERT [dbo].[tblProduct] ([phoneID], [name], [Description], [quantity], [price], [categoryID], [imagePath], [status]) VALUES (4, N'Iphone 12 mini', N'tinh nang moi nhieu uu dai', 20, 200, 1, N'/Content/upload/iphone12mini.png', 1)
INSERT [dbo].[tblProduct] ([phoneID], [name], [Description], [quantity], [price], [categoryID], [imagePath], [status]) VALUES (5, N'Iphone 12 Pro Max ', N'tinh nang moi nhieu uu dai', 20, 400, 1, N'/Content/upload/iphoneXR.jpg', 1)
INSERT [dbo].[tblProduct] ([phoneID], [name], [Description], [quantity], [price], [categoryID], [imagePath], [status]) VALUES (6, N'Iphone XR', N'tinh nang moi nhieu uu dai', 20, 300, 1, N'/Content/upload/1903327836DSCF9165.jpg', 1)
INSERT [dbo].[tblProduct] ([phoneID], [name], [Description], [quantity], [price], [categoryID], [imagePath], [status]) VALUES (11, N'Iphone XS max', N'tinh nang moi nhieu uu dai', 20, 250, 1, N'/Content/upload/iphoneXsMax.jpg', 1)
INSERT [dbo].[tblProduct] ([phoneID], [name], [Description], [quantity], [price], [categoryID], [imagePath], [status]) VALUES (12, N'Oppo A31', N'tinh nang moi nhieu uu dai', 30, 100, 5, N'/Content/upload/oppoA31.jpg', 1)
INSERT [dbo].[tblProduct] ([phoneID], [name], [Description], [quantity], [price], [categoryID], [imagePath], [status]) VALUES (13, N'Oppo A53', N'tinh nang moi nhieu uu dai', 30, 100, 5, N'/Content/upload/oppoA53.jpg', 1)
INSERT [dbo].[tblProduct] ([phoneID], [name], [Description], [quantity], [price], [categoryID], [imagePath], [status]) VALUES (14, N'Oppo A92', N'tinh nang moi nhieu uu dai', 30, 100, 5, N'/Content/upload/oppoA92.jpg', 1)
INSERT [dbo].[tblProduct] ([phoneID], [name], [Description], [quantity], [price], [categoryID], [imagePath], [status]) VALUES (15, N'Samsung A12', N'tinh nang moi nhieu uu dai', 30, 100, 2, N'/Content/upload/samsungA12.jpg', 1)
INSERT [dbo].[tblProduct] ([phoneID], [name], [Description], [quantity], [price], [categoryID], [imagePath], [status]) VALUES (16, N'Samsung A70', N'tinh nang moi nhieu uu dai', 30, 100, 2, N'/Content/upload/samsungA70.jpg', 1)
INSERT [dbo].[tblProduct] ([phoneID], [name], [Description], [quantity], [price], [categoryID], [imagePath], [status]) VALUES (17, N'Samsung M51', N'tinh nang moi nhieu uu dai', 30, 100, 2, N'/Content/upload/samsungM51.jpg', 1)
INSERT [dbo].[tblProduct] ([phoneID], [name], [Description], [quantity], [price], [categoryID], [imagePath], [status]) VALUES (18, N'Samsung Note 10', N'tinh nang moi nhieu uu dai', 30, 100, 2, N'/Content/upload/samsungNote10.jpg', 1)
INSERT [dbo].[tblProduct] ([phoneID], [name], [Description], [quantity], [price], [categoryID], [imagePath], [status]) VALUES (19, N'Samsung Note 20', N'tinh nang moi nhieu uu dai', 30, 100, 2, N'/Content/upload/samsungNote20.jpg', 1)
INSERT [dbo].[tblProduct] ([phoneID], [name], [Description], [quantity], [price], [categoryID], [imagePath], [status]) VALUES (20, N'Samsung S20', N'tinh nang moi nhieu uu dai', 30, 100, 2, N'/Content/upload/samsungS20.jpg', 1)
INSERT [dbo].[tblProduct] ([phoneID], [name], [Description], [quantity], [price], [categoryID], [imagePath], [status]) VALUES (21, N'Samsung S21', N'tinh nang moi nhieu uu dai', 30, 100, 2, N'/Content/upload/samsungS21.jpg', 1)
INSERT [dbo].[tblProduct] ([phoneID], [name], [Description], [quantity], [price], [categoryID], [imagePath], [status]) VALUES (22, N'Xiaomi 9A', N'tinh nang moi nhieu uu dai', 30, 100, 3, N'/Content/upload/xiaomi9A.jpg', 1)
INSERT [dbo].[tblProduct] ([phoneID], [name], [Description], [quantity], [price], [categoryID], [imagePath], [status]) VALUES (23, N'Xiaomi Mi 8', N'tinh nang moi nhieu uu dai', 30, 100, 3, N'/Content/upload/xiaomiMi8.jpg', 1)
INSERT [dbo].[tblProduct] ([phoneID], [name], [Description], [quantity], [price], [categoryID], [imagePath], [status]) VALUES (24, N'Xiaomi Mi 10', N'tinh nang moi nhieu uu dai', 30, 100, 3, N'/Content/upload/xiaomiMi10.jpg', 1)
INSERT [dbo].[tblProduct] ([phoneID], [name], [Description], [quantity], [price], [categoryID], [imagePath], [status]) VALUES (25, N'Xiaomi Note 8', N'tinh nang moi nhieu uu dai', 30, 100, 3, N'/Content/upload/xiaomiNote8.jpg', 1)
INSERT [dbo].[tblProduct] ([phoneID], [name], [Description], [quantity], [price], [categoryID], [imagePath], [status]) VALUES (26, N'Xiaomi Note 9', N'tinh nang moi nhieu uu dai', 30, 100, 3, N'/Content/upload/xiaomiNote9.jpg', 1)
INSERT [dbo].[tblProduct] ([phoneID], [name], [Description], [quantity], [price], [categoryID], [imagePath], [status]) VALUES (27, N'Xiaomi Note 10', N'tinh nang moi nhieu uu dai', 30, 100, 3, N'/Content/upload/xiaomiNote10.jpg', 1)
SET IDENTITY_INSERT [dbo].[tblProduct] OFF
GO
INSERT [dbo].[tblRoles] ([roleID], [name]) VALUES (N'AD', N'Admin')
INSERT [dbo].[tblRoles] ([roleID], [name]) VALUES (N'US', N'User')
GO
INSERT [dbo].[tblUsers] ([userID], [name], [email], [password], [address], [roleID]) VALUES (N'amccannya', N'Andie McCanny', N'amccannya@icq.com', N'4QIEziGmUD', N'69 Continental Terrace', N'US')
INSERT [dbo].[tblUsers] ([userID], [name], [email], [password], [address], [roleID]) VALUES (N'astainton2', N'Alfreda Stainton', N'astainton2@ucla.edu', N'sRJIsfIJHGq4', N'505 Brentwood Center', N'US')
INSERT [dbo].[tblUsers] ([userID], [name], [email], [password], [address], [roleID]) VALUES (N'bdo6666', N'Brigit Do Rosario', N'bdo6@51.la', N'nt9neu3o6Pb', N'5 Monument Crossing', N'US')
INSERT [dbo].[tblUsers] ([userID], [name], [email], [password], [address], [roleID]) VALUES (N'cciccarelli4', N'Chance Ciccarelli', N'cciccarelli4@google.com.br', N'0zH196r', N'31 Shasta Place', N'US')
INSERT [dbo].[tblUsers] ([userID], [name], [email], [password], [address], [roleID]) VALUES (N'cravilus9', N'Chrissy Ravilus', N'cravilus9@oaic.gov.au', N'U1bsQu9uE', N'9193 Anderson Plaza', N'US')
INSERT [dbo].[tblUsers] ([userID], [name], [email], [password], [address], [roleID]) VALUES (N'egarmans3', N'Emelda Garmans', N'egarmans3@china.com.cn', N'pkA0QJ2cHy0N', N'77124 Eagle Crest Road', N'US')
INSERT [dbo].[tblUsers] ([userID], [name], [email], [password], [address], [roleID]) VALUES (N'kcousens7', N'Kerwin Cousens', N'kcousens7@symantec.com', N'8zvpuZv', N'068 Gale Lane', N'US')
INSERT [dbo].[tblUsers] ([userID], [name], [email], [password], [address], [roleID]) VALUES (N'luan123', N'Mannie Drust', N'luan@gmail.com', N'123456', N'0 Clemons Way', N'AD')
INSERT [dbo].[tblUsers] ([userID], [name], [email], [password], [address], [roleID]) VALUES (N'mcraythornj', N'Mindy Craythorn', N'mcraythornj@jimdo.com', N'4qBZ73V0', N'62782 Dayton Way', N'US')
INSERT [dbo].[tblUsers] ([userID], [name], [email], [password], [address], [roleID]) VALUES (N'nbarchrameev5', N'Nelson Barchrameev', N'nbarchrameev5@dell.com', N'8BB8UV', N'4897 Mockingbird Alley', N'US')
INSERT [dbo].[tblUsers] ([userID], [name], [email], [password], [address], [roleID]) VALUES (N'ndrewb', N'Nannette Drew', N'ndrewb@imageshack.us', N'4yxtAbui', N'7341 Westerfield Terrace', N'US')
INSERT [dbo].[tblUsers] ([userID], [name], [email], [password], [address], [roleID]) VALUES (N'pcunde8', N'Philly Cunde', N'pcunde8@marriott.com', N'r4PQ3iwV6d', N'5 Rockefeller Alley', N'US')
INSERT [dbo].[tblUsers] ([userID], [name], [email], [password], [address], [roleID]) VALUES (N'truonglt', N'Bunni Reary', N'truongltse140903@gmail.com', N'truong123', N'35 Autumn Leaf Avenue', N'AD')
GO
ALTER TABLE [dbo].[tblOrders] ADD  DEFAULT (getdate()) FOR [dateBuy]
GO
ALTER TABLE [dbo].[tblProduct] ADD  CONSTRAINT [DF__tblPhone__status__2F10007B]  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[tblOrderDetails]  WITH CHECK ADD FOREIGN KEY([orderID])
REFERENCES [dbo].[tblOrders] ([orderID])
GO
ALTER TABLE [dbo].[tblOrderDetails]  WITH CHECK ADD  CONSTRAINT [FK__tblOrderD__phone__30F848ED] FOREIGN KEY([phoneID])
REFERENCES [dbo].[tblProduct] ([phoneID])
GO
ALTER TABLE [dbo].[tblOrderDetails] CHECK CONSTRAINT [FK__tblOrderD__phone__30F848ED]
GO
ALTER TABLE [dbo].[tblOrders]  WITH CHECK ADD FOREIGN KEY([userID])
REFERENCES [dbo].[tblUsers] ([userID])
GO
ALTER TABLE [dbo].[tblProduct]  WITH CHECK ADD  CONSTRAINT [FK__tblPhone__catego__32E0915F] FOREIGN KEY([categoryID])
REFERENCES [dbo].[tblCategory] ([categoryID])
GO
ALTER TABLE [dbo].[tblProduct] CHECK CONSTRAINT [FK__tblPhone__catego__32E0915F]
GO
ALTER TABLE [dbo].[tblUsers]  WITH CHECK ADD FOREIGN KEY([roleID])
REFERENCES [dbo].[tblRoles] ([roleID])
GO
USE [master]
GO
ALTER DATABASE [ASSC] SET  READ_WRITE 
GO
