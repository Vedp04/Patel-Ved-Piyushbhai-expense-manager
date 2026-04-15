package com.arth.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.arth.entity.IncomeEntity;

public interface IncomeRepository extends JpaRepository<IncomeEntity, Integer> {

	List<IncomeEntity> findByUserId(Integer userId);

}
