
library(rjson)
library(dplyr)


create_room_data_frame <- function(room_json) {
  x_vector <- c()
  y_vector <- c()
  for (corner in room_json$corners) {
    x_vector <- append(x_vector, corner$x)
    y_vector <- append(y_vector, corner$y)
  }
  
  df <- data.frame(x_vector, y_vector)
  colnames(df) <- c("x", "y")
  
  return(df)
}

create_areas_data_frame <- function(room_json) {
  name_vector <- c()
  xmin_vector <- c()
  ymin_vector <- c()
  xmax_vector <- c()
  ymax_vector <- c()
  for (area in room_json$areas) {
    name_vector <- append(name_vector, area$name)
    xmin_vector <- append(xmin_vector, area$x)
    ymin_vector <- append(ymin_vector, area$y)
    xmax_vector <- append(xmax_vector, area$x + area$width)
    ymax_vector <- append(ymax_vector, area$y + area$length)
  }
  
  df <- data.frame(name_vector, xmin_vector, ymin_vector, xmax_vector, ymax_vector)
  colnames(df) <- c("name", "xmin", "ymin", "xmax", "ymax")
  
  return(df)
}

create_items_data_frame <- function(items_json) {
  name_vector <- c()
  expected_areas_vector <- c()
  maybe_areas_vector <- c()
  for (item in items_json$items) {
    name_vector <- append(name_vector, item$name)
    expected_areas_vector <- append(expected_areas_vector, I(list(item$expected_areas)))
    maybe_areas_vector <- append(maybe_areas_vector, I(list(item$maybe_areas)))
  }
  
  df <- data.frame(name_vector, I(expected_areas_vector), I(maybe_areas_vector))
  colnames(df) <- c("name", "expected_areas", "maybe_areas")
  
  return(df)
}

room_json <- rjson::fromJSON(file = "room.json")
items_json <- rjson::fromJSON(file = "items.json")

room_df <- create_room_data_frame(room_json)
area_df <- create_areas_data_frame(room_json)
item_df <- create_items_data_frame(items_json)


create_expected_areas_data_frame <- function(selected_item) {
  if (!(selected_item %in% item_df$name)) {
    return(data.frame())
  }
  item <- dplyr::filter(item_df, name == selected_item)
  exp_areas <- dplyr::filter(area_df, name %in% item$expected_areas[[1]])
  exp_areas_df <- cbind(exp_areas, likelihood = "Expected")
  
  mayb_areas <- dplyr::filter(area_df, name %in% item$maybe_areas[[1]])
  if (nrow(mayb_areas) == 0) {
    mayb_areas_df <- data.frame()
  } else {
    mayb_areas_df <- cbind(mayb_areas, likelihood = "Maybe")
  }
  
  return(rbind(mayb_areas_df, exp_areas_df))
}
