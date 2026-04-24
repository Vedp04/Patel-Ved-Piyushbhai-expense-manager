package com.grownited.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.grownited.entity.AccountEntity;

@Repository
public interface AccountRepository extends JpaRepository<AccountEntity, Integer> {
	List<AccountEntity> findByUserId(Integer userId);

	// Paginated queries
	Page<AccountEntity> findByUserId(Integer userId, Pageable pageable);
	Page<AccountEntity> findByUserIdAndAccountNameContainingIgnoreCase(Integer userId, String keyword, Pageable pageable);
	Page<AccountEntity> findByAccountNameContainingIgnoreCase(String keyword, Pageable pageable);
}
