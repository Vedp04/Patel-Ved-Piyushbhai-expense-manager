package com.grownited.controller;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.grownited.entity.UserEntity;
import com.grownited.repository.*;

import jakarta.servlet.http.HttpSession;

@Controller
public class AdminController {

    // ── Dependencies ──────────────────────────────────────────────────────────

    @Autowired private UserRepository        userRepository;
    @Autowired private VendorRepository      vendorRepository;
    @Autowired private CategoryRepository    categoryRepository;
    @Autowired private SubCategoryRepository subCategoryRepository;

    @GetMapping("/admin-dashboard")
    public String adminDashboard(HttpSession session, Model model) {

        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        if (!"Admin".equals(user.getRole())) return "redirect:/customer-dashboard";

        // ── Platform-wide counts ──────────────────────────────────────────────
        long totalUsers         = userRepository.count();
        long activeUsers        = userRepository.countByActiveTrue();
        long totalVendors       = vendorRepository.count();
        long totalCategories    = categoryRepository.count();
        long totalSubCategories = subCategoryRepository.count();

        // ── Recent 7 users (newest first)
        List<UserEntity> userList = userRepository.findTop7ByOrderByUserIdDesc();

        // ── User-growth chart — last 7 days
        // Build a list of the last 7 calendar days in ascending order.
        List<LocalDate> last7DatesRaw = IntStream.rangeClosed(0, 6)
                .mapToObj(i -> LocalDate.now().minusDays(6 - i))
                .collect(Collectors.toList());

        // Format as ISO strings for the JSTL / Chart.js labels
        List<String> last7Days = last7DatesRaw.stream()
                .map(LocalDate::toString)
                .collect(Collectors.toList());

        // Count users registered on each specific date
        List<Long> userGrowth = last7DatesRaw.stream()
                .map(userRepository::countByCreatAtDate)
                .collect(Collectors.toList());

        // ── Bind model 
        model.addAttribute("totalUsers",         totalUsers);
        model.addAttribute("activeUsers",        activeUsers);
        model.addAttribute("totalVendors",       totalVendors);
        model.addAttribute("totalCategories",    totalCategories);
        model.addAttribute("totalSubCategories", totalSubCategories);
        model.addAttribute("userList",           userList);
        model.addAttribute("last7Days",          last7Days);
        model.addAttribute("userGrowth",         userGrowth);

        return "pages/dashboard/AdminDashboard";
    }


    @GetMapping("/admin/transactions")
    public String adminTransactions(HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        if (!"Admin".equals(user.getRole())) return "redirect:/customer-dashboard";
        return "redirect:/listexpense";
    }
}
