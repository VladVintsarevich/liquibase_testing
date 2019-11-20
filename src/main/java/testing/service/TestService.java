package testing.service;

import java.util.List;

import org.springframework.stereotype.Service;

import lombok.AllArgsConstructor;
import testing.model.UserTest;
import testing.repo.TestRepo;

@Service
@AllArgsConstructor
public class TestService {
    private final TestRepo repo;

    public List<UserTest> findAll() {
        return repo.findAll();
    }
}
