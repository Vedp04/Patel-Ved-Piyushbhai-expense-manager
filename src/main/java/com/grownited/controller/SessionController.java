package com.grownited.controller;

import java.io.IOException;
import java.time.LocalDate;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.cloudinary.Cloudinary;
import com.grownited.entity.UserEntity;
import com.grownited.repository.UserRepository;
import com.grownited.service.ForgotPasswordService;
import com.grownited.service.MailerService;

import jakarta.servlet.http.HttpSession;

/**
 * Handles all authentication flows:
 * Login, Registration, Logout, Forgot / Reset Password, OTP verification.
 */
@Controller
public class SessionController {

    // ── Dependencies ──────────────────────────────────────────────────────────

    @Autowired private UserRepository        userRepository;
    @Autowired private MailerService          mailerService;
    @Autowired private ForgotPasswordService  forgotPasswordService;
    @Autowired private PasswordEncoder        passwordEncoder;
    @Autowired private Cloudinary             cloudinary;

    // ══════════════════════════════════════════════════════════════════════════
    // SIGN-UP
    // ══════════════════════════════════════════════════════════════════════════

    /** Show the registration form. */
    @GetMapping("/signup")
    public String showSignupPage() {
        return "auth/Signup";
    }

    /**
     * Process registration.
     * Validates required fields, checks for duplicate email,
     * hashes the password, optionally uploads a profile picture to Cloudinary,
     * persists the user, and sends a welcome e-mail.
     */
    @PostMapping("/register")
    public String register(UserEntity userEntity,
                           @RequestParam(value = "profilePic", required = false) MultipartFile profilePic,
                           Model model) {

        // ── Basic validation ──────────────────────────────────────────────────
        String email    = userEntity.getEmail()    != null ? userEntity.getEmail().trim()    : "";
        String password = userEntity.getPassword() != null ? userEntity.getPassword().trim() : "";

        if (email.isEmpty() || password.isEmpty()) {
            model.addAttribute("error", "Email and password are required.");
            return "auth/Signup";
        }

        // ── Duplicate e-mail check ────────────────────────────────────────────
        if (userRepository.findByEmail(email).isPresent()) {
            model.addAttribute("error", "This email is already registered. Please sign in.");
            return "auth/Signup";
        }

        // ── Set role, join date, active flag ──────────────────────────────────
        userEntity.setRole("Customer");
        userEntity.setCreatAtDate(LocalDate.now());
        userEntity.setActive(true);

        // ── Hash password (never store plain text) ────────────────────────────
        userEntity.setPassword(passwordEncoder.encode(password));

        // ── Optional profile picture upload ───────────────────────────────────
        if (profilePic != null && !profilePic.isEmpty()) {
            try {
                Map<?, ?> uploadResult = cloudinary.uploader().upload(profilePic.getBytes(), null);
                Object url = uploadResult.get("secure_url");
                if (url != null) {
                    userEntity.setProfilePicURL(url.toString());
                }
            } catch (IOException ex) {
                model.addAttribute("error", "Profile picture upload failed. Please try again.");
                return "auth/Signup";
            }
        }

        // ── Persist and welcome ───────────────────────────────────────────────
        userRepository.save(userEntity);
        mailerService.sendWelcomeEmail(userEntity);

        return "auth/Login";   // Redirect to login after successful registration
    }

    // ══════════════════════════════════════════════════════════════════════════
    // LOGIN
    // ══════════════════════════════════════════════════════════════════════════

    /** Show the login form. */
    @GetMapping("/login")
    public String showLoginPage() {
        return "auth/Login";
    }

