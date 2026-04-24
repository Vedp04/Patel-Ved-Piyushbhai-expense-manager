package com.grownited.controller;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.TextStyle;
import java.util.*;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;


import com.grownited.entity.*;
import com.grownited.repository.*;
import com.grownited.service.ReportPdfService;

import jakarta.servlet.http.HttpSession;


@Controller
public class CustomerController {

    // ── Dependencies ──────────────────────────────────────────────────────────

    @Autowired private ExpenseRepository  expenseRepository;
    @Autowired private IncomeRepository   incomeRepository;
    @Autowired private VendorRepository   vendorRepository;
    @Autowired private CategoryRepository categoryRepository;
    @Autowired private AccountRepository  accountRepository;
    @Autowired private ReportPdfService   reportPdfService;


    @GetMapping("/customer-dashboard")
    public String customerDashboard(HttpSession session, Model model) {

        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        Integer userId = user.getUserId();

        // ── Time-of-day greeting ──────────────────────────────────────────────
        LocalTime now = LocalTime.now();
        String timeOfDay = now.isBefore(LocalTime.NOON)        ? "Morning"
                         : now.isBefore(LocalTime.of(17, 0))   ? "Afternoon"
                                                                : "Evening";

        // ── Current month name (for header text) ──────────────────────────────
        String currentMonthName = LocalDate.now()
                .getMonth().getDisplayName(TextStyle.FULL, Locale.ENGLISH);

        // ── Month boundaries ──────────────────────────────────────────────────
        LocalDate startOfMonth = LocalDate.now().withDayOfMonth(1);
        LocalDate endOfMonth   = startOfMonth.plusMonths(1).minusDays(1);

        // ── Aggregated totals via repository queries ───────────────────────────
        // Using dedicated monthly-range queries to avoid pulling all rows into memory.
        BigDecimal totalIncome  = safeDecimal(
                incomeRepository.sumByUserIdAndDateBetween(userId, startOfMonth, endOfMonth));
        BigDecimal totalExpense = safeDecimal(
                expenseRepository.sumByUserIdAndDateBetween(userId, startOfMonth, endOfMonth));

        // Net balance — floor at zero for display (negative means overspent)
        BigDecimal balance = totalIncome.subtract(totalExpense);
        if (balance.compareTo(BigDecimal.ZERO) < 0) balance = BigDecimal.ZERO;

        // ── Supporting counts ─────────────────────────────────────────────────
        long totalVendors = vendorRepository.count();   // Vendors are shared; count is intentional

        // ── Recent expenses (limited to 9 rows — repository handles it) ───────
        List<ExpenseEntity> recentExpenses =
                expenseRepository.findTop9ByUserIdOrderByExpenseDateDesc(userId);

        // ── Bind model ────────────────────────────────────────────────────────
        model.addAttribute("timeOfDay",        timeOfDay);
        model.addAttribute("currentMonthName", currentMonthName);
        model.addAttribute("totalIncome",      totalIncome);
        model.addAttribute("totalExpense",     totalExpense);
        model.addAttribute("balance",          balance);
        model.addAttribute("totalVendors",     totalVendors);
        model.addAttribute("recentExpenses",   recentExpenses);

        return "pages/dashboard/CustomerDashboard";
    }


