package org.wallride.core.repository;

import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.wallride.core.domain.CustomField;
import org.wallride.core.domain.CustomField;

import javax.persistence.LockModeType;

@Repository
@Transactional
public interface CustomFieldRepository extends JpaRepository<CustomField, Long>, CustomFieldRepositoryCustom {

	CustomField findOneById(String id);

	@Lock(LockModeType.PESSIMISTIC_WRITE)
	CustomField findOneForUpdateById(Long id);

	@EntityGraph(value = CustomField.DEEP_GRAPH_NAME, type = EntityGraph.EntityGraphType.FETCH)
	CustomField findOneByIdAndLanguage(Long id, String language);

	@EntityGraph(value = CustomField.DEEP_GRAPH_NAME, type = EntityGraph.EntityGraphType.FETCH)
	@Lock(LockModeType.PESSIMISTIC_WRITE)
	CustomField findOneForUpdateByIdAndLanguage(Long id, String language);

	@EntityGraph(value = CustomField.DEEP_GRAPH_NAME, type = EntityGraph.EntityGraphType.FETCH)
	CustomField findOneByNameAndLanguage(String name, String language);

	@Query("select count(customfield.idx) from CustomField customfield where customfield.language = :language ")
	int count(@Param("language") String language);

	@Query("select count(customfield.idx) from CustomField customfield where customfield.language = :language ")
	@Lock(LockModeType.PESSIMISTIC_WRITE)
	int countForUpdate(@Param("language") String language);
}
