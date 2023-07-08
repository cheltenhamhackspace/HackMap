
library(ggplot2)


room_aes <- ggplot2::aes(x = x,
                         y = y,
                         fill = "",
                         colour = "")

area_aes <- ggplot2::aes(xmin = xmin,
                         ymin = ymin,
                         xmax = xmax,
                         ymax = ymax,
                         fill = "",
                         colour = "")

expected_area_aes <- ggplot2::aes(xmin = xmin,
                                  ymin = ymin,
                                  xmax = xmax,
                                  ymax = ymax,
                                  fill = likelihood,
                                  colour = "")

area_label_aes <- ggplot2::aes(x = (xmin + xmax) / 2,
                               y = (ymin + ymax) / 2,
                               label = name)


plot_map <- function(itemName, show_area_names) {
  expected_area_df <- create_expected_areas_data_frame(itemName)
  
  plot <- ggplot2::ggplot()
  
  if (nrow(expected_area_df) > 0) {
    # Plot highlighted areas
    plot <- plot +
      ggplot2::geom_rect(data = expected_area_df, mapping = expected_area_aes)
  }
  
  plot <- plot +
    # Plot room outline
    ggplot2::geom_polygon(data = room_df, mapping = room_aes) +
    # Plot mapped areas
    ggplot2::geom_rect(data = area_df, mapping = area_aes)
  
  if (show_area_names) {
    plot <- plot +
      ggplot2::geom_text(data = area_df, mapping = area_label_aes)
  }
    
  plot <- plot +
    # Set outline colour
    scale_colour_manual(values=c("#000000")) +
    # Set fill colours
    scale_fill_manual(values=c("#ffffff00", "#bbffbb", "#ffffbb")) +
    # Fix aspect ratio
    coord_fixed() +
    # Remove legend
    guides(fill = FALSE, colour = FALSE) +
    # White background
    theme_bw() +
    # Remove axes etc.
    theme(
      plot.background = element_blank(),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.border = element_blank(),
      axis.title = element_blank(),
      axis.text = element_blank(),
      axis.ticks = element_blank()
    )
  
  minx <- min(room_df$x)
  maxx <- max(room_df$x)
  miny <- min(room_df$y)
  maxy <- max(room_df$y)
  padding = min((maxx - minx) * 0.2, (maxy - miny) * 0.2)
  
    # Set boundaries
  plot <- plot +
    xlim(minx - padding, maxx + padding) +
    ylim(miny - padding, maxy + padding)
  
  return(plot)
}