    @GetMapping("/insights")
    public String insights(HttpSession session,
                           Model model,
                           @RequestParam(defaultValue = "month") String period) {

        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        Integer userId = user.getUserId();
        LocalDate today = LocalDate.now();

        // ── Date range from period parameter ──────────────────────────────────
        LocalDate startDate;
        switch (period) {
            case "quarter": startDate = today.minusMonths(3).withDayOfMonth(1); break;
            case "year":    startDate = today.withDayOfYear(1);                 break;
            case "all":     startDate = LocalDate.of(2000, 1, 1);               break;
            default:        startDate = today.withDayOfMonth(1);                break; // "month"
        }

        // ── Raw data — user-scoped, then filtered in memory by date ───────────
        // NOTE: Ideal approach is repository-level date filtering.
        // These lists are already small (one user's data), so in-memory is fine.
        List<ExpenseEntity>  allExpenses   = expenseRepository.findByUserId(userId);
        List<IncomeEntity>   allIncomes    = incomeRepository.findByUserId(userId);
        List<CategoryEntity> categories    = categoryRepository.findAll(); // Reference data — shared

        // Filter to chosen period
        final LocalDate start = startDate;
        List<ExpenseEntity> expenses = allExpenses.stream()
                .filter(e -> e.getExpenseDate() != null && !e.getExpenseDate().isBefore(start))
                .collect(Collectors.toList());

        List<IncomeEntity> incomes = allIncomes.stream()
                .filter(i -> i.getIncomeDate() != null && !i.getIncomeDate().isBefore(start))
                .collect(Collectors.toList());

        // ── Category lookup map (avoids N queries inside loops) ───────────────
        Map<Integer, String> categoryNameMap = categories.stream()
                .collect(Collectors.toMap(
                        CategoryEntity::getCategoryId,
                        CategoryEntity::getCategoryName,
                        (a, b) -> a));

        // ── KPI totals ─────────────────────────────────────────────────────────
        BigDecimal totalExpense = sumAmounts(expenses.stream()
                .map(ExpenseEntity::getAmount).collect(Collectors.toList()));

        BigDecimal totalIncome = sumAmounts(incomes.stream()
                .map(IncomeEntity::getAmount).collect(Collectors.toList()));

        BigDecimal balance = totalIncome.subtract(totalExpense);
        if (balance.compareTo(BigDecimal.ZERO) < 0) balance = BigDecimal.ZERO;

        // ── Savings rate ──────────────────────────────────────────────────────
        BigDecimal savingsRate = BigDecimal.ZERO;
        if (totalIncome.compareTo(BigDecimal.ZERO) > 0) {
            savingsRate = balance.multiply(BigDecimal.valueOf(100))
                    .divide(totalIncome, 2, RoundingMode.HALF_UP);
        }

        // ── 1. Expense by category (sorted descending) ────────────────────────
        Map<String, BigDecimal> categoryTotals = buildExpenseByCategoryMap(expenses, categoryNameMap);

        String topCategory       = null;
        BigDecimal topCategoryAmount = BigDecimal.ZERO;
        if (!categoryTotals.isEmpty()) {
            Map.Entry<String, BigDecimal> top = categoryTotals.entrySet().iterator().next();
            topCategory       = top.getKey();
            topCategoryAmount = top.getValue();
        }

        // ── Category percent breakdown (for progress bars in JSP) ─────────────
        Map<String, BigDecimal> categoryPercent = new LinkedHashMap<>();
        if (totalExpense.compareTo(BigDecimal.ZERO) > 0) {
            for (Map.Entry<String, BigDecimal> entry : categoryTotals.entrySet()) {
                BigDecimal pct = entry.getValue()
                        .multiply(BigDecimal.valueOf(100))
                        .divide(totalExpense, 2, RoundingMode.HALF_UP);
                categoryPercent.put(entry.getKey(), pct);
            }
        }

        // ── 2. Income by source (sorted descending) ───────────────────────────
        Map<String, BigDecimal> incomeTotals = buildIncomeBySourceMap(incomes);

        // ── 3. Monthly income vs expense (last 6 months) ──────────────────────
        List<String>     monthLabels      = new ArrayList<>();
        List<BigDecimal> monthIncomeData  = new ArrayList<>();
        List<BigDecimal> monthExpenseData = new ArrayList<>();

        for (int i = 5; i >= 0; i--) {
            LocalDate mStart = today.minusMonths(i).withDayOfMonth(1);
            LocalDate mEnd   = mStart.plusMonths(1).minusDays(1);

            monthLabels.add(mStart.getMonth()
                    .getDisplayName(TextStyle.SHORT, Locale.ENGLISH) + " " + mStart.getYear());

            // Sum income for this month — filter from already-fetched list
            BigDecimal mInc = sumFilteredByDate(incomes, mStart, mEnd,
                    e -> e.getIncomeDate(), IncomeEntity::getAmount);
            BigDecimal mExp = sumFilteredExpByDate(expenses, mStart, mEnd);

            monthIncomeData.add(mInc);
            monthExpenseData.add(mExp);
        }

        // ── 4. Cumulative balance trend (last 6 months) ───────────────────────
        List<String>     balanceTrendLabels = new ArrayList<>();
        List<BigDecimal> balanceTrendValues = new ArrayList<>();
        BigDecimal runningBalance = BigDecimal.ZERO;

        for (int i = 5; i >= 0; i--) {
            LocalDate ptStart = today.minusMonths(i).withDayOfMonth(1);
            LocalDate ptEnd   = ptStart.plusMonths(1).minusDays(1);

            BigDecimal mInc = sumFilteredByDate(incomes, ptStart, ptEnd,
                    e -> e.getIncomeDate(), IncomeEntity::getAmount);
            BigDecimal mExp = sumFilteredExpByDate(expenses, ptStart, ptEnd);

            runningBalance = runningBalance.add(mInc).subtract(mExp);

            balanceTrendLabels.add(ptStart.getMonth()
                    .getDisplayName(TextStyle.SHORT, Locale.ENGLISH));
            balanceTrendValues.add(runningBalance);
        }

        // ── 5. Payment mode breakdown ─────────────────────────────────────────
        Map<String, BigDecimal> paymentModeTotals = buildPaymentModeMap(expenses);

        // ── 6. Average daily spend ────────────────────────────────────────────
        long daysInPeriod = java.time.temporal.ChronoUnit.DAYS.between(startDate, today) + 1;
        BigDecimal avgDailySpend = daysInPeriod > 0
                ? totalExpense.divide(BigDecimal.valueOf(daysInPeriod), 2, RoundingMode.HALF_UP)
                : BigDecimal.ZERO;

        // ── 7. Largest single expense ─────────────────────────────────────────
        ExpenseEntity maxExpenseEntity = expenses.stream()
                .filter(e -> e.getAmount() != null)
                .max(Comparator.comparing(ExpenseEntity::getAmount))
                .orElse(null);
        BigDecimal maxExpense = maxExpenseEntity != null ? maxExpenseEntity.getAmount() : BigDecimal.ZERO;
        String maxExpenseDesc = (maxExpenseEntity != null && maxExpenseEntity.getDescription() != null)
                ? maxExpenseEntity.getDescription() : "N/A";

        // ── 8. Most-used account ──────────────────────────────────────────────
        String topAccount      = "N/A";
        Long   topAccountTxns  = 0L;

        Map<Integer, Long> accountUsage = expenses.stream()
                .filter(e -> e.getAccountId() != null)
                .collect(Collectors.groupingBy(ExpenseEntity::getAccountId, Collectors.counting()));

        if (!accountUsage.isEmpty()) {
            Map.Entry<Integer, Long> best = accountUsage.entrySet().stream()
                    .max(Map.Entry.comparingByValue())
                    .orElse(null);
            if (best != null) {
                topAccountTxns = best.getValue();
                topAccount = accountRepository.findById(best.getKey())
                        .map(AccountEntity::getAccountName)
                        .orElse("Account #" + best.getKey());
            }
        }

        // ── Chart colour arrays (index-safe, referenced by JSTL varStatus) ────
        String[] chartColors   = {"#ef4444","#f97316","#eab308","#8b5cf6",
                                   "#06b6d4","#ec4899","#14b8a6","#f59e0b"};
        String[] incomeColors  = {"#12b383","#22c55e","#4ade80","#86efac","#6ee7b7","#a7f3d0"};
        String[] modeColors    = {"#6366f1","#f59e0b","#12b383","#ef4444",
                                   "#0ea5e9","#8b5cf6","#ec4899"};

        // ── Bind all model attributes ─────────────────────────────────────────
        model.addAttribute("totalIncome",         totalIncome);
        model.addAttribute("totalExpense",         totalExpense);
        model.addAttribute("balance",              balance);
        model.addAttribute("incomeCount",          incomes.size());
        model.addAttribute("expenseCount",         expenses.size());
        model.addAttribute("savingsRate",          savingsRate);

        model.addAttribute("categoryTotals",       categoryTotals);
        model.addAttribute("categoryPercent",      categoryPercent);
        model.addAttribute("incomeTotals",         incomeTotals);
        model.addAttribute("paymentModeTotals",    paymentModeTotals);

        model.addAttribute("topCategory",          topCategory);
        model.addAttribute("topCategoryAmount",    topCategoryAmount);

        model.addAttribute("monthLabels",          monthLabels);
        model.addAttribute("monthIncomeData",      monthIncomeData);
        model.addAttribute("monthExpenseData",     monthExpenseData);

        model.addAttribute("balanceTrendLabels",   balanceTrendLabels);
        model.addAttribute("balanceTrendValues",   balanceTrendValues);

        model.addAttribute("avgDailySpend",        avgDailySpend);
        model.addAttribute("maxExpense",           maxExpense);
        model.addAttribute("maxExpenseDesc",       maxExpenseDesc);
        model.addAttribute("topAccount",           topAccount);
        model.addAttribute("topAccountTxns",       topAccountTxns);

        model.addAttribute("chartColors",          chartColors);
        model.addAttribute("incomeColors",         incomeColors);
        model.addAttribute("modeColors",           modeColors);

        model.addAttribute("pageTitle",            "Insights");
        model.addAttribute("activeMenu",           "insights");

        return "pages/dashboard/Insights";
    }


