################# Models with purrr and broom ############

pacman::p_load(pacman, dplyr, GGally, ggplot2, ggthemes,
               ggvis,httr, lubridate, plotly, rio, rmarkdown, shiny,
               stringr, tidyr, caret, lars, tidyverse, psych, dygraphs, vioplot, gapminder)



library(modelr)
library(tidyverse)
library(gapminder)

gapminder
view(gapminder)


gapminder %>%
  ggplot(aes(year, lifeExp, group = country)) +
  geom_line(alpha = 1/3)



nz <- filter(gapminder, country == "New Zealand")
nz %>%
  ggplot(aes(year, lifeExp)) +
  geom_line() +
  ggtitle("Full data = ")
nz_mod <- lm(lifeExp ~ year, data = nz)
nz %>%
  add_predictions(nz_mod) %>%
  ggplot(aes(year, pred)) +
  geom_line() +
  ggtitle("Linear trend + ")
nz %>%
  add_residuals(nz_mod) %>%
  ggplot(aes(year, resid)) +
  geom_hline(yintercept = 0, color = "white", size = 3) +
  geom_line() +
  ggtitle("Remaining pattern")


by_country <- gapminder %>%
  group_by(country, continent) %>%
  nest()

by_country

by_country$data[[1]]

country_model <- function(df) {
  lm(lifeExp ~ year, data = df)
}

models <- map(by_country$data, country_model)

by_country <- by_country %>%
  mutate(model = map(data, country_model))
by_country
#> # A tibble: 142 × 4
#> country continent data model
#> <fctr> <fctr> <list> <list>
#> 1 Afghanistan Asia <tibble [12 × 4]> <S3: lm>
#> 2 Albania Europe <tibble [12 × 4]> <S3: lm>
#> 3 Algeria Africa <tibble [12 × 4]> <S3: lm>

by_country %>%
  filter(continent == "Europe")
#> # A tibble: 30 × 4
#> country continent data model
#> <fctr> <fctr> <list> <list>
#> 1 Albania Europe <tibble [12 × 4]> <S3: lm>
#> 2 Austria Europe <tibble [12 × 4]> <S3: lm>
#> 3 Belgium Europe <tibble [12 × 4]> <S3: lm>
#> 4 Bosnia and Herzegovina Europe <tibble [12 × 4]> <S3: lm>
#> 5 Bulgaria Europe <tibble [12 × 4]> <S3: lm>
#> 6 Croatia Europe <tibble [12 × 4]> <S3: lm>
#> # ... with 24 more rows


by_country %>%
arrange(continent, country)
#> # A tibble: 142 × 4
#> country continent data model
#> <fctr> <fctr> <list> <list>
#> 1 Algeria Africa <tibble [12 × 4]> <S3: lm>
#> 2 Angola Africa <tibble [12 × 4]> <S3: lm>
#> 3 Benin Africa <tibble [12 × 4]> <S3: lm>
#> 4 Botswana Africa <tibble [12 × 4]> <S3: lm>
#> 5 Burkina Faso Africa <tibble [12 × 4]> <S3: lm>
#> 6 Burundi Africa <tibble [12 × 4]> <S3: lm>
#> # ... with 136 more rows



by_country <- by_country %>%
  mutate(
    resids = map2(data, model, add_residuals)
  )
by_country

by_country <- by_country %>%
  mutate(
    resids = map2(data, model, add_residuals)
  )
by_country
#> # A tibble: 142 × 5
#> country continent data model
#> <fctr> <fctr> <list> <list>
#> 1 Afghanistan Asia <tibble [12 × 4]> <S3: lm>
#> 2 Albania Europe <tibble [12 × 4]> <S3: lm>
#> 3 Algeria Africa <tibble [12 × 4]> <S3: lm>
#> 4 Angola Africa <tibble [12 × 4]> <S3: lm>
#> 5 Argentina Americas <tibble [12 × 4]> <S3: lm>
#> 6 Australia Oceania <tibble [12 × 4]> <S3: lm>
#> # ... with 136 more rows, and 1 more variable:
#> # resids <list>

