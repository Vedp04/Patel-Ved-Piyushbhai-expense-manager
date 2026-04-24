package com.grownited.controller;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.Objects;
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

import com.grownited.entity.*;
import com.grownited.repository.*;

import jakarta.servlet.http.HttpSession;

/**
 * Full CRUD for Income transactions.
 *
 * Routes:
 *   GET  /addincome      → show add form
 *   POST /saveincome     → persist new income
 *   GET  /listincome     → list (user-scoped)
 *   GET  /editincome     → show edit form
 *   POST /updateincome   → persist changes
 *   GET  /deleteincome   → delete and redirect
 */
@Controller
public class IncomeController {

    // ── Dependencies ──────────────────────────────────────────────────────────

    @Autowired private IncomeRepository  incomeRepository;
    @Autowired private AccountRepository accountRepository;
    @Autowired private StatusRepository  statusRepository;

    // ══════════════════════════════════════════════════════════════════════════
    // ADD INCOME — show form
    // ══════════════════════════════════════════════════════════════════════════

    @GetMapping("/addincome")
    public String showAddIncomeForm(HttpSession session, Model model) {
        UserEntity user = requireLogin(session);
        if (user == null) return "redirect:/login";

        populateIncomeFormModel(model, user);
        model.addAttribute("todayDate", LocalDate.now().toString());
        return "pages/income/AddIncome";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // SAVE INCOME — POST
    // ══════════════════════════════════════════════════════════════════════════

    @PostMapping("/saveincome")
    public String saveIncome(IncomeEntity income,
                             HttpSession session,
                             RedirectAttributes ra) {

        UserEntity user = requireLogin(session);
        if (user == null) return "redirect:/login";

        income.setUserId(user.getUserId());
        incomeRepository.save(income);

        ra.addFlashAttribute("success", "Income saved successfully.");
        return "redirect:/listincome";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // LIST INCOME
    // ══════════════════════════════════════════════════════════════════════════

    /**
     * Lists income records for the logged-in user.
     * Admin sees all records.
     *
     * Data provided to JSP:
     * - incomeList         → List<IncomeEntity>
     * - accountMap         → Map<Integer, String>
     * - statusMap          → Map<Integer, String>
     * - totalIncomeAmount  → BigDecimal
     */
    @GetMapping("/listincome")
    public String listIncome(
            @RequestParam(defaultValue = "0")          int    page,
            @RequestParam(defaultValue = "10")         int    size,
            @RequestParam(defaultValue = "")           String keyword,
            @RequestParam(defaultValue = "incomeDate") String sortBy,
            @RequestParam(defaultValue = "desc")       String direction,
            HttpSession session, Model model) {
        UserEntity user = requireLogin(session);
        if (user == null) return "redirect:/login";

        boolean isAdmin = "Admin".equals(user.getRole());

        Sort sort = "desc".equalsIgnoreCase(direction)
                ? Sort.by(sortBy).descending()
                : Sort.by(sortBy).ascending();
        Pageable pageable = PageRequest.of(page, size, sort);

        Page<IncomeEntity> incomePage;
        if (keyword != null && !keyword.isBlank()) {
            incomePage = isAdmin
                    ? incomeRepository.findByIncomeSourceContainingIgnoreCase(keyword, pageable)
                    : incomeRepository.findByUserIdAndIncomeSourceContainingIgnoreCase(user.getUserId(), keyword, pageable);
        } else {
            incomePage = isAdmin
                    ? incomeRepository.findAll(pageable)
                    : incomeRepository.findByUserId(user.getUserId(), pageable);
        }

        List<AccountEntity> accounts = isAdmin
                ? accountRepository.findAll()
                : accountRepository.findByUserId(user.getUserId());

        List<StatusEntity> statuses = statusRepository.findAll();

        // ── O(1) lookup maps for JSP rendering ───────────────────────────────
        Map<Integer, String> accountMap = accounts.stream()
                .collect(Collectors.toMap(
                        AccountEntity::getAccountId,
                        AccountEntity::getAccountName,
                        (a, b) -> a));

        Map<Integer, String> statusMap = statuses.stream()
                .collect(Collectors.toMap(
                        StatusEntity::getStatusId,
                        StatusEntity::getStatusName,
                        (a, b) -> a));

        // ── Grand total (all records, not filtered) ────────────────────────────
        BigDecimal totalIncomeAmount = isAdmin
                ? java.util.Optional.ofNullable(incomeRepository.sumAll()).orElse(BigDecimal.ZERO)
                : java.util.Optional.ofNullable(incomeRepository.sumByUserId(user.getUserId())).orElse(BigDecimal.ZERO);

        model.addAttribute("incomePage",        incomePage);
        model.addAttribute("accountMap",        accountMap);
        model.addAttribute("statusMap",         statusMap);
        model.addAttribute("totalIncomeAmount", totalIncomeAmount);
        model.addAttribute("keyword",           keyword);
        model.addAttribute("sortBy",            sortBy);
        model.addAttribute("direction",         direction);
        model.addAttribute("activeMenu",        "income");

        return "pages/income/ListIncome";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // EDIT INCOME — show pre-populated form
    // ══════════════════════════════════════════════════════════════════════════

    @GetMapping("/editincome")
    public String showEditIncomeForm(@RequestParam Integer incomeId,
                                     HttpSession session,
                                     Model model) {

        UserEntity user = requireLogin(session);
        if (user == null) return "redirect:/login";

        IncomeEntity income = incomeRepository.findById(incomeId).orElse(null);
        if (income == null) return "redirect:/listincome";

        // Ownership guard
        if (!"Admin".equals(user.getRole()) && !income.getUserId().equals(user.getUserId())) {
            return "redirect:/listincome";
        }

        model.addAttribute("income",    income);
        model.addAttribute("todayDate", LocalDate.now().toString());
        populateIncomeFormModel(model, user);

        return "pages/income/AddIncome";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // UPDATE INCOME — POST
    // ══════════════════════════════════════════════════════════════════════════

    @PostMapping("/updateincome")
    public String updateIncome(IncomeEntity income,
                               HttpSession session,
                               RedirectAttributes ra) {

        UserEntity user = requireLogin(session);
        if (user == null) return "redirect:/login";

        income.setUserId(user.getUserId());
        incomeRepository.save(income);

        ra.addFlashAttribute("success", "Income updated successfully.");
        return "redirect:/listincome";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // DELETE INCOME
    // ══════════════════════════════════════════════════════════════════════════

    @GetMapping("/deleteincome")
    public String deleteIncome(@RequestParam Integer incomeId,
                               HttpSession session,
                               RedirectAttributes ra) {

        UserEntity user = requireLogin(session);
        if (user == null) return "redirect:/login";

        incomeRepository.findById(incomeId).ifPresent(income -> {
            if ("Admin".equals(user.getRole()) || income.getUserId().equals(user.getUserId())) {
                incomeRepository.deleteById(incomeId);
                ra.addFlashAttribute("success", "Income record deleted.");
            } else {
                ra.addFlashAttribute("error", "You are not authorised to delete this record.");
            }
        });

        return "redirect:/listincome";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // PRIVATE HELPERS
    // ══════════════════════════════════════════════════════════════════════════

    private UserEntity requireLogin(HttpSession session) {
        return (UserEntity) session.getAttribute("user");
    }

    /**
     * Populates drop-down data for the Add / Edit income form.
     * Accounts are user-scoped; statuses are shared.
     */
    private void populateIncomeFormModel(Model model, UserEntity user) {
        boolean isAdmin = "Admin".equals(user.getRole());

        List<AccountEntity> accounts = isAdmin
                ? accountRepository.findAll()
                : accountRepository.findByUserId(user.getUserId());

        model.addAttribute("accountList", accounts);
        model.addAttribute("statusList",  statusRepository.findAll());
    }
}
