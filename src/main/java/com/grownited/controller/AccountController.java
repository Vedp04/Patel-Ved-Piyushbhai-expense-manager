package com.grownited.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.grownited.entity.AccountEntity;
import com.grownited.entity.UserEntity;
import com.grownited.repository.AccountRepository;

import jakarta.servlet.http.HttpSession;

@Controller
public class AccountController {

    @Autowired private AccountRepository accountRepository;

    // ══════════════════════════════════════════════════════════════════════════
    // ADD ACCOUNT — show form
    // ══════════════════════════════════════════════════════════════════════════

    @GetMapping("/addaccount")
    public String showAddAccountForm(HttpSession session) {
        if (session.getAttribute("user") == null) return "redirect:/login";
        return "pages/account/AddAccount";
    }


    @PostMapping("/saveaccount")
    public String saveAccount(AccountEntity account,
                              HttpSession session,
                              RedirectAttributes ra) {

        UserEntity user = requireLogin(session);
        if (user == null) return "redirect:/login";

        // Checkbox sends null when unchecked — default to false
        if (account.getExDefault() == null) {
            account.setExDefault(false);
        }

        account.setUserId(user.getUserId());
        accountRepository.save(account);

        ra.addFlashAttribute("success", "Account created successfully.");
        return "redirect:/listaccount";
    }


    @GetMapping("/listaccount")
    public String listAccounts(
            @RequestParam(defaultValue = "0")            int    page,
            @RequestParam(defaultValue = "10")           int    size,
            @RequestParam(defaultValue = "")             String keyword,
            @RequestParam(defaultValue = "accountName")  String sortBy,
            @RequestParam(defaultValue = "asc")          String direction,
            HttpSession session, Model model) {

        UserEntity user = requireLogin(session);
        if (user == null) return "redirect:/login";

        Sort sort = "desc".equalsIgnoreCase(direction)
                ? Sort.by(sortBy).descending()
                : Sort.by(sortBy).ascending();
        Pageable pageable = PageRequest.of(page, size, sort);

        boolean isAdmin = "Admin".equals(user.getRole());
        Page<AccountEntity> accountPage;

        if (keyword != null && !keyword.isBlank()) {
            accountPage = isAdmin
                    ? accountRepository.findByAccountNameContainingIgnoreCase(keyword, pageable)
                    : accountRepository.findByUserIdAndAccountNameContainingIgnoreCase(user.getUserId(), keyword, pageable);
        } else {
            accountPage = isAdmin
                    ? accountRepository.findAll(pageable)
                    : accountRepository.findByUserId(user.getUserId(), pageable);
        }

        model.addAttribute("accountPage", accountPage);
        model.addAttribute("keyword",     keyword);
        model.addAttribute("sortBy",      sortBy);
        model.addAttribute("direction",   direction);
        model.addAttribute("activeMenu",  "account");

        return "pages/account/ListAccount";
    }


    @GetMapping("/editaccount")
    public String showEditAccountForm(@RequestParam Integer accountId,
                                      HttpSession session,
                                      Model model) {

        UserEntity user = requireLogin(session);
        if (user == null) return "redirect:/login";

        AccountEntity account = accountRepository.findById(accountId).orElse(null);
        if (account == null) return "redirect:/listaccount";

        // Ownership guard
        if (!"Admin".equals(user.getRole()) && !account.getUserId().equals(user.getUserId())) {
            return "redirect:/listaccount";
        }

        model.addAttribute("account", account);
        return "pages/account/AddAccount";
    }


    @PostMapping("/updateaccount")
    public String updateAccount(AccountEntity account,
                                HttpSession session,
                                RedirectAttributes ra) {

        UserEntity user = requireLogin(session);
        if (user == null) return "redirect:/login";

        // Checkbox null-safety
        if (account.getExDefault() == null) {
            account.setExDefault(false);
        }

        account.setUserId(user.getUserId());
        accountRepository.save(account);

        ra.addFlashAttribute("success", "Account updated successfully.");
        return "redirect:/listaccount";
    }


    @GetMapping("/deleteaccount")
    public String deleteAccount(@RequestParam Integer accountId,
                                HttpSession session,
                                RedirectAttributes ra) {

        UserEntity user = requireLogin(session);
        if (user == null) return "redirect:/login";

        accountRepository.findById(accountId).ifPresent(account -> {
            if ("Admin".equals(user.getRole()) || account.getUserId().equals(user.getUserId())) {
                accountRepository.deleteById(accountId);
                ra.addFlashAttribute("success", "Account deleted.");
            } else {
                ra.addFlashAttribute("error", "You are not authorised to delete this account.");
            }
        });

        return "redirect:/listaccount";
    }

    private UserEntity requireLogin(HttpSession session) {
        return (UserEntity) session.getAttribute("user");
    }
}
