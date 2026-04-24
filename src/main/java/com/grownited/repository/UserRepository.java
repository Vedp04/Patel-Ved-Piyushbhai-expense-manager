package com.grownited.repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.grownited.entity.UserEntity;

@Repository
public interface UserRepository extends JpaRepository<UserEntity, Integer>{
	
	Optional<UserEntity> findByEmail(String email);
	List<UserEntity> findByRole(String role);
	long countByActiveTrue();

	List<UserEntity> findTop7ByOrderByUserIdDesc();

	long countByCreatAtDate(LocalDate date);

	// Paginated queries
	Page<UserEntity> findByFirstNameContainingIgnoreCaseOrLastNameContainingIgnoreCaseOrEmailContainingIgnoreCase(
			String firstName, String lastName, String email, Pageable pageable);
}
