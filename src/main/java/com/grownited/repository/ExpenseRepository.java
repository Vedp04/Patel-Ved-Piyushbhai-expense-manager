package com.grownited.repository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.grownited.entity.ExpenseEntity;
import com.grownited.entity.UserEntity;

import jakarta.transaction.Transactional;

@Repository
public interface ExpenseRepository extends JpaRepository<ExpenseEntity, Integer> {
	List<ExpenseEntity> findByUserId(Integer userId);
	
	@Query("SELECT SUM(e.amount) FROM ExpenseEntity e " +
	           "WHERE e.userId = :userId " +
	           "  AND e.expenseDate >= :startDate " +
	           "  AND e.expenseDate <= :endDate")
	    BigDecimal sumByUserIdAndDateBetween(
	            @Param("userId")    Integer   userId,
	            @Param("startDate") LocalDate startDate,
	            @Param("endDate")   LocalDate endDate);
	
	@Query("SELECT SUM(e.amount) FROM ExpenseEntity e WHERE e.userId = :userId")
    BigDecimal sumByUserId(@Param("userId") Integer userId);

	@Query("SELECT SUM(e.amount) FROM ExpenseEntity e")
	BigDecimal sumAll();
	
	List<ExpenseEntity> findTop9ByUserIdOrderByExpenseDateDesc(Integer userId);

	// Paginated queries
	Page<ExpenseEntity> findByUserId(Integer userId, Pageable pageable);
	Page<ExpenseEntity> findByUserIdAndDescriptionContainingIgnoreCase(Integer userId, String keyword, Pageable pageable);
	Page<ExpenseEntity> findByDescriptionContainingIgnoreCase(String keyword, Pageable pageable);
	
	@Transactional
	void deleteAllByUserId(Integer userId);
}
