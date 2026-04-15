package com.arth.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.arth.entity.CategoryEntity;
import com.arth.repository.CategoryRepository;

@Controller
public class CategoryController {
	
	@Autowired
	CategoryRepository categoryRepo;
	
	@GetMapping("/newcategory")
	public String newCategory() {
		return "NewCategory";
	}
	
	@PostMapping("/savecategory")
	public String saveCategory(CategoryEntity category) {
		categoryRepo.save(category);
		return "redirect:/listcategory";
	}
	
	@GetMapping("/listcategory")
	public String listCategory(Model model) {
		List<CategoryEntity> categoryList = categoryRepo.findAll();
		model.addAttribute("categoryList", categoryList);
		return "ListCategory";
	}
	
	@GetMapping("/deletecategory")
	public String deleteCategory(@RequestParam Integer categoryId) {
		categoryRepo.deleteById(categoryId);
		return "redirect:/listcategory";
	}
}
