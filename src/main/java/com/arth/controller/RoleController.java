package com.arth.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.arth.entity.RoleEntity;
import com.arth.repository.RoleRepository;

@Controller
public class RoleController {
	
	@Autowired
	RoleRepository roleRepo;
	
	@GetMapping("/newrole")
	public String newrole() {
		return "NewRole";
	}
	
	@PostMapping("/saverole")
	public String saverole(RoleEntity role) {
		System.out.println("Role Name: " + role.getRoleName());
		roleRepo.save(role);
		return "redirect:/listrole";
	}
	
	@GetMapping("/listrole")
	public String listRole(Model model) {
		List<RoleEntity> roleList = roleRepo.findAll();
		model.addAttribute("roleList", roleList);
		return "ListRole";
	}
	
	@GetMapping("/deleterole")
	public String deleteRole(@RequestParam Integer roleId) {
		roleRepo.deleteById(roleId);
		return "redirect:/listrole";
	}
}
