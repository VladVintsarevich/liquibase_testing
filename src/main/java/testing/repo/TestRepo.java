package testing.repo;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import testing.model.UserTest;


@Repository
public interface TestRepo extends JpaRepository<UserTest, UUID> {
}
