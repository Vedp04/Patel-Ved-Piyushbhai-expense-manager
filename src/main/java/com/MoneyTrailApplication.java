package com;

import java.util.HashMap;
import java.util.Map;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

import com.cloudinary.Cloudinary;

@SpringBootApplication
public class MoneyTrailApplication {

	public static void main(String[] args) {
		SpringApplication.run(MoneyTrailApplication.class, args);
	}
	
	@Bean
	PasswordEncoder getPasswordEncoder() {
		return new BCryptPasswordEncoder();
	}
	
	@Bean
	Cloudinary getCloudinary() {
		Map<String, String> config = new HashMap<>();
		config.put("cloud_name", "dc6uhfusb");
		config.put("api_key", "568896917788868");
		config.put("api_secret", "M96amvhkPJ0xQ7LdPXzurvs1Q3Q");
		return new Cloudinary(config);
	}

}
