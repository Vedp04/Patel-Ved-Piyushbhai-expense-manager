package com.grownited.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.grownited.entity.SubCategoryEntity;

@Repository
public interface SubCategoryRepository extends JpaRepository<SubCategoryEntity, Integer> {

	// Paginated queries
	Page<SubCategoryEntity> findBySubCategoryNameContainingIgnoreCase(String keyword, Pageable pageable);
}
