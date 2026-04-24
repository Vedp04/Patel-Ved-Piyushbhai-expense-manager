package com.grownited.controller;

import java.math.BigDecimal;
import java.time.LocalDate;
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

import com.grownited.entity.*;
import com.grownited.repository.*;

import jakarta.servlet.http.HttpSession;

/**
 * Full CRUD for Expense transactions.
 *
 * Routes:
 *   GET  /addexpense           → show add form
 *   POST /saveexpense          → persist new expense
 *   GET  /listexpense          → paginated list (user-scoped)
 *   GET  /editexpense          → show edit form pre-populated
 *   POST /updateexpense        → persist changes
 *   GET  /deleteexpense        → delete and redirect
 *
 * Security:
 *   - Every handler validates session; redirects to /login if absent.
 *   - Customers see only their own expenses; Admin sees all.
 */
@Controller
public class ExpenseController {

    // ── Dependencies ──────────────────────────────────────────────────────────

    @Autowired private ExpenseRepository     expenseRepository;
    @Autowired private CategoryRepository    categoryRepository;
    @Autowired private SubCategoryRepository subCategoryRepository;
    @Autowired private VendorRepository      vendorRepository;
    @Autowired private AccountRepository     accountRepository;
    @Autowired private StatusRepository      statusRepository;

    // ══════════════════════════════════════════════════════════════════════════
    // ADD EXPENSE — show form
    // ══════════════════════════════════════════════════════════════════════════

