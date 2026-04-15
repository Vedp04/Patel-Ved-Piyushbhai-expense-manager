package com.arth.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.arth.dto.SubCategoryDto;
import com.arth.entity.CategoryEntity;
import com.arth.entity.SubcategoryEntity;
import com.arth.repository.CategoryRepository;
import com.arth.repository.SubcategoryRepository;

@Controller
public class SubcategoryController {

	@Autowired
	SubcategoryRepository subcategoryRepo;
	@Autowired
	CategoryRepository categoryRepo;
	
	@GetMapping("/newsubcategory")
	public String newSubcategory(Model model) {
		List<CategoryEntity> categoryList = categoryRepo.findAll();
		model.addAttribute("categoryList", categoryList);
		return "NewSubcategory";
	}
	
	@PostMapping("/savesubcategory")
	public String saveSubcategory(SubcategoryEntity subcategory) {
		subcategoryRepo.save(subcategory);
		return "redirect:/listsubcategory";
	}
	
	@GetMapping("/listsubcategory")
	public String listSubcategory(Model model) {
		List<SubCategoryDto> subcategoryList = subcategoryRepo.getAllSub();
		model.addAttribute("subcategoryList", subcategoryList);
		for(SubCategoryDto s:subcategoryList) {
			System.out.println(s);
			System.out.println(s.getCategoryName());
		}
		
		return "ListSubcategory";
	}
	
	@GetMapping("/deletesubcategory")
	public String deleteSubcategory(@RequestParam Integer subcategoryId) {
		subcategoryRepo.deleteById(subcategoryId);
		return "redirect:/listsubcategory";
	}
}
