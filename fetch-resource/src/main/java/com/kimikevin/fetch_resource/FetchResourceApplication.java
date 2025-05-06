package com.kimikevin.fetch_resource;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class FetchResourceApplication {
//	private static final Logger log = LoggerFactory.getLogger(FetchResourceApplication.class);

	public static void main(String[] args) {
		SpringApplication.run(FetchResourceApplication.class, args);
	}

//	@Bean
//	public RestTemplate restTemplate(RestTemplateBuilder builder) {
//		return builder.build();
//	}
//
//	@Bean
//	@Profile("!test")
//	public CommandLineRunner run(RestTemplate restTemplate) throws Exception {
//		return args -> {
//			Quote quote = restTemplate.getForObject("http://localhost:8080/api/random", Quote.class);
//            assert quote != null;
//            log.info(quote.toString());
//		};
//	}

}