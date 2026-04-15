package com.arth.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.arth.repository.ExpenseRepository;

@Controller
public class AdminController {

	@Autowired
	ExpenseRepository expenseRepository;

	@GetMapping("/admindashboard")
	public String adminDashboard(Model model) {

		List<Integer[]> exp = expenseRepository.getExpenseSumByMonth();

		String data = "";

		// 0:expense amount
		// 1: month number
		HashMap<String, Integer> map = new HashMap<>();
		for(int i=1;i<=12;i++) {
			map.put(i+"", 0); //1:0 ,2:0 , 3:0 
		}
		
		
		for (Integer[] e : exp) {
			map.put(e[1]+"",e[0]);
			data = data + e[0] + ",";
		}
		System.out.println(data);
		System.out.println(map.get("2"));
		model.addAttribute("datamap",map);
		return "AdminDashboard";
	}
}
