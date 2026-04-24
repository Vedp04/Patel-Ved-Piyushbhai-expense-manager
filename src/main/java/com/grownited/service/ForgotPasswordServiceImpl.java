package com.grownited.service;

import java.util.Optional;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.grownited.entity.UserEntity;
import com.grownited.repository.UserRepository;

@Service
public class ForgotPasswordServiceImpl implements ForgotPasswordService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private MailerService mailerService;
    
    @Autowired
    PasswordEncoder passwordEncoder;

    @Override
    public boolean sendOtp(String email) {

        Optional<UserEntity> optionalUser = userRepository.findByEmail(email);
        if (optionalUser.isEmpty()) {
            return false;
        }

        UserEntity user = optionalUser.get();

        // generate 6-digit OTP
        String otp = String.valueOf(new Random().nextInt(900000) + 100000);

        user.setOtp(otp);
        userRepository.save(user);

        mailerService.sendOtpEmail(user, otp);
        return true;
    }

    @Override
    public boolean verifyOtp(String email, String otp) {

        Optional<UserEntity> optionalUser = userRepository.findByEmail(email);
        if (optionalUser.isEmpty()) return false;

        UserEntity user = optionalUser.get();

        return otp != null && otp.equals(user.getOtp());
    }

    @Override
    public void updatePassword(String email, String newPassword) {

        UserEntity user = userRepository.findByEmail(email).orElseThrow();

        String encodedPassword = passwordEncoder.encode(newPassword);
        user.setPassword(encodedPassword);
        // clear OTP after success
        user.setOtp(null);

        userRepository.save(user);
    }
}