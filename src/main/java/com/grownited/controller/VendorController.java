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

import com.grownited.entity.UserEntity;
import com.grownited.entity.VendorEntity;
import com.grownited.repository.VendorRepository;

import jakarta.servlet.http.HttpSession;

/**
 * Manages Vendors (shared reference data used by expense transactions).
 *
 * Routes:
 *   GET  /addvendor     → show form
 *   POST /savevendor    → persist new vendor
 *   GET  /listvendor    → list all vendors
 *   GET  /editvendor    → show pre-filled form
 *   POST /updatevendor  → persist changes
 *   GET  /deletevendor  → delete vendor
 */
@Controller
public class VendorController {

    @Autowired private VendorRepository vendorRepository;

    // ══════════════════════════════════════════════════════════════════════════
    // ADD VENDOR — show form
    // ══════════════════════════════════════════════════════════════════════════

    @GetMapping("/addvendor")
    public String showAddVendorForm(HttpSession session) {
        if (requireLogin(session) == null) return "redirect:/login";
        return "pages/vendor/AddVendor";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // SAVE VENDOR — POST
    // ══════════════════════════════════════════════════════════════════════════

    /**
     * Persists a new vendor.
     * Performs a case-insensitive duplicate check before saving.
     */
    @PostMapping("/savevendor")
    public String saveVendor(VendorEntity vendor,
                             HttpSession session,
                             RedirectAttributes ra) {

        if (requireLogin(session) == null) return "redirect:/login";

        String name = vendor.getVendorName();
        if (name == null || name.isBlank()) {
            ra.addFlashAttribute("error", "Vendor name is required.");
            return "redirect:/addvendor";
        }

        // Duplicate check — vendors are shared, so name must be globally unique
        boolean exists = vendorRepository.findAll().stream()
                .anyMatch(v -> v.getVendorName().equalsIgnoreCase(name.trim())
                            && !v.getVendorId().equals(vendor.getVendorId()));

        if (exists) {
            ra.addFlashAttribute("error", "Vendor \"" + name + "\" already exists.");
            return "redirect:/addvendor";
        }

        vendorRepository.save(vendor);
        ra.addFlashAttribute("success", "Vendor \"" + name + "\" added.");
        return "redirect:/listvendor";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // LIST VENDORS
    // ══════════════════════════════════════════════════════════════════════════

    /**
     * Lists all vendors (shared platform data).
     *
     * Data provided to JSP:
     * - vendorList → List<VendorEntity>
     */
    @GetMapping("/listvendor")
    public String listVendors(
            @RequestParam(defaultValue = "0")          int    page,
            @RequestParam(defaultValue = "10")         int    size,
            @RequestParam(defaultValue = "")           String keyword,
            @RequestParam(defaultValue = "vendorName") String sortBy,
            @RequestParam(defaultValue = "asc")        String direction,
            HttpSession session, Model model) {
        if (requireLogin(session) == null) return "redirect:/login";

        Sort sort = "desc".equalsIgnoreCase(direction)
                ? Sort.by(sortBy).descending()
                : Sort.by(sortBy).ascending();
        Pageable pageable = PageRequest.of(page, size, sort);

        Page<VendorEntity> vendorPage;
        if (keyword != null && !keyword.isBlank()) {
            vendorPage = vendorRepository.findByVendorNameContainingIgnoreCase(keyword, pageable);
        } else {
            vendorPage = vendorRepository.findAll(pageable);
        }

        model.addAttribute("vendorPage", vendorPage);
        model.addAttribute("keyword",    keyword);
        model.addAttribute("sortBy",     sortBy);
        model.addAttribute("direction",  direction);
        model.addAttribute("activeMenu", "vendor");

        return "pages/vendor/ListVendor";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // EDIT VENDOR — show pre-filled form
    // ══════════════════════════════════════════════════════════════════════════

    @GetMapping("/editvendor")
    public String showEditVendorForm(@RequestParam Integer vendorId,
                                     HttpSession session,
                                     Model model) {

        if (requireLogin(session) == null) return "redirect:/login";

        VendorEntity vendor = vendorRepository.findById(vendorId).orElse(null);
        if (vendor == null) return "redirect:/listvendor";

        model.addAttribute("vendor", vendor);
        return "pages/vendor/AddVendor";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // UPDATE VENDOR — POST
    // ══════════════════════════════════════════════════════════════════════════

    @PostMapping("/updatevendor")
    public String updateVendor(VendorEntity vendor,
                               HttpSession session,
                               RedirectAttributes ra) {

        if (requireLogin(session) == null) return "redirect:/login";

        String name = vendor.getVendorName();
        if (name == null || name.isBlank()) {
            ra.addFlashAttribute("error", "Vendor name is required.");
            return "redirect:/editvendor?vendorId=" + vendor.getVendorId();
        }

        // Duplicate check — exclude the current vendor from comparison
        boolean duplicate = vendorRepository.findAll().stream()
                .anyMatch(v -> v.getVendorName().equalsIgnoreCase(name.trim())
                            && !v.getVendorId().equals(vendor.getVendorId()));

        if (duplicate) {
            ra.addFlashAttribute("error", "Another vendor with this name already exists.");
            return "redirect:/editvendor?vendorId=" + vendor.getVendorId();
        }

        vendorRepository.save(vendor);
        ra.addFlashAttribute("success", "Vendor updated.");
        return "redirect:/listvendor";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // DELETE VENDOR
    // ══════════════════════════════════════════════════════════════════════════

    /**
     * Deletes a vendor by ID.
     * NOTE: In production, verify no active expenses reference this vendor
     *       before deletion to avoid orphaned foreign-key references.
     */
    @GetMapping("/deletevendor")
    public String deleteVendor(@RequestParam Integer vendorId,
                               HttpSession session,
                               RedirectAttributes ra) {

        if (requireLogin(session) == null) return "redirect:/login";

        if (!vendorRepository.existsById(vendorId)) {
            ra.addFlashAttribute("error", "Vendor not found.");
            return "redirect:/listvendor";
        }

        vendorRepository.deleteById(vendorId);
        ra.addFlashAttribute("success", "Vendor deleted.");
        return "redirect:/listvendor";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // PRIVATE HELPER
    // ══════════════════════════════════════════════════════════════════════════

    private UserEntity requireLogin(HttpSession session) {
        return (UserEntity) session.getAttribute("user");
    }
}