    /** Returns BigDecimal.ZERO when null (avoids NPE throughout). */
    private BigDecimal safeDecimal(BigDecimal value) {
        return value != null ? value : BigDecimal.ZERO;
    }

    /** Sums a list of BigDecimal values, safely ignoring nulls. */
    private BigDecimal sumAmounts(List<BigDecimal> amounts) {
        return amounts.stream()
                .filter(Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    /**
     * Builds expense-by-category map sorted by value descending.
     * Uses the pre-built categoryNameMap to avoid extra queries.
     */
    private Map<String, BigDecimal> buildExpenseByCategoryMap(
            List<ExpenseEntity> expenses,
            Map<Integer, String> categoryNameMap) {

        Map<String, BigDecimal> raw = new LinkedHashMap<>();
        for (ExpenseEntity e : expenses) {
            if (e.getAmount() == null) continue;
            String catName = (e.getCategoryId() != null)
                    ? categoryNameMap.getOrDefault(e.getCategoryId(), "Uncategorised")
                    : "Uncategorised";
            raw.merge(catName, e.getAmount(), BigDecimal::add);
        }
        // Sort descending by value
        return raw.entrySet().stream()
                .sorted(Map.Entry.<String, BigDecimal>comparingByValue().reversed())
                .collect(Collectors.toMap(
                        Map.Entry::getKey, Map.Entry::getValue,
                        (a, b) -> a, LinkedHashMap::new));
    }

    /** Builds income-by-source map sorted by value descending. */
    private Map<String, BigDecimal> buildIncomeBySourceMap(List<IncomeEntity> incomes) {
        Map<String, BigDecimal> raw = new LinkedHashMap<>();
        for (IncomeEntity i : incomes) {
            if (i.getAmount() == null) continue;
            String source = (i.getIncomeSource() != null && !i.getIncomeSource().isBlank())
                    ? i.getIncomeSource() : "Other";
            raw.merge(source, i.getAmount(), BigDecimal::add);
        }
        return raw.entrySet().stream()
                .sorted(Map.Entry.<String, BigDecimal>comparingByValue().reversed())
                .collect(Collectors.toMap(
                        Map.Entry::getKey, Map.Entry::getValue,
                        (a, b) -> a, LinkedHashMap::new));
    }

    /** Builds payment-mode map sorted descending. */
    private Map<String, BigDecimal> buildPaymentModeMap(List<ExpenseEntity> expenses) {
        Map<String, BigDecimal> raw = new LinkedHashMap<>();
        for (ExpenseEntity e : expenses) {
            if (e.getAmount() == null) continue;
            String mode = (e.getPaymentMode() != null && !e.getPaymentMode().isBlank())
                    ? e.getPaymentMode() : "Other";
            raw.merge(mode, e.getAmount(), BigDecimal::add);
        }
        return raw.entrySet().stream()
                .sorted(Map.Entry.<String, BigDecimal>comparingByValue().reversed())
                .collect(Collectors.toMap(
                        Map.Entry::getKey, Map.Entry::getValue,
                        (a, b) -> a, LinkedHashMap::new));
    }

    // Functional interfaces to keep date-filtering generic

    @FunctionalInterface
    interface DateExtractor<T> {
        LocalDate extract(T item);
    }

    @FunctionalInterface
    interface AmountExtractor<T> {
        BigDecimal extract(T item);
    }

    /** Sums amounts from a list filtered by a date range. */
    private <T> BigDecimal sumFilteredByDate(List<T> items,
                                              LocalDate from,
                                              LocalDate to,
                                              DateExtractor<T>   dateGetter,
                                              AmountExtractor<T> amountGetter) {
        return items.stream()
                .filter(item -> {
                    LocalDate d = dateGetter.extract(item);
                    return d != null && !d.isBefore(from) && !d.isAfter(to);
                })
                .map(amountGetter::extract)
                .filter(Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    /** Convenience overload for expenses (avoids lambda verbosity at call sites). */
    private BigDecimal sumFilteredExpByDate(List<ExpenseEntity> expenses,
                                             LocalDate from,
                                             LocalDate to) {
        return sumFilteredByDate(expenses, from, to,
                e -> e.getExpenseDate(), ExpenseEntity::getAmount);
    }

    @GetMapping("/reports/transactions/pdf")
    public ResponseEntity<byte[]> downloadTransactionsPdf(
            HttpSession session,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to) {

        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null) {
            return ResponseEntity.status(HttpStatus.FOUND)
                    .header(HttpHeaders.LOCATION, "/login").build();
        }
        if (from.isAfter(to) || from.isBefore(to.minusYears(1))) {
            return ResponseEntity.badRequest().build();
        }

        Integer userId = user.getUserId();

        List<ExpenseEntity> expenses = expenseRepository.findByUserId(userId).stream()
                .filter(e -> e.getExpenseDate() != null
                        && !e.getExpenseDate().isBefore(from)
                        && !e.getExpenseDate().isAfter(to))
                .toList();

        List<IncomeEntity> incomes = incomeRepository.findByUserId(userId).stream()
                .filter(i -> i.getIncomeDate() != null
                        && !i.getIncomeDate().isBefore(from)
                        && !i.getIncomeDate().isAfter(to))
                .toList();

        // ── Build category map ────────────────────────────────────────────────────
        Map<Integer, String> categoryMap = categoryRepository.findAll().stream()
                .collect(Collectors.toMap(
                        CategoryEntity::getCategoryId,
                        CategoryEntity::getCategoryName,
                        (a, b) -> a));

        byte[] pdf = reportPdfService.buildDateWiseTransactionsPdf(
                user, from, to, incomes, expenses, categoryMap);  // ← pass the map

        String filename = String.format("transactions_%s_to_%s.pdf", from, to);
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION,
                        "attachment; filename=\"" + filename + "\"")
                .contentType(MediaType.APPLICATION_PDF)
                .body(pdf);
    }
}
