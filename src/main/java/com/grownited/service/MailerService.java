package com.grownited.service;

import java.nio.charset.StandardCharsets;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ResourceLoader;
import org.springframework.core.io.Resource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.grownited.entity.UserEntity;

import jakarta.mail.internet.MimeMessage;

@Service
public class MailerService {

    @Autowired
    private JavaMailSender javaMailSender;

    @Autowired
    private ResourceLoader resourceLoader;

    public void sendWelcomeEmail(UserEntity user) {

        try {
            MimeMessage message = javaMailSender.createMimeMessage();

            Resource resource = resourceLoader.getResource("classpath:templates/WelcomeEmailTemplate.html");

            String html = new String(
                resource.getInputStream().readAllBytes(),
                StandardCharsets.UTF_8
            );

            String body = html
                    .replace("${name}", user.getFirstName())
                    .replace("${email}", user.getEmail())
                    .replace("${loginUrl}", "http://localhost:9999/login")
                    .replace("${companyName}", "MoneyTrail");

            MimeMessageHelper helper =
                    new MimeMessageHelper(message, true, StandardCharsets.UTF_8.name());

            helper.setTo(user.getEmail());
            helper.setFrom("sahrejaydeep05@gmail.com");
            helper.setSubject("MoneyTrail – Welcome aboard!");
            helper.setText(body, true);

            javaMailSender.send(message);

        } catch (Exception e) {
            throw new RuntimeException("Failed to send welcome email", e);
        }
    }
    
    public void sendOtpEmail(UserEntity user, String otp) {

        try {
            MimeMessage message = javaMailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true);

            helper.setTo(user.getEmail());
            helper.setSubject("MoneyTrail - Forgot Password OTP");
            helper.setText(
                "Hello,\n\nYour OTP for password reset is: " + otp +
                "\n\nRegards,\nMoneyTrail"
            );

            javaMailSender.send(message);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
