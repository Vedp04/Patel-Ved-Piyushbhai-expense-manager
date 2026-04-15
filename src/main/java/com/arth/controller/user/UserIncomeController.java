package com.arth.controller.user;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.arth.entity.AccountEntity;
import com.arth.entity.IncomeEntity;
import com.arth.entity.UserEntity;
import com.arth.repository.AccountRepository;
import com.arth.repository.IncomeRepository;

import jakarta.servlet.http.HttpSession;

@Controller
public class UserIncomeController {

	@Autowired
	IncomeRepository incomeRepo;

	@Autowired
	AccountRepository accountRepo; 
	
	@GetMapping("/userlistincome")
	public String userListIncome(Model model, HttpSession session) {

		UserEntity user = (UserEntity) session.getAttribute("user");

		List<IncomeEntity> income = incomeRepo.findByUserId(user.getUserId());
		model.addAttribute("income",income);
		
		return "UserListIncome";
	}
	
	@GetMapping("/usernewincome")
	public String userNewIncome(Model model, HttpSession session)
	{
		UserEntity user = (UserEntity) session.getAttribute("user");

		List<AccountEntity> accounts =  accountRepo.findByUserId(user.getUserId());
		model.addAttribute("accounts",accounts);
		
		
		return "UserNewIncome";
	}
	
	@PostMapping("/usersaveincome")
	public String userSaveIncome(IncomeEntity incomeEntity,HttpSession session) {

		UserEntity user = (UserEntity) session.getAttribute("user");
		incomeEntity.setUserId(user.getUserId());
		incomeRepo.save(incomeEntity); 
		
		AccountEntity account = accountRepo.findById(incomeEntity.getAccountId()).get();
		double newAmount = account.getAmount() + incomeEntity.getAmount(); 
		account.setAmount(newAmount);
		accountRepo.save(account); 
		return "redirect:/userlistincome";
	}
	
}
