package com.arth.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.arth.entity.CategoryEntity;

public interface CategoryRepository extends JpaRepository<CategoryEntity, Integer> {

}
