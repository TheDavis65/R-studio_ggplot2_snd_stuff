############## ggplot2 ###########

    pacman::p_load(pacman, dplyr, GGally, ggplot2, ggthemes,
               ggvis,httr, lubridate, plotly, rio, rmarkdown, shiny,
               stringr, tidyr, caret, lars, tidyverse, psych, dygraphs, vioplot)







library(tidyverse)

##### Mapping #####
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))
head(mpg)
view(mpg)
#ggplot(data = <DATA>) +
 # <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

##### Mapping with colors and shapes

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
### opg 1 kap 3
ggplot(data = mpg) +
  geom_point(mapping = aes(x = hwy, y = cyl, color = class))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue") 




### Mapping with size
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = class))

### Mapping alpha "gennemsigtighed" 
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))


# Left
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

# Right
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))

### Mapping med form kan kun vise 6 former er der fler forsvinder de
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))

### Mapping eksempel på en enkelt farve
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")


####### Facets
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = drv, y = cyl))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)

########## Mapping Geometric Objects ============

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data =  mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

######### Mapping Geometric Objects multi farver og former på graf

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))


ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, color = drv),
    show.legend = FALSE
  )

ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, color = drv),
              show.legend = FALSE
              )

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))
### en korter version af den ovenstående 
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth()

### med farver og kurver
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) +
  geom_smooth()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) +
  geom_smooth(
    data = filter(mpg, class == "subcompact"),
    se = FALSE
  )
  
ggplot(data = mpg,
       mapping = aes(x = displ, y = hwy, color = drv)
       ) +
  geom_point() +
  geom_smooth(se = FALSE)
## se = show.legend

### er de forskellige
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
geom_point() +
  geom_smooth()

ggplot() +
  geom_point(
    data = mpg,
    mapping = aes(x = displ, y = hwy)
  ) +
  geom_smooth(
    data = mpg,
    mapping = aes(x = displ, y = hwy)
  )


######### Statistical Transformations ##########

### geom_bar - barchart 
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))
head(diamonds)
### stat_count
ggplot(data = diamonds) +
  stat_count(mapping = aes(x = cut))
# giver samme resultat som ovenfor

### change stat from count(default) to identity

demo <- tribble(
  ~a, ~b,
  "bar_1", 20,
  "bar_2", 30,
  "bar_3", 40
)

ggplot(data = demo) +
  geom_bar(
    mapping = aes(x = a, y = b ), stat = "identity"
  )
### overrideing the default mapping from trans‐
#formed variables to aesthetics

### bar chart of proportion

ggplot(data = diamonds) +
  geom_bar(
    mapping = aes(x = cut, y = ..prop..,group = 1)
  )
### use stat_sum
# mary(), which summarizes the y values for each unique x value,
# to draw attention to the summary that you’re computing:
  
ggplot(data = diamonds) +
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun.y = median
  )


### what is the problem here
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, y = ..prop..))
ggplot(data = diamonds) +
  geom_bar(
    mapping = aes(x = cut, fill = color, y = ..prop..)
  )

### faver på bar chart
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, color = cut))
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = cut))

## her bliver der sat et nyt parameter på "clarity" med sin egen farve
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity))

### position 
ggplot(data = diamonds,
       mapping = aes(x = cut, fill = clarity)
       ) +
  geom_bar(alpha = 1/5, position = "identity")

ggplot(
  data = diamonds,
  mapping = aes(x = cut, color = clarity)
) +
  geom_bar(fill = NA, position = "identity")
  #position = "fill" works like stacking, but makes each set of
# stacked bars the same height. This makes it easier to compare
# proportions across groups:
ggplot(data = diamonds) +
  geom_bar(
    mapping = aes(x = cut, fill = clarity),
    position = "fill"
  )
# position = "dodge" places overlapping objects directly beside
# one another. This makes it easier to compare individual values:
ggplot(data = diamonds) +
  geom_bar(
    mapping = aes(x = cut, fill = clarity),
    position = "dodge"
  )
# “jitter.” position = "jitter" adds a small amount of random noise
# to each point. This spreads the points out because no two points are
# likely to receive the same amount of random noise
ggplot(data = mpg) +
  geom_point(
    mapping = aes(x = displ, y = hwy),
    position = "jitter"
  )


### Exercises
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point()

#### Coordinate Systems """""""""""""

## coord_flip() 
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot() +
  coord_flip()

### coord_quickmap()

nz <- map_data("nz")
ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", color = "black")
ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", color = "black") +
  coord_quickmap()

# coord_polar() uses polar coordinates. Polar coordinates reveal
# an interesting connection between a bar chart and a Coxcomb
# chart
bar <- ggplot(data = diamonds) +
  geom_bar(
    mapping = aes(x = cut, fill = cut),
    show.legend = FALSE,
    width = 1
  ) +
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

bar + coord_flip()
bar + coord_polar()



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



# Clear environment
rm(list = ls()) 

# Clear packages
detach("package:datasets", unload = TRUE)  # For base

# Clear plots
dev.off()  # But only if there IS a plot

# Clear console
cat("\014")  # ctrl+L

# Clear mind :)
