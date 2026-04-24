package com.grownited.repository;

import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.grownited.entity.VendorEntity;

@Repository
public interface VendorRepository extends JpaRepository<VendorEntity, Integer> {
	Optional<VendorEntity> findByVendorNameIgnoreCase(String vendorName);

	// Paginated queries
	Page<VendorEntity> findByVendorNameContainingIgnoreCase(String keyword, Pageable pageable);
}
