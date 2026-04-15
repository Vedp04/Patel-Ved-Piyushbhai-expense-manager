package com.arth.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.arth.dto.ExpenseDto;
import com.arth.entity.AccountEntity;
import com.arth.entity.CategoryEntity;
import com.arth.entity.ExpenseEntity;
import com.arth.entity.StatusEntity;
import com.arth.entity.SubcategoryEntity;
import com.arth.entity.UserEntity;
import com.arth.entity.VendorEntity;
import com.arth.repository.AccountRepository;
import com.arth.repository.CategoryRepository;
import com.arth.repository.ExpenseRepository;
import com.arth.repository.StatusRepository;
import com.arth.repository.SubcategoryRepository;
import com.arth.repository.UserRepository;
import com.arth.repository.VendorRepository;

@Controller
public class ExpenseController {
	@Autowired
	ExpenseRepository expenseRepo;
	@Autowired
	CategoryRepository categoryRepo;
	@Autowired
	SubcategoryRepository subcategoryRepo;
	@Autowired
	VendorRepository vendorRepo;
	@Autowired
	AccountRepository accountRepo;
	@Autowired
	StatusRepository statusRepo;
	@Autowired
	UserRepository userRepo;
	
	@GetMapping("/newexpense")
	public String newExpense(Model model) {
		List<CategoryEntity> categoryList = categoryRepo.findAll();
		List<SubcategoryEntity> subcategoryList = subcategoryRepo.findAll();
		List<VendorEntity> vendorList = vendorRepo.findAll();
		List<AccountEntity> accountList = accountRepo.findAll();
		List<StatusEntity> statusList = statusRepo.findAll();
		List<UserEntity> userList = userRepo.findAll();
		model.addAttribute("categoryList", categoryList);
		model.addAttribute("subcategoryList", subcategoryList);
		model.addAttribute("vendorList", vendorList);
		model.addAttribute("accountList", accountList);
		model.addAttribute("statusList", statusList);
		model.addAttribute("userList", userList);
		return "NewExpense";
	}
	
	@PostMapping("/saveexpense")
	public String saveExpense(ExpenseEntity expense) {
		expenseRepo.save(expense);
		return "redirect:/listexpense";
	}
	
	@GetMapping("/listexpense")
	public String listExpense(Model model) {
		List<ExpenseDto> expenseList = expenseRepo.getAllExpenses();
		model.addAttribute("expenseList", expenseList);
		return "ListExpense";
	}
	
	@GetMapping("/deleteexpense")
	public String deleteExpense(@RequestParam Integer expenseId) {
		expenseRepo.deleteById(expenseId);
		return "redirect:/listexpense";
	}
}
