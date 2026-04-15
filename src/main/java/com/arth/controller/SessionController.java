package com.arth.controller;

import java.time.LocalDate;

//import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
//import org.springframework.web.bind.annotation.RequestParam;

import com.arth.entity.UserEntity;
import com.arth.repository.UserRepository;
import com.arth.service.MailerService;

import jakarta.servlet.http.HttpSession;

@Controller
public class SessionController {
	
	@Autowired
	UserRepository userRepo;
	@Autowired
	BCryptPasswordEncoder passwordEncoder;
	
	@Autowired
	MailerService mailerService;

	@GetMapping("/")
	public String home() {
		return "redirect:/login";
	}
	
	@GetMapping("/register")
	public String register() {
		return "Register";
	}
	
	@GetMapping("/login")
	public String login() {
		return "Login";
	}
	
	@PostMapping("/authenticateuser")
	public String authenticateUser(UserEntity user, Model model, HttpSession session) {
		UserEntity loggedinUser = userRepo.findByEmailAddress(user.getEmailAddress());
		if(loggedinUser == null) {
			model.addAttribute("error", "Invalid Credentials");
			return "Login";
		} else {
			session.setAttribute("user", loggedinUser);
			boolean answer = passwordEncoder.matches(user.getPassword(), loggedinUser.getPassword());
			if(answer == false) {
				model.addAttribute("error", "Invalid Credentials");
				return "Login";
			}
			else if(loggedinUser.getRoleId() == null) {
				model.addAttribute("error", "Something went wrong!");
			} else if(loggedinUser.getRoleId() == 1) {
				return "redirect:/admindashboard";
			} else if(loggedinUser.getRoleId() == 2) {
				return "redirect:/userdashboard";
			}
		}
		return "Login";
	}
	
	@PostMapping("/saveperson")
	public String saveperson(UserEntity user, Model model) {
		if(! user.getPassword().equals(user.getConfirmPassword())) {
			model.addAttribute("passwordError", "Password and Confirm Password must be same.");
			return "Register";
		}
//		if(userRepo.findByEmailAddress(user.getEmailAddress())==null) {
			user.setRoleId(2);
			user.setOtp(-1);
			
			LocalDate today = LocalDate.now();
			user.setCreatedAt(today.toString());
			
			String rawPassword = user.getPassword();
			String encodedPassword = passwordEncoder.encode(rawPassword);
			user.setPassword(encodedPassword);
			userRepo.save(user);
//			mailerService.sendMailForWelcome(user.getEmailAddress(), user.getFirstName());
			return "redirect:/login";
//		} else {
//			model.addAttribute("error", "Email already exists.");
//			return "Register";
//		}
		
	}
	
	@GetMapping("/forgetpassword")
	public String forgetPassaword() {
		return "ForgetPassword";
	}
	
	@PostMapping("/sendotp")
	public String sendOTP(UserEntity user) {
		UserEntity dbUser = userRepo.findByEmailAddress(user.getEmailAddress());
		if(dbUser!=null) {
			int otp = (int)(Math.random()*1000000);
			System.out.println("OTP: " + otp);
			mailerService.sendMailForOTP(user.getEmailAddress(), otp);
			dbUser.setOtp(otp);
			userRepo.save(user);
		} 
		return "UpdatePassword";
	}
	
	@PostMapping("/updatepassword")
	public String updatePassword(UserEntity user, Model model) {
		if(!user.getPassword().equals(user.getConfirmPassword())) {
			model.addAttribute("passwordError", "Password and Confirm Password must be same.");
			return "UpdatePassword";
		} else {
			UserEntity dbUser = userRepo.findByEmailAddress(user.getEmailAddress());
			if(dbUser==null || dbUser.getOtp()==-1 || dbUser.getOtp().intValue()!=user.getOtp().intValue()){
				model.addAttribute("error", "Invalid OTP or Email Address.");
			} else {
				String rawPassword = user.getPassword();
				String encodedPassword = passwordEncoder.encode(rawPassword);
				dbUser.setPassword(encodedPassword);
				dbUser.setOtp(-1);
				userRepo.save(dbUser);
				model.addAttribute("msg", "Password updated successfully.");
			}
		}
		
		return "Login";
	}
	
	@GetMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/login";
	}

//	@GetMapping("/listuser")
//	public String listUser(Model model) {
//		List<UserEntity> userList = userRepo.findAll();
//		model.addAttribute("userList", userList);
//		return "ListUser";
//	}
	
//	@GetMapping("/deleteuser")
//	public String deleteUser(@RequestParam Integer userId) {
//		userRepo.deleteById(userId);
//		return "redirect:/listuser";
//	}
	
}