resids <- unnest(by_country, resids)
resids
#> # A tibble: 1,704 × 7
#> country continent year lifeExp pop gdpPercap
#> <fctr> <fctr> <int> <dbl> <int> <dbl>
#> 1 Afghanistan Asia 1952 28.8 8425333 779
#> 2 Afghanistan Asia 1957 30.3 9240934 821
#> 3 Afghanistan Asia 1962 32.0 10267083 853
#> 4 Afghanistan Asia 1967 34.0 11537966 836
#> 5 Afghanistan Asia 1972 36.1 13079460 740
#> 6 Afghanistan Asia 1977 38.4 14880372 786
#> # ... with 1,698 more rows, and 1 more variable: resid <dbl>





resids %>%
  ggplot(aes(year, resid)) +
  geom_line(aes(group = country), alpha = 1 / 3) +
  geom_smooth(se = FALSE)
#> `geom_smooth()` using method = 'gam'

resids %>%
  ggplot(aes(year, resid, group = country)) +
  geom_line(alpha = 1 / 3) +
  facet_wrap(~continent)


broom::glance(nz_mod)
#> r.squared adj.r.squared sigma statistic p.value df logLik
#> AIC BIC
#> 1 0.954 0.949 0.804 205 5.41e-08 2 -13.3
#> 32.6 34.1
#> deviance df.residual
#> 1 6.47 10

by_country %>%
  mutate(glance = map(model, broom::glance)) %>%
  unnest(glance)
#> # A tibble: 142 × 16
#> country continent data model
#> <fctr> <fctr> <list> <list>
#> 1 Afghanistan Asia <tibble [12 × 4]> <S3: lm>
#> 2 Albania Europe <tibble [12 × 4]> <S3: lm>
#> 3 Algeria Africa <tibble [12 × 4]> <S3: lm>
#> 4 Angola Africa <tibble [12 × 4]> <S3: lm>
#> 5 Argentina Americas <tibble [12 × 4]> <S3: lm>
#> 6 Australia Oceania <tibble [12 × 4]> <S3: lm>
#> # ... with 136 more rows, and 12 more variables:
#> # resids <list>, r.squared <dbl>, adj.r.squared <dbl>,
#> # sigma <dbl>, statistic <dbl>, p.value <dbl>, df <int>,
#> # logLik <dbl>, AIC <dbl>, BIC <dbl>, deviance <dbl>,
#> # df.residual <int>

glance <- by_country %>%
  mutate(glance = map(model, broom::glance)) %>%
  unnest(glance, .drop = TRUE)
glance

glance %>%
  arrange(r.squared)

glance %>%
  ggplot(aes(continent, r.squared)) +
  geom_jitter(width = 0.5)

bad_fit <- filter(glance, r.squared < 0.25)
gapminder %>%
  semi_join(bad_fit, by = "country") %>%
  ggplot(aes(year, lifeExp, color = country)) +
  geom_line()

##### List-Columns #####
data.frame(x = list(1:3, 3:5))

data.frame(
  x = I(list(1:3, 3:5)),
  y = c("1, 2", "3, 4, 5")
)

tibble(
  x = list(1:3, 3:5),
  y = c("1, 2", "3, 4, 5")
)

tribble(
  ~x, ~y,
  1:3, "1, 2",
  3:5, "3, 4, 5"
)

gapminder %>%
  group_by(country, continent) %>%
  nest()




# CLEAN UP #################################################

# Clear environment
rm(list = ls()) 

# Clear packages
detach("package:datasets", unload = TRUE)  # For base

# Clear plots
dev.off()  # But only if there IS a plot

# Clear console
cat("\014")  # ctrl+L

# Clear mind :)