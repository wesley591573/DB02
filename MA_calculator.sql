USE [ncu_database]
GO
/****** Object:  StoredProcedure [dbo].[MA_calculator]    Script Date: 2022/9/7 下午 04:34:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MA_calculator]
	@date date

AS
	SET NOCOUNT ON


	DECLARE @tem table (
		com varchar(10),
		ma real
	)


	insert into @tem
	select stock_data.stock_code, AVG(c) from stock_data
	cross apply(
		select stock_code from stock_list
	)T1
	where T1.stock_code = stock_data.stock_code and date in (select date from find_date(5, @date, 0, 1))
	group by stock_data.stock_code


	update stock_data
	set MA5 = ma
	from @tem as T1
	where date = @date and stock_code = com

	delete from @tem



	insert into @tem
	select stock_data.stock_code, AVG(c) from stock_data
	cross apply(
		select stock_code from stock_list
	)T1
	where T1.stock_code = stock_data.stock_code and date in (select date from find_date(10, @date, 0, 1))
	group by stock_data.stock_code


	update stock_data
	set MA10 = ma
	from @tem as T1
	where date = @date and stock_code = com

	delete from @tem





	insert into @tem
	select stock_data.stock_code, AVG(c) from stock_data
	cross apply(
		select stock_code from stock_list
	)T1
	where T1.stock_code = stock_data.stock_code and date in (select date from find_date(20, @date, 0, 1))
	group by stock_data.stock_code


	update stock_data
	set MA20 = ma
	from @tem as T1
	where date = @date and stock_code = com

	delete from @tem



	insert into @tem
	select stock_data.stock_code, AVG(c) from stock_data
	cross apply(
		select stock_code from stock_list
	)T1
	where T1.stock_code = stock_data.stock_code and date in (select date from find_date(60, @date, 0, 1))
	group by stock_data.stock_code


	update stock_data
	set MA60 = ma
	from @tem as T1
	where date = @date and stock_code = com

	delete from @tem


	insert into @tem
	select stock_data.stock_code, AVG(c) from stock_data
	cross apply(
		select stock_code from stock_list
	)T1
	where T1.stock_code = stock_data.stock_code and date in (select date from find_date(120, @date, 0, 1))
	group by stock_data.stock_code


	update stock_data
	set MA120 = ma
	from @tem as T1
	where date = @date and stock_code = com

	delete from @tem


	insert into @tem
	select stock_data.stock_code, AVG(c) from stock_data
	cross apply(
		select stock_code from stock_list
	)T1
	where T1.stock_code = stock_data.stock_code and date in (select date from find_date(240, @date, 0, 1))
	group by stock_data.stock_code


	update stock_data
	set MA240 = ma
	from @tem as T1
	where date = @date and stock_code = com

	delete from @tem


