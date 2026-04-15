package com.arth.service;

import java.util.Properties;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

@Service
public class MailerService {
	
 	private String fromEmail="tejasshah2k2k@gmail.com";
	
	private String fromEmailPassword="iyiioomnlroplini"; 
	
	public void sendMailForOTP(String email, int otp) {
		Properties props = System.getProperties();
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.port", "465");
		props.put("mail.smtp.ssl.enable", "true");
		props.put("mail.smtp.auth", "true");

		Session session = Session.getInstance(props, new Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(fromEmail, fromEmailPassword);
			}
		});
		
		session.setDebug(true);

		try {
			MimeMessage message = new MimeMessage(session);
			message.addRecipient(Message.RecipientType.TO, new InternetAddress(email));
			message.setSubject("OTP For Reset Password");
			message.setText("OTP To Reset Password: " + otp);
			
			Transport.send(message);
			System.out.println("Message sent successfully.");
		} catch (MessagingException e) {
			throw new RuntimeException(e);
		}
	}
	
	public void  sendMailForWelcome(String email, String firstName) {
		System.out.println("formEmail "+fromEmail);
		Properties props = System.getProperties();
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.port", "465");
		props.put("mail.smtp.ssl.enable", "true");
		props.put("mail.smtp.auth", "true");

		Session session = Session.getInstance(props, new Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(fromEmail,fromEmailPassword);
			}
		});
		
		session.setDebug(true);

		try {
			MimeMessage message = new MimeMessage(session);
			message.addRecipient(Message.RecipientType.TO, new InternetAddress(email));
			message.setSubject("Welcome " + firstName + " to ExpenseManager");
			message.setText(" Welcome to Expense Manager Web Application: \n"
					+ "	Your Ultimate Financial Companion! \n"
					+ "	\nEffortlessly manage your expenses, track your spending, and take control of your finances with ExpenseManager. Our intuitive application is designed to simplify the way you handle your money, providing you with powerful tools to budget, analyze, and plan your financial goals. \n");
			
			Transport.send(message);
			System.out.println("Message sent successfully.");
		} catch (MessagingException e) {
			throw new RuntimeException(e);
		}

	}
}