    /**
     * Renders the "Add Expense" form.
     * Loads all dropdown data needed by the form.
     */
    @GetMapping("/addexpense")
    public String showAddExpenseForm(HttpSession session, Model model) {
        UserEntity user = requireLogin(session);
        if (user == null) return "redirect:/login";

        populateExpenseFormModel(model, user);
        // Pre-fill today's date for convenience
        model.addAttribute("todayDate", LocalDate.now().toString());
        return "pages/expense/AddExpense";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // SAVE EXPENSE — POST
    // ══════════════════════════════════════════════════════════════════════════

    /**
     * Persists a new expense. Associates it with the logged-in user.
     * Handles both new saves and updates (via save() which upserts by PK).
     */
    @PostMapping("/saveexpense")
    public String saveExpense(ExpenseEntity expense,
                              HttpSession session,
                              RedirectAttributes ra) {

        UserEntity user = requireLogin(session);
        if (user == null) return "redirect:/login";

        expense.setUserId(user.getUserId());
        expenseRepository.save(expense);

        ra.addFlashAttribute("success", "Expense saved successfully.");
        return "redirect:/listexpense";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // LIST EXPENSES
    // ══════════════════════════════════════════════════════════════════════════

    /**
     * Lists all expenses for the logged-in user.
     * Admin users see the full platform list.
     *
     * Data provided to JSP:
     * - expenseList         → List<ExpenseEntity>
     * - categoryMap         → Map<Integer, String>
     * - subCategoryMap      → Map<Integer, String>
     * - vendorMap           → Map<Integer, String>
     * - accountMap          → Map<Integer, String>
     * - statusMap           → Map<Integer, String>
     * - totalExpenseAmount  → BigDecimal
     */
    @GetMapping("/listexpense")
    public String listExpenses(
            @RequestParam(defaultValue = "0")           int    page,
            @RequestParam(defaultValue = "10")          int    size,
            @RequestParam(defaultValue = "")            String keyword,
            @RequestParam(defaultValue = "expenseDate") String sortBy,
            @RequestParam(defaultValue = "desc")        String direction,
            HttpSession session, Model model) {
        UserEntity user = requireLogin(session);
        if (user == null) return "redirect:/login";

        boolean isAdmin = "Admin".equals(user.getRole());

        Sort sort = "desc".equalsIgnoreCase(direction)
                ? Sort.by(sortBy).descending()
                : Sort.by(sortBy).ascending();
        Pageable pageable = PageRequest.of(page, size, sort);

        // ── Fetch paginated expense list — user-scoped unless Admin ───────────
        Page<ExpenseEntity> expensePage;
        if (keyword != null && !keyword.isBlank()) {
            expensePage = isAdmin
                    ? expenseRepository.findByDescriptionContainingIgnoreCase(keyword, pageable)
                    : expenseRepository.findByUserIdAndDescriptionContainingIgnoreCase(user.getUserId(), keyword, pageable);
        } else {
            expensePage = isAdmin
                    ? expenseRepository.findAll(pageable)
                    : expenseRepository.findByUserId(user.getUserId(), pageable);
        }

        // ── Reference data for lookup maps ────────────────────────────────────
        List<CategoryEntity>    categories    = categoryRepository.findAll();
        List<SubCategoryEntity> subCategories = subCategoryRepository.findAll();
        List<VendorEntity>      vendors       = vendorRepository.findAll();
        List<StatusEntity>      statuses      = statusRepository.findAll();

        // Accounts: admin sees all; customer sees their own
        List<AccountEntity> accounts = isAdmin
                ? accountRepository.findAll()
                : accountRepository.findByUserId(user.getUserId());

        // ── Build O(1) lookup maps — avoids nested loops in JSP ───────────────
        Map<Integer, String> categoryMap    = toNameMap(categories,    CategoryEntity::getCategoryId,       CategoryEntity::getCategoryName);
        Map<Integer, String> subCategoryMap = toNameMap(subCategories, SubCategoryEntity::getSubCategoryId, SubCategoryEntity::getSubCategoryName);
        Map<Integer, String> vendorMap      = toNameMap(vendors,       VendorEntity::getVendorId,           VendorEntity::getVendorName);
        Map<Integer, String> accountMap     = toNameMap(accounts,      AccountEntity::getAccountId,         AccountEntity::getAccountName);
        Map<Integer, String> statusMap      = toNameMap(statuses,      StatusEntity::getStatusId,           StatusEntity::getStatusName);

        // ── Grand total (all records, not filtered) ────────────────────────────
        BigDecimal totalExpenseAmount = isAdmin
                ? java.util.Optional.ofNullable(expenseRepository.sumAll()).orElse(BigDecimal.ZERO)
                : java.util.Optional.ofNullable(expenseRepository.sumByUserId(user.getUserId())).orElse(BigDecimal.ZERO);

        // ── Bind model ────────────────────────────────────────────────────────
        model.addAttribute("expensePage",        expensePage);
        model.addAttribute("categoryMap",        categoryMap);
        model.addAttribute("subCategoryMap",     subCategoryMap);
        model.addAttribute("vendorMap",          vendorMap);
        model.addAttribute("accountMap",         accountMap);
        model.addAttribute("statusMap",          statusMap);
        model.addAttribute("totalExpenseAmount", totalExpenseAmount);
        model.addAttribute("keyword",            keyword);
        model.addAttribute("sortBy",             sortBy);
        model.addAttribute("direction",          direction);
        model.addAttribute("activeMenu",         "expense");

        return "pages/expense/ListExpense";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // EDIT EXPENSE — show pre-populated form
    // ══════════════════════════════════════════════════════════════════════════

    /**
     * Loads the expense for editing.
     * Guards against invalid or foreign IDs.
     */
    @GetMapping("/editexpense")
    public String showEditExpenseForm(@RequestParam Integer expenseId,
                                      HttpSession session,
                                      Model model) {

        UserEntity user = requireLogin(session);
        if (user == null) return "redirect:/login";

        ExpenseEntity expense = expenseRepository.findById(expenseId).orElse(null);
        if (expense == null) return "redirect:/listexpense";

        // Security: non-admin users cannot edit other users' expenses
        if (!"Admin".equals(user.getRole()) && !expense.getUserId().equals(user.getUserId())) {
            return "redirect:/listexpense";
        }

        model.addAttribute("expense",    expense);
        model.addAttribute("todayDate",  LocalDate.now().toString());
        populateExpenseFormModel(model, user);

        return "pages/expense/AddExpense";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // UPDATE EXPENSE — POST
    // ══════════════════════════════════════════════════════════════════════════

    @PostMapping("/updateexpense")
    public String updateExpense(ExpenseEntity expense,
                                HttpSession session,
                                RedirectAttributes ra) {

        UserEntity user = requireLogin(session);
        if (user == null) return "redirect:/login";

        expense.setUserId(user.getUserId());
        expenseRepository.save(expense);   // JPA save() does UPSERT by PK

        ra.addFlashAttribute("success", "Expense updated successfully.");
        return "redirect:/listexpense";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // DELETE EXPENSE
    // ══════════════════════════════════════════════════════════════════════════

    /**
     * Deletes an expense after verifying ownership.
     * Existence check prevents 500 on stale links.
     */
    @GetMapping("/deleteexpense")
    public String deleteExpense(@RequestParam Integer expenseId,
                                HttpSession session,
                                RedirectAttributes ra) {

        UserEntity user = requireLogin(session);
        if (user == null) return "redirect:/login";

        expenseRepository.findById(expenseId).ifPresent(expense -> {
            // Ownership guard
            if ("Admin".equals(user.getRole()) || expense.getUserId().equals(user.getUserId())) {
                expenseRepository.deleteById(expenseId);
                ra.addFlashAttribute("success", "Expense deleted.");
            } else {
                ra.addFlashAttribute("error", "You are not authorised to delete this expense.");
            }
        });

        return "redirect:/listexpense";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // PRIVATE HELPERS
    // ══════════════════════════════════════════════════════════════════════════

    /** Pulls the UserEntity from session; returns null if missing. */
    private UserEntity requireLogin(HttpSession session) {
        return (UserEntity) session.getAttribute("user");
    }

    /**
     * Loads all dropdown data needed by the Add/Edit expense form.
     * Accounts are user-scoped; everything else is shared reference data.
     */
    private void populateExpenseFormModel(Model model, UserEntity user) {
        boolean isAdmin = "Admin".equals(user.getRole());

        List<AccountEntity> accounts = isAdmin
                ? accountRepository.findAll()
                : accountRepository.findByUserId(user.getUserId());

        model.addAttribute("categoryList",    categoryRepository.findAll());
        model.addAttribute("subCategoryList", subCategoryRepository.findAll());
        model.addAttribute("vendorList",      vendorRepository.findAll());
        model.addAttribute("accountList",     accounts);
        model.addAttribute("statusList",      statusRepository.findAll());
    }

    /**
     * Generic helper to build an Integer → String lookup map from a list.
     * Uses method references to keep call sites clean.
     */
    private <T> Map<Integer, String> toNameMap(
            List<T> items,
            java.util.function.Function<T, Integer> keyExtractor,
            java.util.function.Function<T, String>  valueExtractor) {

        return items.stream()
                .collect(Collectors.toMap(
                        keyExtractor,
                        valueExtractor,
                        (a, b) -> a));   // Merge: keep first on duplicate key
    }
}
