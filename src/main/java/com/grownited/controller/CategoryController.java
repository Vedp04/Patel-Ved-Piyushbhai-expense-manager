package com.grownited.controller;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.grownited.entity.CategoryEntity;
import com.grownited.entity.SubCategoryEntity;
import com.grownited.entity.UserEntity;
import com.grownited.repository.CategoryRepository;
import com.grownited.repository.SubCategoryRepository;

import jakarta.servlet.http.HttpSession;

@Controller
public class CategoryController {

    @Autowired private CategoryRepository    categoryRepository;
    @Autowired private SubCategoryRepository subCategoryRepository;

    // ══════════════════════════════════════════════════════════════════════════
    // CATEGORY — ADD
    // ══════════════════════════════════════════════════════════════════════════

    @GetMapping("/addcategory")
    public String showAddCategoryForm(HttpSession session) {
        if (requireLogin(session) == null) return "redirect:/login";
        return "pages/category/AddCategory";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // CATEGORY — SAVE
    // ══════════════════════════════════════════════════════════════════════════

    @PostMapping("/savecategory")
    public String saveCategory(CategoryEntity category,
                               HttpSession session,
                               RedirectAttributes ra) {

        UserEntity user = requireLogin(session);
        if (user == null) return "redirect:/login";

        categoryRepository.save(category);
        ra.addFlashAttribute("success", "Category \"" + category.getCategoryName() + "\" created.");
        return "redirect:/listcategory";
    }

 
    @GetMapping("/listcategory")
    public String listCategories(
            @RequestParam(defaultValue = "0")            int    page,
            @RequestParam(defaultValue = "10")           int    size,
            @RequestParam(defaultValue = "")             String keyword,
            @RequestParam(defaultValue = "categoryName") String sortBy,
            @RequestParam(defaultValue = "asc")          String direction,
            HttpSession session, Model model) {
        if (requireLogin(session) == null) return "redirect:/login";

        Sort sort = "desc".equalsIgnoreCase(direction)
                ? Sort.by(sortBy).descending()
                : Sort.by(sortBy).ascending();
        Pageable pageable = PageRequest.of(page, size, sort);

        Page<CategoryEntity> categoryPage;
        if (keyword != null && !keyword.isBlank()) {
            categoryPage = categoryRepository.findByCategoryNameContainingIgnoreCase(keyword, pageable);
        } else {
            categoryPage = categoryRepository.findAll(pageable);
        }

        model.addAttribute("categoryPage", categoryPage);
        model.addAttribute("keyword",      keyword);
        model.addAttribute("sortBy",       sortBy);
        model.addAttribute("direction",    direction);
        model.addAttribute("activeMenu",   "category");
        return "pages/category/ListCategory";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // CATEGORY — EDIT
    // ══════════════════════════════════════════════════════════════════════════

    @GetMapping("/editcategory")
    public String showEditCategoryForm(@RequestParam Integer categoryId,
                                       HttpSession session,
                                       Model model) {

        if (requireLogin(session) == null) return "redirect:/login";

        CategoryEntity category = categoryRepository.findById(categoryId).orElse(null);
        if (category == null) return "redirect:/listcategory";

        model.addAttribute("category", category);
        return "pages/category/AddCategory";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // CATEGORY — UPDATE
    // ══════════════════════════════════════════════════════════════════════════

    @PostMapping("/updatecategory")
    public String updateCategory(CategoryEntity category,
                                 HttpSession session,
                                 RedirectAttributes ra) {

        if (requireLogin(session) == null) return "redirect:/login";

        categoryRepository.save(category);
        ra.addFlashAttribute("success", "Category updated.");
        return "redirect:/listcategory";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // CATEGORY — DELETE
    // ══════════════════════════════════════════════════════════════════════════

 
    @GetMapping("/deletecategory")
    public String deleteCategory(@RequestParam Integer categoryId,
                                 HttpSession session,
                                 RedirectAttributes ra) {

        if (requireLogin(session) == null) return "redirect:/login";

        if (!categoryRepository.existsById(categoryId)) {
            ra.addFlashAttribute("error", "Category not found.");
            return "redirect:/listcategory";
        }

        categoryRepository.deleteById(categoryId);
        ra.addFlashAttribute("success", "Category deleted.");
        return "redirect:/listcategory";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // SUB-CATEGORY — ADD
    // ══════════════════════════════════════════════════════════════════════════

    /**
     * Shows the Add Sub-Category form.
     * Must send the full category list so the user can pick a parent.
     */
    @GetMapping("/addsubcategory")
    public String showAddSubCategoryForm(HttpSession session, Model model) {
        if (requireLogin(session) == null) return "redirect:/login";

        model.addAttribute("categoryList", categoryRepository.findAll());
        return "pages/category/AddSubCategory";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // SUB-CATEGORY — SAVE
    // ══════════════════════════════════════════════════════════════════════════

    @PostMapping("/savesubcategory")
    public String saveSubCategory(SubCategoryEntity subCategory,
                                  HttpSession session,
                                  RedirectAttributes ra) {

        if (requireLogin(session) == null) return "redirect:/login";

        subCategoryRepository.save(subCategory);
        ra.addFlashAttribute("success",
                "Sub-Category \"" + subCategory.getSubCategoryName() + "\" created.");
        return "redirect:/listsubcategory";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // SUB-CATEGORY — LIST
    // ══════════════════════════════════════════════════════════════════════════

    /**
     * Lists all sub-categories with their parent category names.
     *
     * Data provided to JSP:
     * - subCategoryList → List<SubCategoryEntity>
     * - categoryMap     → Map<Integer, String>  (id → name for fast JSP lookup)
     */
    @GetMapping("/listsubcategory")
    public String listSubCategories(
            @RequestParam(defaultValue = "0")               int    page,
            @RequestParam(defaultValue = "10")              int    size,
            @RequestParam(defaultValue = "")                String keyword,
            @RequestParam(defaultValue = "subCategoryName") String sortBy,
            @RequestParam(defaultValue = "asc")             String direction,
            HttpSession session, Model model) {
        if (requireLogin(session) == null) return "redirect:/login";

        Sort sort = "desc".equalsIgnoreCase(direction)
                ? Sort.by(sortBy).descending()
                : Sort.by(sortBy).ascending();
        Pageable pageable = PageRequest.of(page, size, sort);

        Page<SubCategoryEntity> subCategoryPage;
        if (keyword != null && !keyword.isBlank()) {
            subCategoryPage = subCategoryRepository.findBySubCategoryNameContainingIgnoreCase(keyword, pageable);
        } else {
            subCategoryPage = subCategoryRepository.findAll(pageable);
        }

        List<CategoryEntity> categories = categoryRepository.findAll();

        // Build lookup map — avoids nested loops / extra queries in JSP
        Map<Integer, String> categoryMap = categories.stream()
                .collect(Collectors.toMap(
                        CategoryEntity::getCategoryId,
                        CategoryEntity::getCategoryName,
                        (a, b) -> a));

        model.addAttribute("subCategoryPage", subCategoryPage);
        model.addAttribute("categoryMap",     categoryMap);
        model.addAttribute("keyword",         keyword);
        model.addAttribute("sortBy",          sortBy);
        model.addAttribute("direction",       direction);
        model.addAttribute("activeMenu",      "subcategory");

        return "pages/category/ListSubCategory";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // SUB-CATEGORY — EDIT
    // ══════════════════════════════════════════════════════════════════════════

    @GetMapping("/editsubcategory")
    public String showEditSubCategoryForm(@RequestParam Integer subCategoryId,
                                          HttpSession session,
                                          Model model) {

        if (requireLogin(session) == null) return "redirect:/login";

        SubCategoryEntity subCategory = subCategoryRepository.findById(subCategoryId).orElse(null);
        if (subCategory == null) return "redirect:/listsubcategory";

        model.addAttribute("subCategory",  subCategory);
        model.addAttribute("categoryList", categoryRepository.findAll());

        return "pages/category/AddSubCategory";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // SUB-CATEGORY — UPDATE
    // ══════════════════════════════════════════════════════════════════════════

    @PostMapping("/updatesubcategory")
    public String updateSubCategory(SubCategoryEntity subCategory,
                                    HttpSession session,
                                    RedirectAttributes ra) {

        if (requireLogin(session) == null) return "redirect:/login";

        subCategoryRepository.save(subCategory);
        ra.addFlashAttribute("success", "Sub-Category updated.");
        return "redirect:/listsubcategory";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // SUB-CATEGORY — DELETE
    // ══════════════════════════════════════════════════════════════════════════

    @GetMapping("/deletesubcategory")
    public String deleteSubCategory(@RequestParam Integer subCategoryId,
                                    HttpSession session,
                                    RedirectAttributes ra) {

        if (requireLogin(session) == null) return "redirect:/login";

        if (!subCategoryRepository.existsById(subCategoryId)) {
            ra.addFlashAttribute("error", "Sub-Category not found.");
            return "redirect:/listsubcategory";
        }

        subCategoryRepository.deleteById(subCategoryId);
        ra.addFlashAttribute("success", "Sub-Category deleted.");
        return "redirect:/listsubcategory";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // PRIVATE HELPER
    // ══════════════════════════════════════════════════════════════════════════

    private UserEntity requireLogin(HttpSession session) {
        return (UserEntity) session.getAttribute("user");
    }
}
