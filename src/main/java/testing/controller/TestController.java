package testing.controller;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.AllArgsConstructor;
import testing.model.UserTest;
import testing.service.TestService;

@RestController
@AllArgsConstructor
public class TestController {
    private final TestService service;

    @GetMapping("/test")
    public List<UserTest> findAll() {
        return service.findAll();
    }
}
