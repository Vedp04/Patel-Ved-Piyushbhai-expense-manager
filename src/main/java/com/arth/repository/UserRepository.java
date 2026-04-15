package com.arth.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.arth.entity.UserEntity;

public interface UserRepository extends JpaRepository<UserEntity, Integer> {
	UserEntity findByEmailAddress(String emailAddress);
}
