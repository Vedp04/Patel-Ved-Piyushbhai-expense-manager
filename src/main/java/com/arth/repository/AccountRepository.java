package com.arth.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.arth.entity.AccountEntity;

public interface AccountRepository extends JpaRepository<AccountEntity, Integer> {

	List<AccountEntity> findByUserId(Integer userId);

}
