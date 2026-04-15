package com.arth.dto;

public interface ExpenseDto {

	
//	amount;
//	description;
//	date;
//	first_name;
//	status_name;
//	title;
//	vendor_name;
//	category_name;
//	subcategory_name; 
	Integer getExpenseId();
	Integer getAmount();
	String getDescription();
	String getDate();
	String getFirstName();//firstName
	String getStatusName();
	String getTitle();
	String getVendorName();
	String getCategoryName();
	String getSubCategoryName(); 
	String getExpenseTitle();
	
}
