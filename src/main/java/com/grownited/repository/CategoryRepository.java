package com.grownited.repository;


import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.grownited.entity.CategoryEntity;

@Repository
public interface CategoryRepository extends JpaRepository<CategoryEntity, Integer> {
	
	List<CategoryEntity> findByUserId(Integer userId);
	List<CategoryEntity> findByUserIdOrUserIdIsNull(Integer userId); // shared + personal

	// Paginated queries
	Page<CategoryEntity> findByCategoryNameContainingIgnoreCase(String keyword, Pageable pageable);
}
