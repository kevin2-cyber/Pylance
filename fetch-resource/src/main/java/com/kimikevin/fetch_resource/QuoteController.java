package com.kimikevin.fetch_resource;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class QuoteController {

    private final QuoteService quoteService;

    public QuoteController(QuoteService quoteService) {
        this.quoteService = quoteService;
    }

    @GetMapping("/api")
    public ResponseEntity<List<QuoteResource>> getAll() {
        return ResponseEntity.ok(quoteService.getAll());
    }

    @GetMapping("/api/{id}")
    public ResponseEntity<QuoteResource> getOne(@PathVariable Long id) {
        return ResponseEntity.ok(quoteService.getOne(id));
    }

    @GetMapping("/api/random")
    public ResponseEntity<QuoteResource> getRandomOne() {
        return ResponseEntity.ok(quoteService.getRandomOne());
    }
}