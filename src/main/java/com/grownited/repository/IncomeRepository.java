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

import com.grownited.entity.IncomeEntity;
import com.grownited.entity.UserEntity;

import jakarta.transaction.Transactional;

@Repository
public interface IncomeRepository extends JpaRepository<IncomeEntity, Integer>{
	List<IncomeEntity> findByUserId(Integer userId);
	
	@Query("SELECT SUM(i.amount) FROM IncomeEntity i " +
	           "WHERE i.userId = :userId " +
	           "  AND i.incomeDate >= :startDate " +
	           "  AND i.incomeDate <= :endDate")
	    BigDecimal sumByUserIdAndDateBetween(
	            @Param("userId")    Integer   userId,
	            @Param("startDate") LocalDate startDate,
	            @Param("endDate")   LocalDate endDate);
	
	@Query("SELECT SUM(i.amount) FROM IncomeEntity i WHERE i.userId = :userId")
	BigDecimal sumByUserId(Integer userId);

	@Query("SELECT SUM(i.amount) FROM IncomeEntity i")
	BigDecimal sumAll();

	// Paginated queries
	Page<IncomeEntity> findByUserId(Integer userId, Pageable pageable);
	Page<IncomeEntity> findByUserIdAndIncomeSourceContainingIgnoreCase(Integer userId, String keyword, Pageable pageable);
	Page<IncomeEntity> findByIncomeSourceContainingIgnoreCase(String keyword, Pageable pageable);
	
	@Transactional
	void deleteAllByUserId(Integer userId);
}
