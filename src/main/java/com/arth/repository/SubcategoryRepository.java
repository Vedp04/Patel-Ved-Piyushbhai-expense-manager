package com.arth.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.arth.dto.SubCategoryDto;
import com.arth.entity.SubcategoryEntity;

public interface SubcategoryRepository extends JpaRepository<SubcategoryEntity, Integer> {
	@Query(value = "select s.sub_category_id as subCategoryId, s.category_id as categoryId, s.sub_category_name as subCategoryName, c.category_name as categoryName from subcategories s, categories c where s.category_id = c.category_id", nativeQuery = true)
	public List<SubCategoryDto> getAllSub();
}
