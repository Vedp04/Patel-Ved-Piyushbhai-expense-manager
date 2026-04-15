package com.arth.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.arth.entity.StatusEntity;

public interface StatusRepository extends JpaRepository<StatusEntity, Integer> {

}
