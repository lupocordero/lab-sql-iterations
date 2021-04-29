select staff_id as store, sum(amount) as total_business from sakila.payment group by store;

#Convert the previous query into a stored procedure.
drop procedure if exists sum_store;

delimiter ++
create procedure sum_store()
begin
  select staff_id as store, sum(amount) as total_business from sakila.payment group by store;
end ++
delimiter ;

call sum_store;

#Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.
drop procedure if exists total_sales;

delimiter ++
create procedure total_sales (in param varchar(20))
begin
	select staff_id as store, sum(amount) as total_sales from sakila.payment 
    where staff_id COLLATE utf8mb4_general_ci = param
	group by store;
end ++
delimiter ;

call total_sales(1);

#Update the previous query. 
#Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store). 
#Call the stored procedure and print the results.

drop procedure if exists total_sales2;

delimiter ++
create procedure total_sales2 (in param tinyint)
begin
	declare total_sales_value float default 0.0;
		select sum(p.amount) as total_sales into total_sales_value
        from sakila.payment as p
        join sakila.staff as b on b.staff_id = p.staff_id
		group by b.store_id
		having b.store_id = param;
	select total_sales_value;
end ++
delimiter ;

call total_sales2(1);

#In the previous query, add another variable flag. 
#If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. 
#Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.

drop procedure if exists total_sales_3;

delimiter ++
create procedure total_sales_3 (in param tinyint, out total_sales_value float, out flagy varchar(20))
begin
	-- declare total_sales_value float default 0.0;
    declare flag varchar(20) default "";
		select sum(p.amount) as total_sales into total_sales_value
        from sakila.payment as p
        join sakila.staff as b on b.staff_id = p.staff_id
		group by b.store_id
		having b.store_id = param;
	select total_sales_value;

  if total_sales_value > 30000 then
    set flag = 'Green Flag';
  else
    set flag = 'Red Flag';
  end if;
  
  select flag into flagy;
end ++
DELIMITER ;

call total_sales_3(1, @average, @flag);
select @average, @flag;