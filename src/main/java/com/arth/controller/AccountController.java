package com.arth.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.arth.entity.AccountEntity;
import com.arth.entity.UserEntity;
import com.arth.repository.AccountRepository;
import com.arth.repository.UserRepository;

@Controller
public class AccountController {

	@Autowired
	AccountRepository accountRepo;
	@Autowired
	UserRepository userRepo;
	
	@GetMapping("/newaccount")
	public String newAccount(Model model) {
		List<UserEntity> userList = userRepo.findAll();
		model.addAttribute("userList", userList);
		return "NewAccount";
	}
	
	@PostMapping("/saveaccount")
	public String saveAccount(AccountEntity account) {
		accountRepo.save(account);
		return "redirect:/listaccount";
	}
	
	@GetMapping("/listaccount")
	public String listAccount(Model model) {
		List<AccountEntity> accountList = accountRepo.findAll();
		model.addAttribute("accountList", accountList);
		return "ListAccount";
	}
	
	@GetMapping("/deleteaccount")
	public String deleteAccount(@RequestParam Integer accountId) {
		accountRepo.deleteById(accountId);
		return "redirect:/listaccount";
	}
}
