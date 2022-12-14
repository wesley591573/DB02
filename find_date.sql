USE [ncu_database]
GO
/****** Object:  UserDefinedFunction [dbo].[find_date]    Script Date: 2022/9/7 下午 08:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[find_date](@NumberOfDay int, @Date date, @Today int, @Forward int)
RETURNS @record TABLE
(
	date date NOT NULL,
	day_of_stock int NOT NULL,
	other nvarchar(255)
)
AS
BEGIN
	DECLARE @remaining_day int;
	DECLARE @current_day int;


	SELECT @current_day = day_of_stock FROM [dbo].[calendar] WHERE date = @Date AND day_of_stock != -1;
	if(@current_day is NULL) RETURN

	IF(@Today = 1)
		SET @NumberOfDay = @NumberOfDay - 1;


	IF(@Forward = 1)
		SET @remaining_day = @current_day + @NumberOfDay;
	ELSE
		SET @remaining_day = @current_day - @NumberOfDay;


	


	/*
		current_day = day_of_stock
		有可能會跨年分
	*/

	/*
		Forward 跨年分
		Forward 沒跨年分
		Backward 沒跨年分
	*/

	IF(@remaining_day > 0)
		BEGIN
			/* Forward */
			IF(@remaining_day > @current_day)
				BEGIN
					IF(@Today = 1)
						BEGIN
							INSERT @record
							SELECT * FROM [dbo].[calendar] WHERE day_of_stock BETWEEN @current_day AND @remaining_day AND year(date) = year(@Date);

						END
					ELSE
						BEGIN
							INSERT @record
							SELECT * FROM [dbo].[calendar] WHERE day_of_stock BETWEEN @current_day + 1 AND @remaining_day AND year(date) = year(@Date);

						END


					DECLARE cur CURSOR LOCAL for
					SELECT year, total_day FROM [dbo].[year_calendar] order by year ASC
					open cur

					DECLARE @current_year INT
					DECLARE @current_total_day INT

					FETCH next from cur into @current_year, @current_total_day
				

					WHILE @@FETCH_STATUS = 0 BEGIN
						SET @remaining_day = @remaining_day - @current_total_day;

						IF @remaining_day > 0 
							BEGIN
								INSERT @record
								SELECT * FROM [dbo].[calendar] WHERE day_of_stock BETWEEN 0 AND @remaining_day AND year(date) = @current_year + 1;
							END
						ELSE
							BREAK;
						FETCH next from cur into @current_year, @current_total_day
					END

				END

			/* Backward */
			ELSE
				BEGIN
					IF(@Today = 1)
						BEGIN
							INSERT @record
							SELECT * FROM [dbo].[calendar] WHERE day_of_stock BETWEEN @remaining_day AND @current_day AND year(date) = year(@Date);

						END
					ELSE
						BEGIN
							INSERT @record
							SELECT * FROM [dbo].[calendar] WHERE day_of_stock BETWEEN @remaining_day AND @current_day - 1 AND year(date) = year(@Date);
						END

				END


		END

	/*
		必定是backward，而且跨年分
	*/

	ELSE 
		BEGIN
			IF(@Today = 1)
				BEGIN
					INSERT @record
					SELECT * FROM [dbo].[calendar] WHERE day_of_stock BETWEEN 0 AND @current_day AND year(date) = year(@Date);
				END
			ELSE
				BEGIN
					INSERT @record
					SELECT * FROM [dbo].[calendar] WHERE day_of_stock BETWEEN 0 AND @current_day - 1 AND year(date) = year(@Date);
				END


			DECLARE cur CURSOR LOCAL for
			SELECT year, total_day FROM [dbo].[year_calendar] order by year DESC
			open cur


			FETCH next from cur into @current_year, @current_total_day
			FETCH next from cur into @current_year, @current_total_day

			WHILE @@FETCH_STATUS = 0 BEGIN
				SET @remaining_day = @remaining_day + @current_total_day;

				IF @remaining_day > 0 
					BEGIN
						INSERT @record
						SELECT * FROM [dbo].[calendar] WHERE day_of_stock BETWEEN @remaining_day AND @current_total_day AND year(date) = @current_year ;
						BREAK
					END
				ELSE
					INSERT @record
					SELECT * FROM [dbo].[calendar] WHERE day_of_stock BETWEEN 0 AND @current_total_day AND year(date) = @current_year;
				FETCH next from cur into @current_year, @current_total_day
			END
		END


	RETURN

END;
