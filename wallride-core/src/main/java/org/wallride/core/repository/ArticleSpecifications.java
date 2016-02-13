/*
 * Copyright 2014 Tagbangers, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.wallride.core.repository;

import org.springframework.data.jpa.domain.Specification;
import org.wallride.core.domain.Article;
import org.wallride.core.domain.Article_;

import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import javax.persistence.criteria.Subquery;
import java.util.ArrayList;
import java.util.List;

public class ArticleSpecifications {

	public static Specification<Article> draft(Article article) {
		return (root, query, cb) -> {
			List<Predicate> predicates = new ArrayList<>();
			predicates.add(cb.equal(root.get(Article_.drafted), article));

			Subquery<Long> subquery = query.subquery(Long.class);
			Root<Article> p = subquery.from(Article.class);
			subquery.select(cb.max(p.get(Article_.id))).where(cb.equal(p.get(Article_.drafted), article));

			predicates.add(cb.equal(root.get(Article_.id), subquery));
			return cb.and(predicates.toArray(new Predicate[0]));
		};
	}
}