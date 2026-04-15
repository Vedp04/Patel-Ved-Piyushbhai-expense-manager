package com.arth.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.arth.entity.AccountEntity;
import com.arth.entity.IncomeEntity;
import com.arth.entity.StatusEntity;
import com.arth.entity.UserEntity;
import com.arth.repository.AccountRepository;
import com.arth.repository.IncomeRepository;
import com.arth.repository.StatusRepository;
import com.arth.repository.UserRepository;

@Controller
public class IncomeController {
	@Autowired
	IncomeRepository incomeRepo;
	@Autowired
	AccountRepository accountRepo;
	@Autowired
	StatusRepository statusRepo;
	@Autowired
	UserRepository userRepo;

	@GetMapping("/newincome")
	public String newIncome(Model model) {
		List<AccountEntity> accountList = accountRepo.findAll();
		List<StatusEntity> statusList = statusRepo.findAll();
		List<UserEntity> userList = userRepo.findAll();
		model.addAttribute("accountList", accountList);
		model.addAttribute("statusList", statusList);
		model.addAttribute("userList", userList);
		return "NewIncome";
	}

	@PostMapping("/saveincome")
	public String saveIncome(IncomeEntity income) {

		// accountId
		// income

		AccountEntity account = accountRepo.findById(income.getAccountId()).get();
		double newAmount = account.getAmount() + income.getAmount(); 
		account.setAmount(newAmount);
		accountRepo.save(account); 
		incomeRepo.save(income);
		return "redirect:/listincome";
	}

	@GetMapping("/listincome")
	public String listIncome(Model model) {
		List<IncomeEntity> incomeList = incomeRepo.findAll();
		model.addAttribute("incomeList", incomeList);
		return "ListIncome";
	}

	@GetMapping("/deleteincome")
	public String deleteIncome(@RequestParam Integer incomeId) {
		incomeRepo.deleteById(incomeId);
		return "redirect:/listincome";
	}
}
