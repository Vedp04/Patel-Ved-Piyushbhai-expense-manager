package com.grownited.service;

public interface ForgotPasswordService {

    boolean sendOtp(String email);

    boolean verifyOtp(String email, String otp);

    void updatePassword(String email, String newPassword);
}
