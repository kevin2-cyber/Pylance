package com.kimikevin.fetch_resource;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Random;
import java.util.stream.Collectors;

@RestController
public class QuoteController {
    private final Quote NONE = new Quote("NONE");
    private final Random RANDOMIZER = new Random();

    private final QuoteRepository quoteRepository;

    public QuoteController(QuoteRepository quoteRepository) {
        this.quoteRepository = quoteRepository;
    }

    @GetMapping("/api")
    public List<QuoteResource> getAll() {
        return quoteRepository.findAll().stream()
                .map(quote -> new QuoteResource(quote,"success"))
                .collect(Collectors.toList());
    }

    @GetMapping("/api/{id}")
    public QuoteResource getOne(@PathVariable Long id) {
        return quoteRepository.findById(id)
                .map(quote -> new QuoteResource(quote, "success"))
                .orElse(new QuoteResource(NONE, "Quote " + id + " does not exist"));
    }

    @GetMapping("/api/random")
    public QuoteResource getRandomOne() {
        return getOne(nextLong(1, quoteRepository.count() + 1));
    }

    private Long nextLong(long lowerRange, long upperRange) {
        return (long) (RANDOMIZER.nextDouble() * (upperRange - lowerRange)) + lowerRange;
    }
}
