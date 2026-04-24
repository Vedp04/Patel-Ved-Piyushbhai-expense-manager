package com.grownited.filter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;

import org.springframework.stereotype.Component;

import com.grownited.entity.UserEntity;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
public class AuthFilter implements Filter {

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse res = (HttpServletResponse) response;
		
		String uri = req.getRequestURI().toString();

		ArrayList<String> publicUrl = new ArrayList<>();

		publicUrl.add("/login");
		publicUrl.add("/signup");
		publicUrl.add("/forgot-password");
		publicUrl.add("/authenticate");
		publicUrl.add("/register");
		publicUrl.add("/send-otp");
		publicUrl.add("/verify-otp");
		publicUrl.add("/reset-password");
		publicUrl.add("/logout");
		

		if (publicUrl.contains(uri) || uri.contains("css") || uri.contains("js") || uri.contains("fonts") || uri.contains("images") || uri.contains("favicon.ico")) {
			// go ahead
			chain.doFilter(request, response);
		} else {
			System.out.println("AuthFilter ......" + new Date());
			System.out.println(uri);
			HttpSession session = req.getSession(false); //don't create new session
		    UserEntity user = (session != null) ? (UserEntity) session.getAttribute("user") : null;

		    if (user == null) {
		        res.sendRedirect("/login");
		    } else {
		        chain.doFilter(request, response);
		    }
		}

	}
}