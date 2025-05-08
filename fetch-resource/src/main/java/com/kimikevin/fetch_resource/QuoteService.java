package com.kimikevin.fetch_resource;

import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;
import java.util.Random;
import java.util.stream.Collectors;

@Service
public class QuoteService {
    private final Quote NONE = new Quote("NONE");
    private final Random RANDOMIZER = new Random();

    private final QuoteRepository quoteRepository;

    public QuoteService(QuoteRepository quoteRepository) {
        this.quoteRepository = quoteRepository;
    }

    public List<QuoteResource> getAll() {
        return quoteRepository.findAll().stream()
                .map(quote -> new QuoteResource(quote,"success"))
                .collect(Collectors.toList());
    }

    public QuoteResource getOne(@PathVariable Long id) {
        return quoteRepository.findById(id)
                .map(quote -> new QuoteResource(quote, "success"))
                .orElse(new QuoteResource(NONE, "Quote " + id + " does not exist"));
    }

    public QuoteResource getRandomOne() {
        return getOne(nextLong(1, quoteRepository.count() + 1));
    }

    private Long nextLong(long lowerRange, long upperRange) {
        return (long) (RANDOMIZER.nextDouble() * (upperRange - lowerRange)) + lowerRange;
    }
}
