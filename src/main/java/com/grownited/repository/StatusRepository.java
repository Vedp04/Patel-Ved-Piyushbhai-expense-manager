package com.grownited.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.grownited.entity.StatusEntity;

@Repository
public interface StatusRepository extends JpaRepository<StatusEntity, Integer> {

}
