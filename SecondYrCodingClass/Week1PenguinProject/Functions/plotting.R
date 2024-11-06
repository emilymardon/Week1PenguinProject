plot_boxplot <- function(data,
                         x_column,
                         y_column,
                         x_label,
                         y_label){
  
  data <- data %>%
    drop_na(flipper_length_mm)

# now make the plot, change data name to data, as specified above
  flipper_boxplot <- ggplot(
    data = data, 
    aes(x = {{x_column}},
        y = {{y_column}}))+
    geom_boxplot(
      aes(color = {{x_column}}), show.legend = FALSE
    ) +
    geom_jitter(aes(color = {{x_label}}),
                alpha = 0.3,
                show.legend = FALSE,
                position = position_jitter(
                  width = 0.3,
                  seed = 0
                )) +
    scale_color_manual(values = species_colours) +
    labs(x = x_label,
         y = y_label) +
    theme_bw()
  
  flipper_boxplot
}


species_colours <- c("Adelie Penguin (Pygoscelis adeliae)" = "darkorange",
                     "Chinstrap penguin (Pygoscelis antarctica)" = "purple",
                     "Gentoo penguin (Pygoscelis papua)" = "darkcyan")