    /**
     * Authenticate the user.
     * Verifies email existence, password match, and active status,
     * then stores the user in the HTTP session and routes by role.
     */
    @PostMapping("/authenticate")
    public String authenticate(@RequestParam String email,
                               @RequestParam String password,
                               Model model,
                               HttpSession session) {

        // ── Empty input guard ─────────────────────────────────────────────────
        if (email == null || email.isBlank() || password == null || password.isBlank()) {
            model.addAttribute("error", "Email and password are required.");
            return "auth/Login";
        }

        Optional<UserEntity> optional = userRepository.findByEmail(email.trim());

        if (optional.isEmpty()) {
            model.addAttribute("error", "No account found with that email.");
            return "auth/Login";
        }

        UserEntity user = optional.get();

        // ── Password verification ─────────────────────────────────────────────
        if (!passwordEncoder.matches(password, user.getPassword())) {
            model.addAttribute("error", "Incorrect password. Please try again.");
            return "auth/Login";
        }

        // ── Account active check ──────────────────────────────────────────────
        if (Boolean.FALSE.equals(user.getActive())) {
            model.addAttribute("error", "Your account has been deactivated. Please contact support.");
            return "auth/Login";
        }

        // ── Store user in session ─────────────────────────────────────────────
        session.setAttribute("user", user);

        // ── Route by role ─────────────────────────────────────────────────────
        return "Admin".equals(user.getRole())
                ? "redirect:/admin-dashboard"
                : "redirect:/customer-dashboard";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // DASHBOARD ROUTER
    // ══════════════════════════════════════════════════════════════════════════

    /**
     * Generic /dashboard route — redirects to role-specific dashboard.
     * Protects against direct access when session is missing.
     */
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        return "Admin".equals(user.getRole())
                ? "redirect:/admin-dashboard"
                : "redirect:/customer-dashboard";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // LOGOUT
    // ══════════════════════════════════════════════════════════════════════════

    /** Invalidate session and redirect to login. */
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // FORGOT PASSWORD — STEP 1: Enter registered email
    // ══════════════════════════════════════════════════════════════════════════

    @GetMapping("/forgot-password")
    public String showForgotPasswordPage() {
        return "auth/ForgetPassword";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // FORGOT PASSWORD — STEP 2: Send OTP to email
    // ══════════════════════════════════════════════════════════════════════════

    /**
     * Attempt to send OTP. If the e-mail is not registered the user
     * is informed without disclosing internal details.
     */
    @PostMapping("/send-otp")
    public String sendOtp(@RequestParam String email, Model model) {

        if (email == null || email.isBlank()) {
            model.addAttribute("error", "Please enter your registered email.");
            return "auth/ForgetPassword";
        }

        boolean sent = forgotPasswordService.sendOtp(email.trim());

        if (!sent) {
            model.addAttribute("error", "No account found with that email address.");
            return "auth/ForgetPassword";
        }

        model.addAttribute("email", email.trim());
        return "auth/VerifyOtp";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // FORGOT PASSWORD — STEP 3: Verify OTP
    // ══════════════════════════════════════════════════════════════════════════

    @PostMapping("/verify-otp")
    public String verifyOtp(@RequestParam String email,
                            @RequestParam String otp,
                            Model model) {

        boolean valid = forgotPasswordService.verifyOtp(email, otp);

        if (!valid) {
            model.addAttribute("error", "Invalid or expired OTP. Please try again.");
            model.addAttribute("email", email);
            return "auth/VerifyOtp";
        }

        model.addAttribute("email", email);
        return "auth/ResetPassword";
    }

    // ══════════════════════════════════════════════════════════════════════════
    // FORGOT PASSWORD — STEP 4: Set new password
    // ══════════════════════════════════════════════════════════════════════════

    @PostMapping("/reset-password")
    public String resetPassword(@RequestParam String email,
                                @RequestParam String password,
                                Model model,
                                RedirectAttributes ra) {

        if (email == null || email.isBlank() || password == null || password.isBlank()) {
            model.addAttribute("error", "All fields are required.");
            model.addAttribute("email", email);
            return "auth/ResetPassword";
        }

        forgotPasswordService.updatePassword(email.trim(), password);
        ra.addFlashAttribute("success", "Password updated successfully. Please sign in.");
        return "redirect:/login";
    }
}
