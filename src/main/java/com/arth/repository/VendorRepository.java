package com.arth.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.arth.entity.VendorEntity;

public interface VendorRepository extends JpaRepository<VendorEntity, Integer> {

}
