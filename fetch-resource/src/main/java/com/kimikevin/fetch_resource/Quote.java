package com.kimikevin.fetch_resource;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;

import java.util.Objects;

@Entity
public class Quote {
    @Id
    @GeneratedValue
    private Long id;
    private String quote;

    public Quote(String quote) {
        this.quote = quote;
    }

    protected Quote() {}
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getQuote() {
        return quote;
    }

    public void setQuote(String quote) {
        this.quote = quote;
    }

    @Override
    public boolean equals(Object other) {
        if (this == other)
            return true;
        if (!(other instanceof Quote otherQuote))
            return false;
        return Objects.equals(id, otherQuote.id) && Objects.equals(quote, otherQuote.quote);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, quote);
    }

    @Override
    public String toString() {
        return "Quote{" + "id=" + id + ", quote='" + quote + '\'' + '}';
    }
}
