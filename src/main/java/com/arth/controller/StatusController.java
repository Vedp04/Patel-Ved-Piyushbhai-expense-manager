package com.arth.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.arth.entity.StatusEntity;
import com.arth.repository.StatusRepository;

@Controller
public class StatusController {
	@Autowired
	StatusRepository statusRepo;
	
	@GetMapping("/newstatus")
	public String newStatus() {
		return "NewStatus";
	}
	
	@PostMapping("/savestatus")
	public String saveStatus(StatusEntity status) {
		statusRepo.save(status);
		return "redirect:/liststatus";
	}
	
	@GetMapping("/liststatus")
	public String listStatus(Model model) {
		List<StatusEntity> statusList = statusRepo.findAll();
		model.addAttribute("statusList", statusList);
		return "ListStatus";
	}
	
	@GetMapping("/deletestatus")
	public String deleteStatus(@RequestParam Integer statusId) {
		statusRepo.deleteById(statusId);
		return "redirect:/liststatus";
	}
}
