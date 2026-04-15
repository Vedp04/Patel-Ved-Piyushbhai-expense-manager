package com.arth.util;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class RnD {

	public static void main(String[] args) {
		
		
		
		LocalDate l = LocalDate.now(); 
		System.out.println(l.getMonth().getValue());
		System.out.println(l.getYear());
		
		String date = l.toString(); 
		System.out.println(date);
		
		LocalDateTime lt = LocalDateTime.now();
		String dateAndTime = l+"T"+lt.getHour()+":"+lt.getMinute()+":"+lt.getSecond();
		System.out.println(dateAndTime);
		


	}
	
}
